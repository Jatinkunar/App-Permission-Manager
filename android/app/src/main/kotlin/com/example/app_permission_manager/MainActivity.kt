package com.example.app_permission_manager

import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.util.Base64
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import kotlin.concurrent.thread

class MainActivity : FlutterActivity() {
    private val CHANNEL = "app_permissions"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getInstalledApps" -> {
                    // Run on background thread to avoid ANR on the main/UI thread
                    thread {
                        try {
                            val apps = getInstalledApplications()
                            runOnUiThread { result.success(apps) }
                        } catch (e: Exception) {
                            runOnUiThread {
                                result.error("ERROR", "Failed to get installed apps: ${e.message}", null)
                            }
                        }
                    }
                }

                "getAppPermissions" -> {
                    val packageName = call.argument<String>("packageName")
                    if (packageName == null) {
                        result.error("INVALID_ARGUMENT", "Package name is required", null)
                        return@setMethodCallHandler
                    }
                    thread {
                        try {
                            val permissions = getAppPermissions(packageName)
                            runOnUiThread { result.success(permissions) }
                        } catch (e: Exception) {
                            runOnUiThread {
                                result.error("ERROR", "Failed to get permissions: ${e.message}", null)
                            }
                        }
                    }
                }

                "openAppSettings" -> {
                    val packageName = call.argument<String>("packageName")
                    if (packageName == null) {
                        result.error("INVALID_ARGUMENT", "Package name is required", null)
                        return@setMethodCallHandler
                    }
                    try {
                        openAppSettings(packageName)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("ERROR", "Failed to open settings: ${e.message}", null)
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun getInstalledApplications(): List<Map<String, Any>> {
        val pm = packageManager
        val apps = mutableListOf<Map<String, Any>>()

        val flags = PackageManager.GET_PERMISSIONS
        val packages: List<PackageInfo> = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            pm.getInstalledPackages(PackageManager.PackageInfoFlags.of(flags.toLong()))
        } else {
            @Suppress("DEPRECATION")
            pm.getInstalledPackages(flags)
        }

        for (packageInfo in packages) {
            try {
                // applicationInfo is nullable on API 33+ when using PackageInfoFlags
                val appInfo: ApplicationInfo = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    packageInfo.applicationInfo ?: continue
                } else {
                    @Suppress("DEPRECATION")
                    packageInfo.applicationInfo ?: continue
                }

                val appName = pm.getApplicationLabel(appInfo).toString()
                val pkgName = packageInfo.packageName

                // Encode app icon safely — adaptive icons can return -1 for intrinsic size
                val iconBase64 = encodeIconSafely(pm, appInfo)

                val permissionCount = packageInfo.requestedPermissions?.size ?: 0
                val isSystemApp = (appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0

                apps.add(
                    mapOf(
                        "appName" to appName,
                        "packageName" to pkgName,
                        "icon" to (iconBase64 ?: ""),
                        "permissionCount" to permissionCount,
                        "isSystemApp" to isSystemApp
                    )
                )
            } catch (_: Exception) {
                // Skip any app that fails — don't crash the whole scan
                continue
            }
        }

        return apps.sortedBy { (it["appName"] as? String) ?: "" }
    }

    /**
     * Safely encodes an app icon to a base64 PNG string.
     *
     * Adaptive icons (API 26+) can have intrinsicWidth = -1 which causes
     * Bitmap.createBitmap() to throw IllegalArgumentException. We use a
     * safe fallback size of 96x96 pixels in that case.
     */
    private fun encodeIconSafely(pm: PackageManager, appInfo: ApplicationInfo): String? {
        return try {
            val icon = pm.getApplicationIcon(appInfo)
            val safeWidth = if (icon.intrinsicWidth > 0) icon.intrinsicWidth else 96
            val safeHeight = if (icon.intrinsicHeight > 0) icon.intrinsicHeight else 96

            val bitmap = Bitmap.createBitmap(safeWidth, safeHeight, Bitmap.Config.ARGB_8888)
            val canvas = Canvas(bitmap)
            icon.setBounds(0, 0, safeWidth, safeHeight)
            icon.draw(canvas)

            val stream = ByteArrayOutputStream()
            // Use JPEG with 80% quality for smaller payload — still looks good at list size
            bitmap.compress(Bitmap.CompressFormat.JPEG, 80, stream)
            bitmap.recycle()

            Base64.encodeToString(stream.toByteArray(), Base64.NO_WRAP)
        } catch (_: Exception) {
            null
        }
    }

    private fun getAppPermissions(packageName: String): Map<String, Any> {
        val pm = packageManager
        return try {
            val packageInfo: PackageInfo = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                pm.getPackageInfo(
                    packageName,
                    PackageManager.PackageInfoFlags.of(PackageManager.GET_PERMISSIONS.toLong())
                )
            } else {
                @Suppress("DEPRECATION")
                pm.getPackageInfo(packageName, PackageManager.GET_PERMISSIONS)
            }

            val requestedPermissions = packageInfo.requestedPermissions?.toList() ?: emptyList()
            val grantedPermissions = mutableListOf<String>()

            requestedPermissions.forEachIndexed { index, permission ->
                val flags = packageInfo.requestedPermissionsFlags?.getOrNull(index) ?: 0
                if ((flags and PackageInfo.REQUESTED_PERMISSION_GRANTED) != 0) {
                    grantedPermissions.add(permission)
                }
            }

            mapOf(
                "requestedPermissions" to requestedPermissions,
                "grantedPermissions" to grantedPermissions
            )
        } catch (_: Exception) {
            mapOf(
                "requestedPermissions" to emptyList<String>(),
                "grantedPermissions" to emptyList<String>()
            )
        }
    }

    private fun openAppSettings(packageName: String) {
        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
            data = Uri.parse("package:$packageName")
            flags = Intent.FLAG_ACTIVITY_NEW_TASK
        }
        startActivity(intent)
    }
}

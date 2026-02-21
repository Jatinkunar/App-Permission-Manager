import '../models/permission_info.dart';

class PermissionDatabase {
  static final Map<String, Map<String, dynamic>> _permissionData = {
    // Camera
    'android.permission.CAMERA': {
      'displayName': 'Camera',
      'category': PermissionCategory.dangerous,
      'description': 'Allows the app to take pictures and record videos using the camera.',
      'risk': 'Apps can secretly record photos or videos without your knowledge.',
    },
    
    // Location
    'android.permission.ACCESS_FINE_LOCATION': {
      'displayName': 'Precise Location',
      'category': PermissionCategory.dangerous,
      'description': 'Allows the app to access your precise location using GPS.',
      'risk': 'Apps can track your exact location and movement patterns.',
    },
    'android.permission.ACCESS_COARSE_LOCATION': {
      'displayName': 'Approximate Location',
      'category': PermissionCategory.dangerous,
      'description': 'Allows the app to access your approximate location using network data.',
      'risk': 'Apps can determine your general area and track your movements.',
    },
    'android.permission.ACCESS_BACKGROUND_LOCATION': {
      'displayName': 'Background Location',
      'category': PermissionCategory.dangerous,
      'description': 'Allows the app to access location even when not in use.',
      'risk': 'Apps can continuously track your location, draining battery and compromising privacy.',
    },
    
    // Microphone
    'android.permission.RECORD_AUDIO': {
      'displayName': 'Microphone',
      'category': PermissionCategory.dangerous,
      'description': 'Allows the app to record audio using the microphone.',
      'risk': 'Apps can listen to and record your conversations without notification.',
    },
    
    // Contacts
    'android.permission.READ_CONTACTS': {
      'displayName': 'Read Contacts',
      'category': PermissionCategory.dangerous,
      'description': 'Allows the app to read your contact list.',
      'risk': 'Apps can access names, phone numbers, and email addresses of all your contacts.',
    },
    'android.permission.WRITE_CONTACTS': {
      'displayName': 'Modify Contacts',
      'category': PermissionCategory.dangerous,
      'description': 'Allows the app to modify or add contacts.',
      'risk': 'Apps can add, modify, or delete contacts without your permission.',
    },
    
    // Storage
    'android.permission.READ_EXTERNAL_STORAGE': {
      'displayName': 'Read Storage',
      'category': PermissionCategory.dangerous,
      'description': 'Allows the app to read files from your device storage.',
      'risk': 'Apps can access your photos, documents, and other personal files.',
    },
    'android.permission.WRITE_EXTERNAL_STORAGE': {
      'displayName': 'Write Storage',
      'category': PermissionCategory.dangerous,
      'description': 'Allows the app to write files to your device storage.',
      'risk': 'Apps can modify or delete your files and photos.',
    },
    'android.permission.READ_MEDIA_IMAGES': {
      'displayName': 'Read Photos',
      'category': PermissionCategory.dangerous,
      'description': 'Allows the app to read images from your device.',
      'risk': 'Apps can access all your photos and images.',
    },
    'android.permission.READ_MEDIA_VIDEO': {
      'displayName': 'Read Videos',
      'category': PermissionCategory.dangerous,
      'description': 'Allows the app to read videos from your device.',
      'risk': 'Apps can access all your videos.',
    },
    'android.permission.READ_MEDIA_AUDIO': {
      'displayName': 'Read Audio',
      'category': PermissionCategory.dangerous,
      'description': 'Allows the app to read audio files from your device.',
      'risk': 'Apps can access your music and audio recordings.',
    },
    
    // SMS
    'android.permission.SEND_SMS': {
      'displayName': 'Send SMS',
      'category': PermissionCategory.dangerous,
      'description': 'Allows the app to send SMS messages.',
      'risk': 'Apps can send premium SMS messages, costing you money.',
    },
    'android.permission.READ_SMS': {
      'displayName': 'Read SMS',
      'category': PermissionCategory.dangerous,
      'description': 'Allows the app to read your SMS messages.',
      'risk': 'Apps can read your private text messages and verification codes.',
    },
    'android.permission.RECEIVE_SMS': {
      'displayName': 'Receive SMS',
      'category': PermissionCategory.dangerous,
      'description': 'Allows the app to receive and read incoming SMS messages.',
      'risk': 'Apps can intercept your incoming messages including OTPs.',
    },
    
    // Phone
    'android.permission.READ_PHONE_STATE': {
      'displayName': 'Phone State',
      'category': PermissionCategory.dangerous,
      'description': 'Allows the app to access phone features including phone number and device ID.',
      'risk': 'Apps can identify your device and phone number.',
    },
    'android.permission.CALL_PHONE': {
      'displayName': 'Make Calls',
      'category': PermissionCategory.dangerous,
      'description': 'Allows the app to make phone calls.',
      'risk': 'Apps can make calls without your permission, potentially to premium numbers.',
    },
    'android.permission.READ_CALL_LOG': {
      'displayName': 'Read Call Log',
      'category': PermissionCategory.dangerous,
      'description': 'Allows the app to read your call history.',
      'risk': 'Apps can see who you call and when.',
    },
    
    // Calendar
    'android.permission.READ_CALENDAR': {
      'displayName': 'Read Calendar',
      'category': PermissionCategory.dangerous,
      'description': 'Allows the app to read your calendar events.',
      'risk': 'Apps can see your schedule and appointments.',
    },
    'android.permission.WRITE_CALENDAR': {
      'displayName': 'Modify Calendar',
      'category': PermissionCategory.dangerous,
      'description': 'Allows the app to add or modify calendar events.',
      'risk': 'Apps can add, modify, or delete your calendar events.',
    },
    
    // Body Sensors
    'android.permission.BODY_SENSORS': {
      'displayName': 'Body Sensors',
      'category': PermissionCategory.dangerous,
      'description': 'Allows the app to access data from health sensors.',
      'risk': 'Apps can access your heart rate and other health data.',
    },
    
    // Internet & Network
    'android.permission.INTERNET': {
      'displayName': 'Internet Access',
      'category': PermissionCategory.normal,
      'description': 'Allows the app to access the internet.',
      'risk': 'Required for most apps. Can be used to send data to external servers.',
    },
    'android.permission.ACCESS_NETWORK_STATE': {
      'displayName': 'Network State',
      'category': PermissionCategory.normal,
      'description': 'Allows the app to view information about network connections.',
      'risk': 'Low risk - only provides network connectivity information.',
    },
    'android.permission.ACCESS_WIFI_STATE': {
      'displayName': 'WiFi State',
      'category': PermissionCategory.normal,
      'description': 'Allows the app to view WiFi connection information.',
      'risk': 'Low risk - only provides WiFi connectivity information.',
    },
    
    // Bluetooth
    'android.permission.BLUETOOTH': {
      'displayName': 'Bluetooth',
      'category': PermissionCategory.normal,
      'description': 'Allows the app to connect to Bluetooth devices.',
      'risk': 'Low risk - allows connection to Bluetooth accessories.',
    },
    'android.permission.BLUETOOTH_CONNECT': {
      'displayName': 'Bluetooth Connect',
      'category': PermissionCategory.dangerous,
      'description': 'Allows the app to connect to paired Bluetooth devices.',
      'risk': 'Apps can connect to your Bluetooth devices.',
    },
    'android.permission.BLUETOOTH_SCAN': {
      'displayName': 'Bluetooth Scan',
      'category': PermissionCategory.dangerous,
      'description': 'Allows the app to discover and pair Bluetooth devices.',
      'risk': 'Apps can scan for nearby Bluetooth devices, potentially tracking your location.',
    },
    
    // Notifications
    'android.permission.POST_NOTIFICATIONS': {
      'displayName': 'Notifications',
      'category': PermissionCategory.dangerous,
      'description': 'Allows the app to show notifications.',
      'risk': 'Apps can send you notifications, which may be spam or misleading.',
    },
    
    // Other common permissions
    'android.permission.VIBRATE': {
      'displayName': 'Vibrate',
      'category': PermissionCategory.normal,
      'description': 'Allows the app to control the vibrator.',
      'risk': 'Very low risk - only controls device vibration.',
    },
    'android.permission.WAKE_LOCK': {
      'displayName': 'Prevent Sleep',
      'category': PermissionCategory.normal,
      'description': 'Allows the app to prevent the device from sleeping.',
      'risk': 'Can drain battery if misused.',
    },
    'android.permission.RECEIVE_BOOT_COMPLETED': {
      'displayName': 'Run at Startup',
      'category': PermissionCategory.normal,
      'description': 'Allows the app to start automatically when device boots.',
      'risk': 'Apps can run in background, potentially affecting performance.',
    },
    'android.permission.FOREGROUND_SERVICE': {
      'displayName': 'Foreground Service',
      'category': PermissionCategory.normal,
      'description': 'Allows the app to run in the foreground.',
      'risk': 'Apps can run continuously, potentially draining battery.',
    },
  };

  static PermissionInfo getPermissionInfo(String permissionName) {
    final data = _permissionData[permissionName];
    
    if (data != null) {
      return PermissionInfo(
        name: permissionName,
        displayName: data['displayName'] as String,
        category: data['category'] as PermissionCategory,
        description: data['description'] as String,
        riskExplanation: data['risk'] as String,
      );
    }
    
    // Default for unknown permissions
    return PermissionInfo(
      name: permissionName,
      displayName: _formatPermissionName(permissionName),
      category: PermissionCategory.normal,
      description: 'This permission allows the app to perform specific operations.',
      riskExplanation: 'Unknown permission. Review carefully before granting.',
    );
  }

  static String _formatPermissionName(String permissionName) {
    // Extract the last part of the permission name and format it
    final parts = permissionName.split('.');
    final lastPart = parts.isNotEmpty ? parts.last : permissionName;
    
    // Convert UPPER_CASE to Title Case
    return lastPart
        .split('_')
        .map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  static List<String> getDangerousPermissions() {
    return _permissionData.entries
        .where((entry) => entry.value['category'] == PermissionCategory.dangerous)
        .map((entry) => entry.key)
        .toList();
  }
}

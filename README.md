# App Permission Manager

A Flutter-based Android application that helps users monitor, analyze, and understand permissions granted to installed applications with risk assessment and privacy education.

## Features

### 📱 Core Functionality
- **App Scanning**: Fetches all installed applications using Android PackageManager
- **Permission Analysis**: Retrieves and categorizes all granted permissions for each app
- **Risk Assessment**: Calculates risk levels (Low/Medium/High) based on dangerous permissions
- **Permission Control**: Direct navigation to system settings for permission management

### 🎨 User Interface
- **Splash Screen**: Animated welcome screen featuring the branded App Icon
- **App List Screen**: Searchable, filterable list of all installed apps with risk indicators
- **App Detail Screen**: Complete permission breakdown with explanations
- **Dashboard**: Privacy overview with statistics and high-risk app alerts
- **Education Screen**: Dynamic real-time privacy tips powered by a REST API integration

### 🔒 Privacy Configuration & Security
- Risk scoring algorithm based on dangerous permissions
- Color-coded risk indicators (Green/Orange/Red)
- Detailed permission descriptions and privacy risks
- API-driven privacy education modules
- Fully functional production-ready build with updated App Name properly configured

## Technical Stack

- **Frontend**: Flutter (Dart)
- **Native Integration**: Kotlin (Android)
- **Architecture**: Clean architecture with separation of concerns
- **State Management**: Provider pattern
- **Platform**: Android (API 21+)

## Project Structure

```
lib/
├── models/          # Data models
│   ├── app_info.dart
│   ├── permission_info.dart
│   └── risk_level.dart
├── services/        # Business logic
│   ├── permission_service.dart
│   ├── risk_analyzer.dart
│   └── permission_database.dart
├── screens/         # UI screens
│   ├── splash_screen.dart
│   ├── app_list_screen.dart
│   ├── app_detail_screen.dart
│   ├── dashboard_screen.dart
│   └── education_screen.dart
├── widgets/         # Reusable widgets
│   ├── app_card.dart
│   ├── risk_indicator.dart
│   └── permission_chip.dart
├── utils/           # Constants and helpers
│   └── constants.dart
└── main.dart        # App entry point

android/
└── app/src/main/kotlin/
    └── MainActivity.kt  # Native Android integration
```

## Setup Instructions

### Prerequisites
- Flutter SDK (3.10.7 or higher)
- Android Studio or VS Code with Flutter extensions
- Android SDK (API 21 or higher)
- Physical Android device or emulator

### Installation

1. **Clone or navigate to the project directory**:
   ```bash
   cd C:\Users\Jatin\.gemini\antigravity\scratch\app_permission_manager
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Connect an Android device or start an emulator**

4. **Run the app**:
   ```bash
   flutter run
   ```

### Building APK

To build a debug APK:
```bash
flutter build apk --debug
```

To build a release APK:
```bash
flutter build apk --release
```

The APK will be located at: `build/app/outputs/flutter-apk/app-release.apk`

## Permissions Required

The app requires the following permission in AndroidManifest.xml:

- `QUERY_ALL_PACKAGES`: Required for Android 11+ to access the full list of installed packages

**Note**: This permission may require special declaration if publishing to Google Play Store.

## How It Works

### Native Android Integration

The app uses Flutter's MethodChannel to communicate with native Android code:

1. **getInstalledApps()**: Retrieves list of all installed applications with metadata
2. **getAppPermissions(packageName)**: Gets requested and granted permissions for a specific app
3. **openAppSettings(packageName)**: Opens system settings for permission management

### Risk Calculation Algorithm

Risk levels are calculated based on:

- **High Risk**: 
  - 5+ dangerous permissions
  - Location + Camera/Microphone combination
  - SMS + Contacts combination

- **Medium Risk**:
  - 2-4 dangerous permissions
  - Single sensitive permission (Location, Camera, or Microphone)

- **Low Risk**:
  - Only normal permissions
  - 0-1 dangerous permissions

## Usage

1. **Launch the app** - View splash screen with app logo
2. **Browse apps** - See all installed apps with risk indicators
3. **Search & Filter** - Find specific apps or sort by risk/permissions
4. **View details** - Tap any app to see detailed permission breakdown
5. **Manage permissions** - Tap "Open App Settings" to modify permissions
6. **Check dashboard** - View privacy statistics and high-risk apps
7. **Learn** - Read privacy education section for best practices

## Important Notes

- The app **cannot directly modify permissions** due to Android security policies
- It provides information and guides users to system settings
- Risk assessments are based on permission types, not actual app behavior
- System apps are included but can be filtered out

## Future Enhancements

- Permission history tracking
- App usage statistics integration
- Export privacy reports
- Dark/Light theme toggle
- Multi-language support
- Permission change notifications

## License

This project is created for educational and privacy awareness purposes.



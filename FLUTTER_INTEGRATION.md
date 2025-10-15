# Integrating LaraPush SDK with Flutter Android Apps

This guide shows how to add LaraPush to any Flutter Android app with minimal native changes.

## 1) Requirements

- Flutter 3.10+
- Android Studio + Android SDK
- Firebase project (for FCM)
- LaraPush panel URL

## 2) Install the Flutter Plugin

Add the LaraPush Flutter plugin to your `pubspec.yaml`:

```yaml
dependencies:
  larapush:
    path: ../path/to/larapush-android-sdk/flutter
```

Or if published to pub.dev:

```yaml
dependencies:
  larapush: ^1.0.0
```

## 3) Configure Android Build Files

### Edit `android/app/build.gradle`:

```gradle
apply plugin: "com.google.gms.google-services"

android {
  // existing config...
}

dependencies {
  // LaraPush SDK
  implementation("com.github.dhirajabrandzzy:larapush-android-sdk:V10")

  // Firebase
  implementation(platform("com.google.firebase:firebase-bom:33.7.0"))
  implementation("com.google.firebase:firebase-analytics")
}
```

### Edit `android/build.gradle`:

```gradle
buildscript {
  ext {
    // existing versions...
  }
  repositories {
    google()
    mavenCentral()
  }
  dependencies {
    classpath("com.android.tools.build:gradle")
    classpath("org.jetbrains.kotlin:kotlin-gradle-plugin")
    classpath("com.google.gms:google-services:4.4.2")
  }
}
```

## 4) Add Firebase Configuration

1. In Firebase Console, add your Android app:
   - Package name: your app id (e.g. `com.myapp`)
2. Download `google-services.json`
3. Place it at: `android/app/google-services.json`

**Important**: Ensure the `package_name` inside the JSON matches your `applicationId` in `android/app/build.gradle`.

## 5) Configure AndroidManifest.xml

Edit `android/app/src/main/AndroidManifest.xml`:

Add permissions near the top:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

Register LaraPush service and click handler inside `<application>`:
```xml
<!-- LaraPush Firebase Messaging Service -->
<service
    android:name="io.larapush.sdk.LaraPushNotification"
    android:exported="false">
  <intent-filter>
    <action android:name="com.google.firebase.MESSAGING_EVENT" />
  </intent-filter>
</service>

<!-- LaraPush Notification Click Handler Activity -->
<activity
    android:name="io.larapush.sdk.NotificationClickHandlerActivity"
    android:exported="false"
    android:theme="@android:style/Theme.Translucent.NoTitleBar" />
```

## 6) Initialize LaraPush in Flutter

### In your main.dart or initialization code:

```dart
import 'package:larapush/larapush.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize LaraPush
  await initializeLaraPush();
  
  runApp(MyApp());
}

Future<void> initializeLaraPush() async {
  try {
    await LaraPush.initialize(
      panelUrl: "https://<your-larapush-panel-domain>/", // e.g. https://v5-beta24.larapu.sh/
      applicationId: "<your.app.id>",                    // e.g. com.myapp
      debug: true,
    );
    
    // Optional: Simple sanity test
    final token = await LaraPush.getToken();
    print("FCM token: $token");
    
    await LaraPush.setTags(["flutter", "debug"]);
  } catch (e) {
    print("LaraPush initialization error: $e");
  }
}
```

## 7) Usage Examples

### Set User Tags
```dart
try {
  await LaraPush.setTags(["premium-user", "notifications-enabled"]);
  print("Tags set successfully");
} catch (e) {
  print("Error setting tags: $e");
}
```

### Remove Tags
```dart
try {
  await LaraPush.removeTags(["premium-user"]);
  print("Tags removed successfully");
} catch (e) {
  print("Error removing tags: $e");
}
```

### Get Current Tags
```dart
try {
  final tags = await LaraPush.getTags();
  print("Current tags: $tags");
} catch (e) {
  print("Error getting tags: $e");
}
```

### Get FCM Token
```dart
try {
  final token = await LaraPush.getToken();
  print("FCM Token: $token");
} catch (e) {
  print("Error getting token: $e");
}
```

### Check Notification Status
```dart
try {
  final enabled = await LaraPush.areNotificationsEnabled();
  print("Notifications enabled: $enabled");
} catch (e) {
  print("Error checking notification status: $e");
}
```

### Refresh Token
```dart
try {
  await LaraPush.refreshToken();
  print("Token refreshed successfully");
} catch (e) {
  print("Error refreshing token: $e");
}
```

## 8) Build and Run

From your project root:
```bash
flutter clean
flutter pub get
flutter run
```

If you encounter issues:
- Uninstall old app: `adb uninstall <your.app.id>`
- Clean build: `flutter clean && flutter pub get`

## 9) Configure LaraPush Panel

In your LaraPush panel:
1. Add your Firebase project credentials (Server Key, Sender ID)
2. Create campaigns and send notifications

## 10) Error Handling

The plugin throws `LaraPushException` for errors:

```dart
try {
  await LaraPush.setTags(["test"]);
} on LaraPushException catch (e) {
  print("LaraPush Error - Code: ${e.code}, Message: ${e.message}");
}
```

## Important Notes

- `google-services.json` package_name must match applicationId
- Make sure the Google Services Gradle plugin is applied
- `POST_NOTIFICATIONS` permission is needed on Android 13+
- Ensure your `panelUrl` ends with a trailing slash
- The plugin requires Flutter 3.10+ and Android API 21+

## Troubleshooting

### Common Issues:

1. **Build fails with "google-services plugin not applied"**
   - Make sure you have `apply plugin: "com.google.gms.google-services"` in `android/app/build.gradle`

2. **"LaraPush must be initialized first" error**
   - Ensure you call `LaraPush.initialize()` before using any other methods

3. **Notifications not received**
   - Check if `google-services.json` is in the correct location
   - Verify Firebase project configuration
   - Ensure device has internet connection

4. **Permission denied errors**
   - Add `POST_NOTIFICATIONS` permission to AndroidManifest.xml
   - Request runtime permission on Android 13+

## API Reference

### LaraPush Class Methods:

- `initialize({required String panelUrl, required String applicationId, bool debug = false})` - Initialize the SDK
- `setTags(List<String> tags)` - Add tags to user subscription
- `removeTags(List<String> tags)` - Remove specific tags
- `clearTags()` - Remove all tags
- `getTags()` - Get current tags
- `getToken()` - Get FCM token
- `refreshToken()` - Force refresh token
- `areNotificationsEnabled()` - Check notification status

All methods return `Future` and can throw `LaraPushException`.

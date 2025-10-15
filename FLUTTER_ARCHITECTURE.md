# LaraPush Flutter Integration Architecture

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        Flutter App                             │
├─────────────────────────────────────────────────────────────────┤
│  Dart Code                                                      │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │ import 'package:larapush/larapush.dart';                   │ │
│  │                                                            │ │
│  │ await LaraPush.initialize(...);                           │ │
│  │ await LaraPush.setTags(["user", "premium"]);              │ │
│  │ String token = await LaraPush.getToken();                 │ │
│  └─────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                                │
                                │ MethodChannel
                                │ ('larapush')
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Flutter Plugin Layer                        │
├─────────────────────────────────────────────────────────────────┤
│  Android Kotlin Code                                           │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │ class LaraPushPlugin : FlutterPlugin, MethodCallHandler    │ │
│  │                                                            │ │
│  │ onMethodCall(call: MethodCall, result: Result) {          │ │
│  │   when (call.method) {                                     │ │
│  │     "initialize" -> initialize(call, result)              │ │
│  │     "setTags" -> setTags(call, result)                    │ │
│  │     "getToken" -> getToken(result)                        │ │
│  │   }                                                       │ │
│  │ }                                                         │ │
│  └─────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                                │
                                │ Direct calls
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                   LaraPush Core SDK                            │
├─────────────────────────────────────────────────────────────────┤
│  Kotlin Classes                                                │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │ class LaraPush {                                            │ │
│  │   suspend fun setTags(vararg tags: String)                 │ │
│  │   suspend fun getToken(): String                           │ │
│  │   fun areNotificationsEnabled(): Boolean                   │ │
│  │ }                                                          │ │
│  └─────────────────────────────────────────────────────────────┘ │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │ class LaraPushNotification : FirebaseMessagingService {    │ │
│  │   override fun onMessageReceived(remoteMessage)            │ │
│  │   override fun onNewToken(token: String)                   │ │
│  │ }                                                          │ │
│  └─────────────────────────────────────────────────────────────┘ │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │ class NotificationClickHandlerActivity : Activity {        │ │
│  │   override fun onCreate(savedInstanceState)                │ │
│  │ }                                                          │ │
│  └─────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                                │
                                │ Firebase FCM
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Firebase Cloud                            │
│                     Messaging (FCM)                            │
└─────────────────────────────────────────────────────────────────┘
```

## Key Components

### 1. Flutter Dart Layer
- **File**: `flutter/lib/larapush.dart`
- **Purpose**: Provides Dart API for Flutter developers
- **Features**: 
  - Async/await support
  - Type-safe method calls
  - Exception handling with `LaraPushException`

### 2. Flutter Plugin Layer
- **File**: `flutter/android/src/main/kotlin/io/larapush/flutter/LaraPushPlugin.kt`
- **Purpose**: Bridges Flutter MethodChannel to LaraPush SDK
- **Features**:
  - Method channel communication
  - Coroutine handling for suspend functions
  - Error propagation to Flutter

### 3. Core SDK (Unchanged)
- **Files**: `library/src/main/kotlin/io/larapush/sdk/`
- **Purpose**: Core push notification functionality
- **Features**:
  - Firebase FCM integration
  - Tag management
  - Token handling
  - Notification display

## Integration Flow

### Initialization Flow:
1. Flutter app calls `LaraPush.initialize(...)`
2. MethodChannel passes call to `LaraPushPlugin.initialize()`
3. Plugin creates `LaraPushConfig` and calls `LaraPush.init()`
4. Core SDK initializes Firebase and registers services

### Tag Management Flow:
1. Flutter app calls `LaraPush.setTags(["tag1", "tag2"])`
2. MethodChannel passes tags to `LaraPushPlugin.setTags()`
3. Plugin calls `LaraPush.getInstance().setTags(*tagsArray)`
4. Core SDK updates SharedPreferences and sends broadcast

### Notification Receiving Flow:
1. Firebase sends push notification to device
2. `LaraPushNotification.onMessageReceived()` handles the message
3. SDK displays notification using Android NotificationManager
4. User taps notification → `NotificationClickHandlerActivity` opens

## Benefits of This Architecture

1. **Minimal Changes**: Core SDK remains unchanged, only bridge layer added
2. **Type Safety**: Flutter Dart API provides compile-time type checking
3. **Async Support**: Full async/await support in Flutter
4. **Error Handling**: Proper exception handling with custom exception types
5. **Maintainability**: Clear separation between Flutter bridge and core functionality
6. **Reusability**: Core SDK can still be used in native Android apps

## File Structure

```
larapush-android-sdk/
├── library/                          # Core SDK (unchanged)
│   ├── src/main/kotlin/io/larapush/sdk/
│   │   ├── LaraPush.kt
│   │   ├── LaraPushConfig.kt
│   │   ├── LaraPushNotification.kt
│   │   └── NotificationClickHandlerActivity.kt
│   └── build.gradle
├── react-native/                     # React Native bridge (existing)
│   └── android/src/main/java/io/larapush/react/
├── flutter/                          # Flutter plugin (new)
│   ├── android/
│   │   ├── src/main/kotlin/io/larapush/flutter/
│   │   │   ├── LaraPushPlugin.kt
│   │   │   └── LaraPushPluginRegistrant.kt
│   │   ├── src/main/AndroidManifest.xml
│   │   └── build.gradle
│   ├── lib/
│   │   └── larapush.dart
│   ├── example/
│   │   ├── lib/main.dart
│   │   └── pubspec.yaml
│   └── pubspec.yaml
└── FLUTTER_INTEGRATION.md           # Integration guide
```

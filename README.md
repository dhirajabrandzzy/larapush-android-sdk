# LaraPush Android SDK

[![Release](https://jitpack.io/v/dhirajabrandzzy/larapush-android-sdk.svg)](https://jitpack.io/#dhirajabrandzzy/larapush-android-sdk)

LaraPush Android SDK for push notifications with support for React Native and Flutter.

## Installation

Add it to your build.gradle with:
```gradle
allprojects {
    repositories {
        maven { url "https://jitpack.io" }
    }
}
```

and:

```gradle
dependencies {
    implementation 'com.github.dhirajabrandzzy:larapush-android-sdk:V12.0'
}
```

## React Native Support

The React Native module is available separately. To use it:

1. Copy the `react-native` folder to your React Native project
2. Add the module to your `settings.gradle`:
   ```gradle
   include ':react-native'
   ```
3. Add the dependency to your app's `build.gradle`:
   ```gradle
   dependencies {
       implementation project(':react-native')
   }
   ```

## Flutter Support

Flutter integration is available in the `flutter/` directory. See the Flutter documentation for setup instructions.

## Usage

### Android (Kotlin/Java)

```kotlin
val config = LaraPushConfig(
    panelUrl = "your-panel-url",
    applicationId = "your-app-id",
    debug = true
)
LaraPush.init(context, config)
```

### React Native

```javascript
import { LaraPushModule } from 'react-native';

LaraPushModule.initialize('your-panel-url', 'your-app-id', true);
```

### Flutter

```dart
import 'package:larapush/larapush.dart';

await LaraPush.initialize(
  panelUrl: 'your-panel-url',
  applicationId: 'your-app-id',
  debug: true,
);
```

## Building the SDK

### Main Library Build
```bash
./gradlew clean assemble
```

### React Native Module Build (separate)
```bash
./gradlew -c settings-react-native.gradle clean assemble
```

## JitPack Integration

This library is automatically built and published via JitPack when you push tags to GitHub.

- Build status: https://jitpack.io/#dhirajabrandzzy/larapush-android-sdk
- Latest version: V12.0

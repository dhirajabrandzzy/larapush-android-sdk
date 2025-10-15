import 'dart:async';

import 'package:flutter/services.dart';

class LaraPush {
  static const MethodChannel _channel = MethodChannel('larapush');

  /// Initialize LaraPush with configuration
  /// 
  /// [panelUrl] - Your LaraPush panel URL (e.g., "https://v5-beta24.larapu.sh/")
  /// [applicationId] - Your app's package name (e.g., "com.myapp")
  /// [debug] - Enable debug logging (default: false)
  /// 
  /// Returns `true` if initialization was successful
  static Future<bool> initialize({
    required String panelUrl,
    required String applicationId,
    bool debug = false,
  }) async {
    try {
      final result = await _channel.invokeMethod('initialize', {
        'panelUrl': panelUrl,
        'applicationId': applicationId,
        'debug': debug,
      });
      return result == true;
    } on PlatformException catch (e) {
      throw LaraPushException(
        code: e.code,
        message: e.message ?? 'Unknown error',
        details: e.details,
      );
    }
  }

  /// Add tags to the user's subscription
  /// 
  /// [tags] - List of tags to add
  /// 
  /// Returns `true` if tags were set successfully
  static Future<bool> setTags(List<String> tags) async {
    try {
      final result = await _channel.invokeMethod('setTags', {
        'tags': tags,
      });
      return result == true;
    } on PlatformException catch (e) {
      throw LaraPushException(
        code: e.code,
        message: e.message ?? 'Unknown error',
        details: e.details,
      );
    }
  }

  /// Remove specific tags from the user's subscription
  /// 
  /// [tags] - List of tags to remove
  /// 
  /// Returns `true` if tags were removed successfully
  static Future<bool> removeTags(List<String> tags) async {
    try {
      final result = await _channel.invokeMethod('removeTags', {
        'tags': tags,
      });
      return result == true;
    } on PlatformException catch (e) {
      throw LaraPushException(
        code: e.code,
        message: e.message ?? 'Unknown error',
        details: e.details,
      );
    }
  }

  /// Remove all tags from the user's subscription
  /// 
  /// Returns `true` if tags were cleared successfully
  static Future<bool> clearTags() async {
    try {
      final result = await _channel.invokeMethod('clearTags');
      return result == true;
    } on PlatformException catch (e) {
      throw LaraPushException(
        code: e.code,
        message: e.message ?? 'Unknown error',
        details: e.details,
      );
    }
  }

  /// Get the current set of tags
  /// 
  /// Returns a list of current tags
  static Future<List<String>> getTags() async {
    try {
      final result = await _channel.invokeMethod('getTags');
      return List<String>.from(result ?? []);
    } on PlatformException catch (e) {
      throw LaraPushException(
        code: e.code,
        message: e.message ?? 'Unknown error',
        details: e.details,
      );
    }
  }

  /// Get the current Firebase messaging token
  /// 
  /// Returns the current FCM token
  static Future<String> getToken() async {
    try {
      final result = await _channel.invokeMethod('getToken');
      return result as String;
    } on PlatformException catch (e) {
      throw LaraPushException(
        code: e.code,
        message: e.message ?? 'Unknown error',
        details: e.details,
      );
    }
  }

  /// Force refresh the Firebase token and update subscription
  /// 
  /// Returns `true` if token was refreshed successfully
  static Future<bool> refreshToken() async {
    try {
      final result = await _channel.invokeMethod('refreshToken');
      return result == true;
    } on PlatformException catch (e) {
      throw LaraPushException(
        code: e.code,
        message: e.message ?? 'Unknown error',
        details: e.details,
      );
    }
  }

  /// Check if push notifications are enabled
  /// 
  /// Returns `true` if notifications are enabled
  static Future<bool> areNotificationsEnabled() async {
    try {
      final result = await _channel.invokeMethod('areNotificationsEnabled');
      return result == true;
    } on PlatformException catch (e) {
      throw LaraPushException(
        code: e.code,
        message: e.message ?? 'Unknown error',
        details: e.details,
      );
    }
  }
}

/// Exception class for LaraPush errors
class LaraPushException implements Exception {
  final String code;
  final String message;
  final dynamic details;

  const LaraPushException({
    required this.code,
    required this.message,
    this.details,
  });

  @override
  String toString() {
    return 'LaraPushException(code: $code, message: $message, details: $details)';
  }
}

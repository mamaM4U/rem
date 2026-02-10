import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DeviceDetector {
  static bool? _isEmulator;

  /// Initialize device detection - call this at app startup
  static Future<void> init() async {
    if (kIsWeb) {
      _isEmulator = false;
      return;
    }

    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      _isEmulator = !androidInfo.isPhysicalDevice;
    } else {
      _isEmulator = false;
    }
  }

  /// Check if the current Android device is an emulator
  /// Must call init() first at app startup
  static bool isAndroidEmulator() {
    if (kIsWeb || !Platform.isAndroid) {
      return false;
    }
    return _isEmulator ?? false;
  }

  /// Get platform name for debugging
  static String getPlatformName() {
    if (kIsWeb) {
      return 'Web';
    }

    if (Platform.isAndroid) {
      return isAndroidEmulator() ? 'Android Emulator' : 'Android Physical Device';
    } else if (Platform.isIOS) {
      return 'iOS';
    } else if (Platform.isWindows) {
      return 'Windows';
    } else if (Platform.isMacOS) {
      return 'macOS';
    } else if (Platform.isLinux) {
      return 'Linux';
    } else {
      return 'Unknown';
    }
  }
}

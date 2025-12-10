import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceDetector {
  static bool? _isEmulator;

  /// Initialize device detection - call this at app startup
  static Future<void> init() async {
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
    if (!Platform.isAndroid) {
      return false;
    }
    return _isEmulator ?? false;
  }

  /// Get platform name for debugging
  static String getPlatformName() {
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
      return 'Web';
    }
  }
}

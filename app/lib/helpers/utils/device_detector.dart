import 'dart:io';

class DeviceDetector {
  /// Check if the current Android device is an emulator
  /// Returns true if emulator, false if physical device
  static bool isAndroidEmulator() {
    if (!Platform.isAndroid) {
      return false;
    }

    // Check common emulator indicators
    final brand = Platform.environment['BRAND']?.toLowerCase() ?? '';
    final device = Platform.environment['DEVICE']?.toLowerCase() ?? '';
    final model = Platform.environment['MODEL']?.toLowerCase() ?? '';
    final product = Platform.environment['PRODUCT']?.toLowerCase() ?? '';
    final manufacturer = Platform.environment['MANUFACTURER']?.toLowerCase() ?? '';

    // Common emulator identifiers
    return brand.contains('generic') ||
        device.contains('generic') ||
        model.contains('emulator') ||
        model.contains('sdk') ||
        product.contains('sdk') ||
        product.contains('emulator') ||
        manufacturer.contains('genymotion') ||
        (manufacturer.contains('google') && !model.startsWith('pixel'));
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

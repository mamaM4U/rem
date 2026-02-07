import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final SecureStorage _instance = SecureStorage._internal();
  factory SecureStorage() => _instance;
  SecureStorage._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  /// Initialize storage (for compatibility with old code)
  Future<void> init() async {
    // No initialization needed for FlutterSecureStorage
  }

  /// Get first time flag
  Future<bool> getFirstTime() async {
    final value = await _storage.read(key: 'firstTime');
    return value == 'true';
  }

  /// Set first time flag
  Future<void> setFirstTime(bool value) async {
    await _storage.write(key: 'firstTime', value: value.toString());
  }

  /// Get user login data
  Future<String?> getUserLoginData({bool temp = false}) async {
    final key = temp ? 'mercenary_UT_BIOMETRIC_TEMP' : 'mercenary_UT';
    return await read(key);
  }

  /// Read value from secure storage
  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      return null;
    }
  }

  /// Write value to secure storage
  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      // Handle error silently or log it
    }
  }

  /// Remove value from secure storage
  Future<void> remove(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      // Handle error silently or log it
    }
  }

  /// Clear all data from secure storage
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      // Handle error silently or log it
    }
  }

  /// Check if key exists
  Future<bool> containsKey(String key) async {
    try {
      final value = await _storage.read(key: key);
      return value != null;
    } catch (e) {
      return false;
    }
  }

  /// Get all keys
  Future<Map<String, String>> readAll() async {
    try {
      return await _storage.readAll();
    } catch (e) {
      return {};
    }
  }
}

// Global instance for easy access
final secureStorage = SecureStorage();

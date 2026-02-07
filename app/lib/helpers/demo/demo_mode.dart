import '../env/env.dart';

/// Helper class for checking demo mode status
class DemoMode {
  DemoMode._();

  /// Check if demo mode is enabled
  static bool get isEnabled => Env.DEMO_MODE.toLowerCase() == 'true';

  /// Demo user credentials
  static const String demoEmail = 'demo@example.com';
  static const String demoPassword = 'demo123';

  /// Check if credentials match demo user
  static bool isValidDemoCredentials(String email, String password) {
    return email == demoEmail && password == demoPassword;
  }
}

import 'package:shared/shared.dart';

/// Mock data for demo mode
class DemoData {
  DemoData._();

  // ============ USER DATA ============

  static User get demoUser => User(id: 'demo-user-001', email: 'demo@example.com', name: 'Demo User', avatar: null);

  static const String demoToken = 'demo.eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkZW1vLXVzZXItMDAxIn0.demo';

  static AuthResponse get demoAuthResponse => AuthResponse(token: demoToken, user: demoUser);

  // ============ HOME DATA ============

  static HomeData get demoHomeData =>
      HomeData(title: 'Welcome to Demo Mode', description: 'This is sample data for demonstration purposes.', items: demoHomeItems);

  static List<HomeItem> get demoHomeItems => [
    HomeItem(id: 'item-001', title: 'Getting Started', subtitle: 'Learn how to use this app', imageUrl: null),
    HomeItem(id: 'item-002', title: 'Explore Features', subtitle: 'Discover what you can do', imageUrl: null),
    HomeItem(id: 'item-003', title: 'Settings & Profile', subtitle: 'Customize your experience', imageUrl: null),
    HomeItem(id: 'item-004', title: 'Documentation', subtitle: 'Read the full documentation', imageUrl: null),
  ];

  // ============ TODO DATA ============

  static List<Map<String, dynamic>> get demoTodos => [
    {'id': 1, 'todo': 'Setup project environment', 'completed': true, 'userId': 1},
    {'id': 2, 'todo': 'Configure API server', 'completed': true, 'userId': 1},
    {'id': 3, 'todo': 'Implement authentication', 'completed': false, 'userId': 1},
    {'id': 4, 'todo': 'Create home page UI', 'completed': false, 'userId': 1},
    {'id': 5, 'todo': 'Add unit tests', 'completed': false, 'userId': 1},
  ];

  /// Simulate network delay for realistic demo experience
  static Future<void> simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

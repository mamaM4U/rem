/// In-memory user storage for demo purposes
/// In production, use a real database (PostgreSQL)
class UserStorage {
  /// Factory constructor returning singleton instance
  factory UserStorage() => _instance;

  UserStorage._internal();

  static final UserStorage _instance = UserStorage._internal();

  /// In-memory users map: email -> user data
  final Map<String, Map<String, dynamic>> users = {};
}

/// Global user storage instance
final userStorage = UserStorage();

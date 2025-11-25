import 'package:bcrypt/bcrypt.dart';
import 'package:plana/database/database.dart';
import 'package:postgres/postgres.dart';
import 'package:shared/shared.dart';
import 'package:uuid/uuid.dart';

/// User repository for database operations
class UserRepository {
  UserRepository._();

  static final UserRepository _instance = UserRepository._();

  /// Get repository instance
  static UserRepository get instance => _instance;

  /// Find user by email
  Future<Map<String, dynamic>?> findByEmail(String email) async {
    final conn = await db.connection;
    final result = await conn.execute(
      Sql.named(
        'SELECT id, email, name, password_hash, avatar, created_at, updated_at '
        'FROM users WHERE email = @email',
      ),
      parameters: {'email': email},
    );

    if (result.isEmpty) return null;

    final row = result.first;
    return {
      'id': row[0]! as String,
      'email': row[1]! as String,
      'name': row[2]! as String,
      'password_hash': row[3]! as String,
      'avatar': row[4] as String?,
      'created_at': row[5]! as DateTime,
      'updated_at': row[6]! as DateTime,
    };
  }

  /// Find user by ID
  Future<Map<String, dynamic>?> findById(String id) async {
    final conn = await db.connection;
    final result = await conn.execute(
      Sql.named(
        'SELECT id, email, name, password_hash, avatar, created_at, updated_at '
        'FROM users WHERE id = @id::uuid',
      ),
      parameters: {'id': id},
    );

    if (result.isEmpty) return null;

    final row = result.first;
    return {
      'id': row[0]! as String,
      'email': row[1]! as String,
      'name': row[2]! as String,
      'password_hash': row[3]! as String,
      'avatar': row[4] as String?,
      'created_at': row[5]! as DateTime,
      'updated_at': row[6]! as DateTime,
    };
  }

  /// Create new user
  Future<User> create({
    required String email,
    required String name,
    required String password,
  }) async {
    final conn = await db.connection;

    // Generate UUID and hash password
    final userId = const Uuid().v4();
    final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
    final avatarUrl =
        'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}';

    final result = await conn.execute(
      Sql.named(
        'INSERT INTO users (id, email, name, password_hash, avatar) '
        'VALUES (@id::uuid, @email, @name, @password_hash, @avatar) '
        'RETURNING id, email, name, avatar',
      ),
      parameters: {
        'id': userId,
        'email': email,
        'name': name,
        'password_hash': hashedPassword,
        'avatar': avatarUrl,
      },
    );

    final row = result.first;
    return User(
      id: row[0]! as String,
      email: row[1]! as String,
      name: row[2]! as String,
      avatar: row[3] as String?,
    );
  }

  /// Verify password
  bool verifyPassword(String password, String hashedPassword) {
    return BCrypt.checkpw(password, hashedPassword);
  }

  /// Convert database row to User model
  User toUser(Map<String, dynamic> data) {
    return User(
      id: data['id']! as String,
      email: data['email']! as String,
      name: data['name']! as String,
      avatar: data['avatar'] as String?,
    );
  }
}

/// Global user repository instance
final userRepository = UserRepository.instance;

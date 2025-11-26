import 'dart:io';

import 'package:postgres/postgres.dart';
import 'package:plana/env/env.dart';

/// PostgreSQL database connection
class Database {
  /// Get database instance
  factory Database() {
    _instance ??= Database._();
    return _instance!;
  }

  Database._();
  static Database? _instance;
  static Connection? _connection;

  /// Get database connection
  Future<Connection> get connection async {
    if (_connection != null) {
      return _connection!;
    }

    // Load from environment variables (with Docker fallback)
    final endpoint = Endpoint(
      host: Platform.environment['DATABASE_HOST'] ?? Env.DATABASE_HOST,
      port: int.parse(
        Platform.environment['DATABASE_PORT'] ?? Env.DATABASE_PORT.toString(),
      ),
      database: Platform.environment['DATABASE_NAME'] ?? Env.DATABASE_NAME,
      username: Platform.environment['DATABASE_USER'] ?? Env.DATABASE_USER,
      password:
          Platform.environment['DATABASE_PASSWORD'] ?? Env.DATABASE_PASSWORD,
    );

    _connection = await Connection.open(
      endpoint,
      settings: const ConnectionSettings(
        sslMode: SslMode.disable,
      ),
    );

    return _connection!;
  }

  /// Close database connection
  Future<void> close() async {
    await _connection?.close();
    _connection = null;
  }
}

/// Global database instance
final db = Database();

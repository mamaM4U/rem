import 'dart:io';

import 'package:postgres/postgres.dart';

/// PostgreSQL database connection
class Database {
  Database._();

  static Database? _instance;
  static Connection? _connection;

  /// Get database instance
  static Database get instance {
    _instance ??= Database._();
    return _instance!;
  }

  /// Get database connection
  Future<Connection> get connection async {
    if (_connection != null) {
      return _connection!;
    }

    // Load from environment variables
    final endpoint = Endpoint(
      host: Platform.environment['DATABASE_HOST'] ?? 'localhost',
      port: int.parse(Platform.environment['DATABASE_PORT'] ?? '5432'),
      database: Platform.environment['DATABASE_NAME'] ?? 'rem_db',
      username: Platform.environment['DATABASE_USER'] ?? 'postgres',
      password: Platform.environment['DATABASE_PASSWORD'] ?? 'postgres',
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
final db = Database.instance;

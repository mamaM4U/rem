# Plana API Server

Dart Frog REST API for Rem application.

> **Note**: For complete development guide and workspace setup, see the [main README](../README.md) at the root of the repository.

## Quick Start

### Using Melos (Recommended)

From the workspace root:

```bash
# Start database
melos plana:docker:up

# Run API server
melos plana

# View logs
melos plana:docker:logs

# Stop database
melos plana:docker:down
```

### Using Docker Compose Directly

```bash
# Start services (PostgreSQL + API Server)
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

Services will be available at:
- API Server: http://localhost:8080
- PostgreSQL: localhost:5432

## Database Setup

The database schema is defined in `database.sql` and will be automatically applied when the PostgreSQL container starts for the first time.

**Note**: The database is initialized with **empty tables only**. No seed data is included. You need to create users via the `/auth/register` endpoint.

### Database Tables

- **users** - User accounts (created via registration)
  - Auto-creates UUID, timestamps, password hash
  - No initial data

## Environment Configuration

### Using Envied (Obfuscated)

Environment variables are managed using `envied` for security:

1. Copy `.envied.example` to `.envied`:
```bash
cp .envied.example .envied
```

2. Update values in `.envied`:
```
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_NAME=rem_db
DATABASE_USER=postgres
DATABASE_PASSWORD=postgres
JWT_SECRET=your-secret-key-here
```

3. Run build_runner to generate obfuscated env.g.dart:
```bash
# From workspace root (recommended)
melos build:runner

# Or directly in api_server
dart run build_runner build --delete-conflicting-outputs
```

**Docker Mode**: When running in Docker, the app will prioritize `Platform.environment` variables from docker-compose.yml over envied values.

## API Endpoints

### Public Endpoints

#### Get Home Data
```bash
GET /home

# Example
curl http://localhost:8080/home
```

#### Register User
```bash
POST /auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123",
  "name": "John Doe"
}

# Example
curl -X POST http://localhost:8080/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password123","name":"John Doe"}'
```

**Response**:
```json
{
  "success": true,
  "message": "Registration successful",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": "123e4567-e89b-12d3-a456-426614174000",
      "email": "user@example.com",
      "name": "John Doe"
    }
  }
}
```

#### Login
```bash
POST /auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}

# Example
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password123"}'
```

### Protected Endpoints

#### Get User Profile
```bash
GET /user
Authorization: Bearer <token>

# Example
curl http://localhost:8080/user \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

## Manual Setup (Without Docker)

### 1. Install PostgreSQL

**macOS:**
```bash
brew install postgresql@15
brew services start postgresql@15
```

**Ubuntu/Debian:**
```bash
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
```

### 2. Create Database

```bash
# Login to PostgreSQL
psql postgres

# Create database
CREATE DATABASE rem_db;

# Exit
\q
```

### 3. Apply Schema

```bash
# Apply schema
psql -U postgres -d rem_db -f database.sql
```

### 4. Run Server

```bash
# Using Melos
melos plana

# Or directly
dart_frog dev
```

## Development

### Code Generation

When you update `.envied` (environment variables):

```bash
# From workspace root (recommended)
melos build:runner

# Or directly in api_server
dart run build_runner build --delete-conflicting-outputs
```

> **Note**: You only need to run build_runner when you change `.envied`. The `lib/env/env.dart` file rarely needs changes unless you're adding new environment variable fields.

### Hot Reload

Dart Frog supports hot reload:
```bash
dart_frog dev
```

### Build for Production

```bash
# Build
dart_frog build

# Run production build
dart build/bin/server.dart
```

## Testing

```bash
# Run all tests
dart test

# Run specific test
dart test test/routes/auth/login_test.dart
```

## Database Schema

### Users Table
- `id` - UUID (primary key, auto-generated)
- `email` - VARCHAR(255) (unique, not null)
- `name` - VARCHAR(255) (not null)
- `password_hash` - TEXT (not null)
- `avatar` - TEXT (nullable)
- `created_at` - TIMESTAMP (default: now())
- `updated_at` - TIMESTAMP (default: now())

### Indexes
- `idx_users_email` on `email` for fast lookups

## Tech Stack

- **Framework**: Dart Frog 1.2.6
- **Database**: PostgreSQL 15
- **Authentication**: JWT (dart_jsonwebtoken) + bcrypt
- **Environment**: envied (obfuscated environment variables)
- **Validation**: validators2
- **HTTP Client**: Dio (for external APIs)
- **Utilities**: uuid, decimal, intl, logging

## Troubleshooting

### Database Connection Issues

1. Check if PostgreSQL is running:
```bash
docker ps | grep plana-db
```

2. Check database logs:
```bash
melos plana:docker:logs
```

3. Verify environment variables in `.envied`

### JWT Token Issues

- Make sure `JWT_SECRET` is the same in both development and production
- Token expires after 24h by default
- Use `/auth/register` or `/auth/login` to get a new token

## More Information

For complete workspace documentation, monorepo structure, and full list of available commands, see the [main README](../README.md).

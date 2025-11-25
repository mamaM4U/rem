# Plana API Server

Dart Frog REST API for Rem application.

## Quick Start with Docker (Recommended)

The easiest way to run the API server with PostgreSQL:

```bash
# Start services (PostgreSQL + API Server)
docker-compose up -d

# Or using make
make up
```

Services will be available at:
- API Server: http://localhost:8080
- PostgreSQL: localhost:5432

### Docker Commands

```bash
# Start services
make up

# View logs
make logs

# View API logs only
make logs-api

# Stop services
make down

# Restart services
make restart

# Run tests
make test

# Open PostgreSQL shell
make shell-db

# Clean everything (remove volumes)
make clean
```

The database will be automatically initialized with the schema from `database.sql`.

## Manual Setup (Without Docker)

### PostgreSQL Installation

**macOS:**
```bash
brew install postgresql@14
brew services start postgresql@14
```

**Ubuntu/Debian:**
```bash
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
```

**Windows:**
Download from [postgresql.org](https://www.postgresql.org/download/windows/)

### Create Database

```bash
# Login to PostgreSQL
psql postgres

# Create database
CREATE DATABASE rem_db;

# Create user (if needed)
CREATE USER postgres WITH PASSWORD 'postgres';
GRANT ALL PRIVILEGES ON DATABASE rem_db TO postgres;

# Exit
\q
```

### Run Migrations

```bash
# Apply schema
psql -U postgres -d rem_db -f database.sql

# Or use connection string
psql postgresql://postgres:postgres@localhost:5432/rem_db -f database.sql
```

### Verify Setup

```bash
# Connect to database
psql -U postgres -d rem_db

# List tables
\dt

# Check users table
SELECT * FROM users;

# Exit
\q
```

## Environment Setup

1. Copy `.env.example` to `.env`:
```bash
cp .env.example .env
```

2. Update `.env` with your configuration

## Running the Server

```bash
# From monorepo root
melos run run:server

# Or directly
cd api_server
dart_frog dev
```

Server will run at `http://localhost:8080`

## API Endpoints

### Public Endpoints

#### Get Home Data
```bash
GET /home

# Example
curl http://localhost:8080/home
```

#### Register
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

## Testing

```bash
# Run all tests
cd api_server
dart test

# Run specific test
dart test test/routes/auth/login_test.dart
```

## Development

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

## Database Schema

### Users Table
- `id` - UUID (primary key)
- `email` - VARCHAR(255) (unique)
- `name` - VARCHAR(255)
- `password_hash` - TEXT
- `avatar` - TEXT (nullable)
- `created_at` - TIMESTAMP
- `updated_at` - TIMESTAMP

### Sessions Table (optional)
- `id` - UUID (primary key)
- `user_id` - UUID (foreign key)
- `refresh_token` - TEXT
- `expires_at` - TIMESTAMP
- `created_at` - TIMESTAMP

## Tech Stack

- **Framework**: Dart Frog 1.2.6
- **Database**: PostgreSQL 14+
- **Authentication**: JWT + bcrypt
- **Validation**: validators2
- **HTTP Client**: Dio (for external APIs)

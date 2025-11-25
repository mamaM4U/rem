# Rem Workspace

Monorepo for Flutter app and Dart Frog API server using Melos 7.3.0.

## Project Structure

```
rem/
├── app/              # Flutter application (arona)
├── api_server/       # Dart Frog API server (plana)
├── packages/
│   └── shared/       # Shared code between app and server
└── pubspec.yaml      # Workspace configuration
```

## Requirements

- Dart SDK: ^3.5.0
- Flutter SDK
- Melos: ^7.3.0
- PostgreSQL (for database)

## Setup

1. Install Melos globally:
```bash
dart pub global activate melos
```

2. Bootstrap workspace:
```bash
melos bootstrap
```

3. Setup environment variables:
```bash
# In app/
cp .envied.example .envied
# Edit .envied with your configuration

# In api_server/
cp .env.example .env
# Edit .env with your configuration
```

## Development

### Run App
```bash
melos run run:app
```

### Run API Server
```bash
melos run run:server
```

### Code Generation
```bash
# Run build_runner in all packages
melos run build:runner
```

## Melos Commands

### Development
- `melos run run:app` - Run Flutter app
- `melos run run:server` - Run Dart Frog server
- `melos run get` - Get dependencies for all packages

### Code Quality
- `melos run analyze` - Analyze all packages
- `melos run format` - Format all files
- `melos run test` - Run tests

### Build
- `melos run build:runner` - Run build_runner for code generation
- `melos run clean` - Clean all packages

## Tech Stack

### App (arona)

**State Management & Navigation:**
- GetX - Lightweight state management & routing

**Network & API:**
- Dio - HTTP client with interceptors

**Storage & Security:**
- flutter_secure_storage - Encrypted storage (Keychain/EncryptedSharedPreferences)
- local_auth - Biometric authentication

**UI Components:**
- Skeletonizer & Shimmer - Loading states
- Cached Network Image - Image caching
- EasyLoading - Loading indicators
- Flutter SVG - SVG support

**Utilities:**
- intl & jiffy - Date/time formatting & localization
- envied - Type-safe environment variables
- json_annotation & json_serializable - JSON serialization

### API Server (plana)

**Framework:**
- Dart Frog - Fast & minimalist API framework

**Authentication & Security:**
- bcrypt - Password hashing
- dart_jsonwebtoken - JWT authentication
- uuid - Unique ID generation

**Database:**
- postgres - PostgreSQL client

**Validation & Utilities:**
- validators2 - Email, URL, phone validation
- decimal - Precise decimal arithmetic (for money/currency)
- intl - Internationalization & formatting
- logging - Structured logging

**HTTP & Integration:**
- dio - HTTP client for external API calls

**Config & Environment:**
- envied - Type-safe environment variables

**Serialization:**
- json_annotation & json_serializable - JSON serialization

### Shared Package

Contains shared code between app and server:
- Constants
- Models/DTOs
- Utilities

## Best Practices

### Secure Storage
```dart
import 'package:arona/helpers/secure_storage.dart';

// Write
await secureStorage.write('auth_token', token);

// Read
final token = await secureStorage.read('auth_token');

// Clear all
await secureStorage.clearAll();
```

### Environment Variables
```dart
// Use envied for type-safe env vars
@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'API_URL', obfuscate: true)
  static String apiUrl = _Env.apiUrl;
}
```

### Money Handling
```dart
import 'package:decimal/decimal.dart';

// Always use Decimal for money
Decimal price = Decimal.parse('99.99');
Decimal total = price * Decimal.fromInt(quantity);
```

### Validation
```dart
import 'package:validators2/validators2.dart';

if (!isEmail(email)) {
  throw Exception('Invalid email');
}
```

## Git Workflow

```bash
# Create feature branch
git checkout -b feature/feature-name

# Commit changes
git add .
git commit -m "feat: feature description"

# Push & create PR
git push origin feature/feature-name
```

## License

Private project

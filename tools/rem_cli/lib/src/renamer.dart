import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:dcli/dcli.dart';

import 'config.dart';

class ProjectRenamer {
  final String rootPath;
  final ProjectConfig config;
  late final bool useFvm;

  ProjectRenamer({required this.rootPath, required this.config});

  /// Check if FVM is available and .fvmrc exists
  Future<void> _checkFvm() async {
    final fvmrcExists = File(p.join(rootPath, '.fvmrc')).existsSync();
    if (fvmrcExists) {
      final result = await Process.run('which', ['fvm'], runInShell: true);
      useFvm = result.exitCode == 0;
      if (useFvm) {
        print('🎯 FVM detected, using fvm dart/flutter commands');
      }
    } else {
      useFvm = false;
    }
  }

  /// Get dart command and args prefix for FVM
  String get _dartExe => useFvm ? 'fvm' : (Platform.isWindows ? 'dart.bat' : 'dart');
  List<String> get _dartPrefix => useFvm ? ['dart'] : [];

  /// Get flutter command and args prefix for FVM
  String get _flutterExe => useFvm ? 'fvm' : (Platform.isWindows ? 'flutter.bat' : 'flutter');
  List<String> get _flutterPrefix => useFvm ? ['flutter'] : [];

  /// Get melos command (melos doesn't need fvm prefix, it uses project's SDK)
  String get _melosCmd => Platform.isWindows ? 'melos.bat' : 'melos';

  /// Helper for display strings
  String get _dartCmdDisplay => useFvm ? 'fvm dart' : 'dart';

  /// Get the app folder name (uses workspaceName)
  String get _appFolderName => config.workspaceName;

  /// Get the full app path
  String get _appPath => p.join(rootPath, 'apps', _appFolderName);

  Future<void> run() async {
    await _checkFvm();

    print('');
    print('${cyan('✨ Initializing project...')}');
    print('');

    await _updateRootPubspec();
    await _createAppFromExample();
    await _updateMelosScripts();

    if (config.includeArona && config.aronaConfig != null) {
      await _renameArona();
    }

    if (config.includePlana && config.planaConfig != null) {
      await _renamePlana();
    }

    if (config.includeArisu && config.arisuConfig != null) {
      await _renameArisu();
    }

    await _updateRootDockerCompose();
    await _createDockerNetwork();
    await _removeUnselectedComponents();
    await _setupFlavorizr();

    if (config.includeArona && config.aronaConfig != null) {
      await _generateVsCodeConfigs();
      await _generateAndroidStudioRunConfigs();
      await _copyEnviedFiles('apps/example_app');
      await _copyEnviedFiles('apps/$_appFolderName');
    }

    if (config.includePlana) {
      await _copyEnviedFile('api_server');
    }

    // Run bootstrap and setup commands
    await _runBootstrapAndSetup();

    // Generate per-app env.g.dart files and set default
    if (config.includeArona && config.aronaConfig != null) {
      await _generateEnvPerApp();
    }

    print('');
    print('${green('✅ Project initialized successfully!')}');
    print('');
    print('Next steps:');
    var step = 1;
    if (config.includeArona) {
      print('  $step. Edit ${cyan('apps/$_appFolderName/.envied.*')} with your API URLs');
      step++;
    }
    if (config.includePlana) {
      print('  $step. Edit ${cyan('api_server/.envied')} with your database config');
      step++;
    }
    print('  $step. Regenerate env after editing .envied files:');
    print('     ${cyan('melos run build:env:$_appFolderName')}');
    step++;
    print('');
  }

  Future<void> _updateRootPubspec() async {
    print('📁 Updating root pubspec.yaml...');

    final pubspecPath = p.join(rootPath, 'pubspec.yaml');
    var content = File(pubspecPath).readAsStringSync();

    content = content.replaceAll('name: rem_workspace', 'name: ${config.workspaceName}_workspace');
    content = content.replaceAll('name: rem', 'name: ${config.workspaceName}');

    final workspaceLines = <String>[];
    workspaceLines.add('workspace:');
    if (config.includeArona) {
      workspaceLines.add('  - apps/example_app');
      workspaceLines.add('  - apps/$_appFolderName');
    }
    if (config.includePlana) workspaceLines.add('  - api_server');
    if (config.includeArisu) workspaceLines.add('  - landing_page_ssr');
    workspaceLines.add('  - packages/shared');

    content = content.replaceAllMapped(RegExp(r'workspace:\n(  - [^\n]+\n)+'), (match) => '${workspaceLines.join('\n')}\n');

    File(pubspecPath).writeAsStringSync(content);
  }

  Future<void> _createAppFromExample() async {
    if (!config.includeArona) return;

    final examplePath = p.join(rootPath, 'apps', 'example_app');
    final newPath = _appPath;

    if (Directory(newPath).existsSync()) {
      // Check if it's a complete app (has pubspec.yaml)
      if (File(p.join(newPath, 'pubspec.yaml')).existsSync()) {
        print('📁 App folder already exists: apps/$_appFolderName');
        return;
      }
      // Incomplete from previous failed run - clean up
      print('📁 Cleaning up incomplete app folder: apps/$_appFolderName');
      Directory(newPath).deleteSync(recursive: true);
    }

    if (!Directory(examplePath).existsSync()) {
      print('⚠️  example_app not found, skipping app creation');
      return;
    }

    print('📁 Creating app from example: apps/example_app → apps/$_appFolderName');
    await _copyDirectory(Directory(examplePath), Directory(newPath));
  }

  /// Recursively copy a directory
  Future<void> _copyDirectory(Directory source, Directory destination) async {
    destination.createSync(recursive: true);
    await for (final entity in source.list(recursive: false)) {
      final newPath = p.join(destination.path, p.basename(entity.path));
      if (entity is Directory) {
        // Skip .dart_tool and build directories
        final name = p.basename(entity.path);
        if (name == '.dart_tool' || name == 'build') continue;
        await _copyDirectory(entity, Directory(newPath));
      } else if (entity is File) {
        entity.copySync(newPath);
      }
    }
  }

  Future<void> _updateMelosScripts() async {
    print('📁 Updating melos scripts...');

    final pubspecPath = p.join(rootPath, 'pubspec.yaml');
    var content = File(pubspecPath).readAsStringSync();

    // Update scopes
    if (config.includeArona && config.aronaConfig != null) {
      content = content.replaceAll('scope: arona', 'scope: ${config.aronaConfig!.packageName}');
    }
    if (config.includePlana && config.planaConfig != null) {
      content = content.replaceAll('scope: plana', 'scope: ${config.planaConfig!.packageName}');
    }
    if (config.includeArisu && config.arisuConfig != null) {
      content = content.replaceAll('scope: arisu', 'scope: ${config.arisuConfig!.packageName}');
    }

    // Add build:env scripts for each app
    if (config.includeArona) {
      final buildEnvScripts = '''
    # Generate env for example_app
    build:env:example_app:
      run: |
        cp apps/example_app/.envied.* packages/shared/lib/src/app/
        cp -r apps/example_app/env/ packages/shared/lib/src/app/env/
        melos exec --scope="shared" -- dart run build_runner build --delete-conflicting-outputs
        cp packages/shared/lib/src/app/env/env_*.g.dart apps/example_app/env/
      description: Generate env files for example_app

    # Generate env for $_appFolderName
    build:env:$_appFolderName:
      run: |
        cp apps/$_appFolderName/.envied.* packages/shared/lib/src/app/
        cp -r apps/$_appFolderName/env/ packages/shared/lib/src/app/env/
        melos exec --scope="shared" -- dart run build_runner build --delete-conflicting-outputs
        cp packages/shared/lib/src/app/env/env_*.g.dart apps/$_appFolderName/env/
      description: Generate env files for $_appFolderName
''';
      // Insert before the last scripts key or append to scripts
      if (content.contains('scripts:')) {
        content = content.replaceFirst('scripts:', 'scripts:\n$buildEnvScripts');
      }
    }

    // Remove unused scripts
    if (!config.includeArona) {
      content = _removeMelosScript(content, 'arona');
    }
    if (!config.includePlana) {
      content = _removeMelosScript(content, 'plana');
    }
    if (!config.includeArisu) {
      content = _removeMelosScript(content, 'arisu');
    }

    File(pubspecPath).writeAsStringSync(content);
  }

  String _removeMelosScript(String content, String scriptPrefix) {
    final lines = content.split('\n');
    final result = <String>[];
    var skipUntilNextScript = false;
    var indentLevel = 0;

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final trimmed = line.trimLeft();
      final currentIndent = line.length - trimmed.length;

      if (trimmed.startsWith('$scriptPrefix:') || trimmed.startsWith('$scriptPrefix:')) {
        skipUntilNextScript = true;
        indentLevel = currentIndent;
        continue;
      }

      if (skipUntilNextScript) {
        if (trimmed.isNotEmpty && currentIndent <= indentLevel && !line.startsWith(' ' * (indentLevel + 1))) {
          skipUntilNextScript = false;
          result.add(line);
        }
        continue;
      }

      result.add(line);
    }

    return result.join('\n');
  }

  Future<void> _renameArona() async {
    print('📁 Renaming arona (Flutter app)...');

    final aronaConfig = config.aronaConfig!;

    final appPubspecPath = p.join(_appPath, 'pubspec.yaml');
    var content = File(appPubspecPath).readAsStringSync();
    content = content.replaceFirst('name: arona', 'name: ${aronaConfig.packageName}');
    File(appPubspecPath).writeAsStringSync(content);

    // Update imports in all Dart files
    await _replaceInDartFiles(_appPath, "import 'package:arona/", "import 'package:${aronaConfig.packageName}/");

    final buildGradlePath = p.join(_appPath, 'android', 'app', 'build.gradle');
    var gradleContent = File(buildGradlePath).readAsStringSync();
    gradleContent = gradleContent.replaceAll('com.arona.app', aronaConfig.bundleIdBase);
    File(buildGradlePath).writeAsStringSync(gradleContent);

    final manifestPath = p.join(_appPath, 'android', 'app', 'src', 'main', 'AndroidManifest.xml');
    var manifestContent = File(manifestPath).readAsStringSync();
    manifestContent = manifestContent.replaceAll('android:label="Arona"', 'android:label="${aronaConfig.displayName}"');
    File(manifestPath).writeAsStringSync(manifestContent);

    final pbxprojPath = p.join(_appPath, 'ios', 'Runner.xcodeproj', 'project.pbxproj');
    var pbxContent = File(pbxprojPath).readAsStringSync();
    pbxContent = pbxContent.replaceAll('com.arona.app', aronaConfig.bundleIdBase);
    File(pbxprojPath).writeAsStringSync(pbxContent);

    final infoPlistPath = p.join(_appPath, 'ios', 'Runner', 'Info.plist');
    var plistContent = File(infoPlistPath).readAsStringSync();
    plistContent = plistContent.replaceAll('<string>Arona</string>', '<string>${aronaConfig.displayName}</string>');
    plistContent = plistContent.replaceAll('<string>arona</string>', '<string>${aronaConfig.packageName}</string>');
    File(infoPlistPath).writeAsStringSync(plistContent);

    await _renameKotlinPackage(aronaConfig.bundleIdBase);
    await _updateWebFiles(aronaConfig);
  }

  Future<void> _updateWebFiles(AronaConfig aronaConfig) async {
    final webDir = Directory(p.join(_appPath, 'web'));
    if (!webDir.existsSync()) {
      print('📁 Web folder not found, skipping web updates...');
      return;
    }

    print('📁 Updating web files...');

    // Update index.html
    final indexPath = p.join(_appPath, 'web', 'index.html');
    if (File(indexPath).existsSync()) {
      var indexContent = File(indexPath).readAsStringSync();
      indexContent = indexContent.replaceAll('<title>arona</title>', '<title>${aronaConfig.displayName}</title>');
      indexContent = indexContent.replaceAll(
          'apple-mobile-web-app-title" content="arona"', 'apple-mobile-web-app-title" content="${aronaConfig.displayName}"');
      indexContent = indexContent.replaceAll('content="A new Flutter project."', 'content="${aronaConfig.displayName}"');
      File(indexPath).writeAsStringSync(indexContent);
    }

    // Update manifest.json
    final manifestPath = p.join(_appPath, 'web', 'manifest.json');
    if (File(manifestPath).existsSync()) {
      var manifestContent = File(manifestPath).readAsStringSync();
      manifestContent = manifestContent.replaceAll('"name": "arona"', '"name": "${aronaConfig.displayName}"');
      manifestContent = manifestContent.replaceAll('"short_name": "arona"', '"short_name": "${aronaConfig.displayName}"');
      manifestContent =
          manifestContent.replaceAll('"description": "A new Flutter project."', '"description": "${aronaConfig.displayName}"');
      File(manifestPath).writeAsStringSync(manifestContent);
    }
  }

  Future<void> _renameKotlinPackage(String newPackage) async {
    final oldKotlinPath = p.join(_appPath, 'android', 'app', 'src', 'main', 'kotlin', 'com', 'example', 'mercenary');
    final mainActivityPath = p.join(oldKotlinPath, 'MainActivity.kt');

    if (File(mainActivityPath).existsSync()) {
      var content = File(mainActivityPath).readAsStringSync();
      content = content.replaceFirst(RegExp(r'package [^\n]+'), 'package $newPackage');

      final packageParts = newPackage.split('.');
      final newKotlinPath = p.joinAll([_appPath, 'android', 'app', 'src', 'main', 'kotlin', ...packageParts]);

      Directory(newKotlinPath).createSync(recursive: true);
      File(p.join(newKotlinPath, 'MainActivity.kt')).writeAsStringSync(content);

      Directory(p.join(_appPath, 'android', 'app', 'src', 'main', 'kotlin', 'com', 'example')).deleteSync(recursive: true);
    }
  }

  Future<void> _renamePlana() async {
    print('📁 Renaming plana (API server)...');

    final planaConfig = config.planaConfig!;

    final apiPubspecPath = p.join(rootPath, 'api_server', 'pubspec.yaml');
    var content = File(apiPubspecPath).readAsStringSync();
    content = content.replaceFirst('name: plana', 'name: ${planaConfig.packageName}');
    File(apiPubspecPath).writeAsStringSync(content);

    // Update imports in all Dart files
    await _replaceInDartFiles(p.join(rootPath, 'api_server'), "import 'package:plana/", "import 'package:${planaConfig.packageName}/");

    final apiDockerComposePath = p.join(rootPath, 'api_server', 'docker-compose.yml');
    if (File(apiDockerComposePath).existsSync()) {
      var dockerContent = File(apiDockerComposePath).readAsStringSync();
      dockerContent = dockerContent.replaceAll('plana-db', '${planaConfig.packageName}-db');
      dockerContent = dockerContent.replaceAll('plana-network', '${planaConfig.packageName}-network');
      dockerContent = dockerContent.replaceAll('container_name: plana', 'container_name: ${planaConfig.packageName}');
      dockerContent = dockerContent.replaceAll('POSTGRES_DB=rem_db', 'POSTGRES_DB=${planaConfig.databaseName}');
      File(apiDockerComposePath).writeAsStringSync(dockerContent);
    }

    // Update .envied.example with new database name
    final enviedExamplePath = p.join(rootPath, 'api_server', '.envied.example');
    if (File(enviedExamplePath).existsSync()) {
      var envContent = File(enviedExamplePath).readAsStringSync();
      envContent = envContent.replaceAll('DATABASE_NAME=rem_db', 'DATABASE_NAME=${planaConfig.databaseName}');
      File(enviedExamplePath).writeAsStringSync(envContent);
    }
  }

  Future<void> _renameArisu() async {
    print('📁 Renaming arisu (Landing page)...');

    final arisuConfig = config.arisuConfig!;

    final landingPubspecPath = p.join(rootPath, 'landing_page_ssr', 'pubspec.yaml');
    var content = File(landingPubspecPath).readAsStringSync();
    content = content.replaceFirst('name: arisu', 'name: ${arisuConfig.packageName}');
    File(landingPubspecPath).writeAsStringSync(content);

    // Update imports in all Dart files
    await _replaceInDartFiles(
      p.join(rootPath, 'landing_page_ssr'),
      "import 'package:arisu/",
      "import 'package:${arisuConfig.packageName}/",
    );
  }

  Future<void> _replaceInDartFiles(String directory, String oldImport, String newImport) async {
    final dir = Directory(directory);
    if (!dir.existsSync()) {
      print('   ⚠️  Directory not found: $directory');
      return;
    }

    var count = 0;
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        var content = entity.readAsStringSync();
        if (content.contains(oldImport)) {
          content = content.replaceAll(oldImport, newImport);
          entity.writeAsStringSync(content);
          count++;
        }
      }
    }
    if (count > 0) {
      print('   Updated imports in $count file(s)');
    }
  }

  Future<void> _updateRootDockerCompose() async {
    print('📁 Updating root docker-compose.yml...');

    final dockerComposePath = p.join(rootPath, 'docker-compose.yml');
    if (!File(dockerComposePath).existsSync()) return;

    var content = File(dockerComposePath).readAsStringSync();

    final dbName = config.planaConfig?.databaseName ?? '${config.workspaceName}_db';

    // Add stack name at the top if not present
    if (!content.startsWith('name:')) {
      content = 'name: ${config.workspaceName}\n\n$content';
    }

    content = content.replaceAll('rem-db', '${config.workspaceName}-db');
    content = content.replaceAll('rem-network', '${config.workspaceName}-network');
    content = content.replaceAll('rem-plana', '${config.workspaceName}-api');
    content = content.replaceAll('rem-arisu', '${config.workspaceName}-web');
    content = content.replaceAll('POSTGRES_DB=rem_db', 'POSTGRES_DB=$dbName');
    content = content.replaceAll('DATABASE_NAME=rem_db', 'DATABASE_NAME=$dbName');

    if (!config.includePlana) {
      content = _removeDockerService(content, 'plana');
      content = _removeDockerService(content, 'db');
    }
    if (!config.includeArisu) {
      content = _removeDockerService(content, 'arisu');
    }

    File(dockerComposePath).writeAsStringSync(content);
  }

  Future<void> _createDockerNetwork() async {
    if (!config.includePlana) return;

    final networkName = '${config.workspaceName}-network';

    // Check if docker is available and running
    final dockerCheck = await Process.run('docker', ['info'], runInShell: true);
    if (dockerCheck.exitCode != 0) {
      print('${yellow('⚠️  Docker is not running or not installed. Skipping network creation.')}');
      print('   Start Docker and create network manually: docker network create $networkName');
      return;
    }

    // Check if network already exists (exact match)
    final checkResult = await Process.run(
        'docker',
        [
          'network',
          'ls',
          '--filter',
          'name=^${networkName}\$',
          '--format',
          '{{.Name}}',
        ],
        runInShell: true);

    final existingNetworks = (checkResult.stdout as String).trim();
    if (existingNetworks == networkName) {
      print('🐳 Docker network "$networkName" already exists');
      return;
    }

    // Create the network
    print('🐳 Creating Docker network "$networkName"...');
    final result = await Process.run('docker', ['network', 'create', networkName], runInShell: true);

    if (result.exitCode == 0) {
      print('${green('✓')} Docker network "$networkName" created');
    } else {
      final stderr = (result.stderr as String).trim();
      print('${yellow('⚠️  Failed to create Docker network:')}');
      if (stderr.isNotEmpty) print('   $stderr');
      print('   Create it manually: docker network create $networkName');
    }
  }

  String _removeDockerService(String content, String serviceName) {
    final lines = content.split('\n');
    final result = <String>[];
    var skipService = false;
    var baseIndent = 0;

    for (final line in lines) {
      final trimmed = line.trimLeft();
      final currentIndent = line.length - trimmed.length;

      if (trimmed == '$serviceName:') {
        skipService = true;
        baseIndent = currentIndent;
        continue;
      }

      if (skipService) {
        if (trimmed.isNotEmpty && currentIndent <= baseIndent) {
          skipService = false;
          result.add(line);
        }
        continue;
      }

      result.add(line);
    }

    return result.join('\n');
  }

  Future<void> _removeUnselectedComponents() async {
    if (!config.includeArona) {
      print('🗑️  Removing app template and shared app code...');
      // Remove the example_app (reference app)
      final appDir = Directory(p.join(rootPath, 'apps', 'example_app'));
      if (appDir.existsSync()) appDir.deleteSync(recursive: true);
      // Remove the shared app code
      final sharedAppDir = Directory(p.join(rootPath, 'packages', 'shared', 'lib', 'src', 'app'));
      if (sharedAppDir.existsSync()) sharedAppDir.deleteSync(recursive: true);
      // Remove the barrel export
      final appBarrel = File(p.join(rootPath, 'packages', 'shared', 'lib', 'app.dart'));
      if (appBarrel.existsSync()) appBarrel.deleteSync();
    }

    if (!config.includePlana) {
      print('🗑️  Removing api_server folder...');
      final apiDir = Directory(p.join(rootPath, 'api_server'));
      if (apiDir.existsSync()) apiDir.deleteSync(recursive: true);
    }

    if (!config.includeArisu) {
      print('🗑️  Removing landing_page_ssr folder...');
      final landingDir = Directory(p.join(rootPath, 'landing_page_ssr'));
      if (landingDir.existsSync()) landingDir.deleteSync(recursive: true);
    }
  }

  Future<void> _setupFlavorizr() async {
    if (!config.includeArona || config.aronaConfig == null) return;

    print('📁 Setting up flutter_flavorizr...');

    final aronaConfig = config.aronaConfig!;
    final flavorizrConfig = '''
flavorizr:
  instructions:
    - assets:download
    - assets:extract
    - android:androidManifest
    - android:flavorizrGradle
    - android:buildGradle
    - android:dummyAssets
    - android:icons
    - flutter:flavors
    - ios:podfile
    - ios:xcconfig
    - ios:buildTargets
    - ios:schema
    - ios:dummyAssets
    - ios:icons
    - ios:plist
    - ios:launchScreen
    - assets:clean
    - ide:config
  flavors:
    local:
      app:
        name: "${aronaConfig.displayName} Local"
      android:
        applicationId: "${aronaConfig.bundleIdBase}.local"
      ios:
        bundleId: "${aronaConfig.bundleIdBase}.local"
    dev:
      app:
        name: "${aronaConfig.displayName} Dev"
      android:
        applicationId: "${aronaConfig.bundleIdBase}.dev"
      ios:
        bundleId: "${aronaConfig.bundleIdBase}.dev"
    prod:
      app:
        name: "${aronaConfig.displayName}"
      android:
        applicationId: "${aronaConfig.bundleIdBase}"
      ios:
        bundleId: "${aronaConfig.bundleIdBase}"
''';

    final appPubspecPath = p.join(_appPath, 'pubspec.yaml');
    var content = File(appPubspecPath).readAsStringSync();

    if (!content.contains('flutter_flavorizr:')) {
      final devDepsMatch = RegExp(r'dev_dependencies:\n').firstMatch(content);
      if (devDepsMatch != null) {
        final insertPos = devDepsMatch.end;
        content = '${content.substring(0, insertPos)}  flutter_flavorizr: ^2.2.3\n${content.substring(insertPos)}';
      }
    }

    content = '$content\n$flavorizrConfig';

    File(appPubspecPath).writeAsStringSync(content);
  }

  Future<void> _runBootstrapAndSetup() async {
    print('');
    print('${cyan('🔧 Running bootstrap and setup...')}');
    print('');

    // Run melos bootstrap
    print('📦 Running melos bootstrap...');
    print('');
    var process = await Process.start(
      _melosCmd,
      ['bootstrap'],
      workingDirectory: rootPath,
      mode: ProcessStartMode.inheritStdio,
      runInShell: true,
    );
    var exitCode = await process.exitCode;
    if (exitCode != 0) {
      print('${yellow('⚠️  melos bootstrap failed. You may need to run it manually.')}');
    } else {
      print('${green('✓')} melos bootstrap completed');
    }

    // Run flutter_flavorizr if arona is included
    if (config.includeArona) {
      print('🍦 Running flutter_flavorizr...');
      print('   (This may ask for confirmation)');
      print('');
      final flavProcess = await Process.start(
        _dartExe,
        [..._dartPrefix, 'run', 'flutter_flavorizr'],
        workingDirectory: _appPath,
        mode: ProcessStartMode.inheritStdio,
        runInShell: true,
      );
      final flavExitCode = await flavProcess.exitCode;
      if (flavExitCode != 0) {
        print('${yellow('⚠️  flutter_flavorizr failed. You may need to run it manually:')}');
        print('   cd app && $_dartCmdDisplay run flutter_flavorizr');
      } else {
        print('${green('✓')} flutter_flavorizr completed');
      }
    }

    // Run melos build:runner
    print('');
    print('🔨 Running melos build:runner...');
    print('');
    process = await Process.start(
      _melosCmd,
      ['run', 'build:runner'],
      workingDirectory: rootPath,
      mode: ProcessStartMode.inheritStdio,
      runInShell: true,
    );
    exitCode = await process.exitCode;
    if (exitCode != 0) {
      print('${yellow('⚠️  build:runner had some issues. This is normal if .envied has placeholder values.')}');
    } else {
      print('${green('✓')} build:runner completed');
    }
    // Run clean build to fix potential shader/cache issues
    await _runCleanBuild();
  }

  Future<void> _runCleanBuild() async {
    if (!config.includeArona) return;

    print('');
    print('🧹 Running clean build (flutter clean & cache removal)...');
    print('');

    // flutter clean
    final cleanProcess = await Process.start(
      _flutterExe,
      [..._flutterPrefix, 'clean'],
      workingDirectory: _appPath,
      mode: ProcessStartMode.inheritStdio,
      runInShell: true,
    );
    await cleanProcess.exitCode;

    // Remove gradle cache manually if on macOS/Linux
    if (!Platform.isWindows) {
      final buildDir = Directory(p.join(_appPath, 'build'));
      final gradleDir = Directory(p.join(_appPath, 'android', '.gradle'));

      if (buildDir.existsSync()) {
        buildDir.deleteSync(recursive: true);
      }
      if (gradleDir.existsSync()) {
        gradleDir.deleteSync(recursive: true);
      }
    }

    print('${green('✓')} Clean build completed');
  }

  Future<void> _copyEnviedFile(String folder) async {
    final examplePath = p.join(rootPath, folder, '.envied.example');
    final targetPath = p.join(rootPath, folder, '.envied');

    if (File(examplePath).existsSync() && !File(targetPath).existsSync()) {
      print('📁 Copying $folder/.envied.example to $folder/.envied...');
      final content = File(examplePath).readAsStringSync();
      File(targetPath).writeAsStringSync(content);
    }
  }

  /// Copy .envied.*.example → .envied.* for each flavor (local, dev, prod)
  Future<void> _copyEnviedFiles(String folder) async {
    final flavors = ['local', 'dev', 'prod'];

    for (final flavor in flavors) {
      final examplePath = p.join(rootPath, folder, '.envied.$flavor.example');
      final targetPath = p.join(rootPath, folder, '.envied.$flavor');

      if (File(examplePath).existsSync() && !File(targetPath).existsSync()) {
        print('📁 Copying $folder/.envied.$flavor.example → .envied.$flavor');
        var content = File(examplePath).readAsStringSync();

        // Auto-detect LAN IP for local flavor
        if (flavor == 'local' && folder.startsWith('apps/')) {
          final lanIp = await _getLanIpAddress();
          if (lanIp != null) {
            print('📡 Detected LAN IP: $lanIp');
            content = content.replaceAll(
              'API_BASE_URL_PHYSICAL=http://192.168.1.100:8080',
              'API_BASE_URL_PHYSICAL=http://$lanIp:8080',
            );
          }

          // Enable demo mode if API server is not included
          if (!config.includePlana) {
            print('🎭 Enabling demo mode (API server not included)');
            content = content.replaceAll('DEMO_MODE=false', 'DEMO_MODE=true');
          }
        }

        File(targetPath).writeAsStringSync(content);
      }
    }
  }

  Future<String?> _getLanIpAddress() async {
    try {
      final interfaces = await NetworkInterface.list(type: InternetAddressType.IPv4, includeLinkLocal: false);

      for (final interface in interfaces) {
        for (final addr in interface.addresses) {
          final ip = addr.address;
          // Look for common LAN IP ranges
          if (ip.startsWith('192.168.') || ip.startsWith('10.') || (ip.startsWith('172.') && _isPrivate172(ip))) {
            return ip;
          }
        }
      }
    } catch (e) {
      // Ignore errors, will use default IP
    }
    return null;
  }

  bool _isPrivate172(String ip) {
    final parts = ip.split('.');
    if (parts.length >= 2) {
      final second = int.tryParse(parts[1]) ?? 0;
      return second >= 16 && second <= 31;
    }
    return false;
  }

  /// Generate per-app env: for each app, copy env to shared, build, save .g.dart back
  Future<void> _generateEnvPerApp() async {
    final sharedAppDir = p.join(rootPath, 'packages', 'shared', 'lib', 'src', 'app');
    final sharedEnvDir = p.join(sharedAppDir, 'env');
    final flavors = ['local', 'dev', 'prod'];

    final apps = ['apps/$_appFolderName', 'apps/example_app'];

    for (final app in apps) {
      final appDir = p.join(rootPath, app);
      final appEnvDir = p.join(appDir, 'env');

      print('🔑 Generating env for $app...');

      // Copy .envied.* to packages/shared/lib/src/app/
      for (final flavor in flavors) {
        final enviedFile = File(p.join(appDir, '.envied.$flavor'));
        if (enviedFile.existsSync()) {
          enviedFile.copySync(p.join(sharedAppDir, '.envied.$flavor'));
        }
      }

      // Copy env/ folder to packages/shared/lib/src/app/env/
      final envDir = Directory(appEnvDir);
      if (envDir.existsSync()) {
        // Clean shared env dir first
        final sharedEnv = Directory(sharedEnvDir);
        if (sharedEnv.existsSync()) sharedEnv.deleteSync(recursive: true);
        await _copyDirectory(envDir, sharedEnv);
      }

      // Run build_runner
      final process = await Process.start(
        _melosCmd,
        ['run', 'build:runner'],
        workingDirectory: rootPath,
        mode: ProcessStartMode.inheritStdio,
        runInShell: true,
      );
      final exitCode = await process.exitCode;

      // Save generated .g.dart files back to app
      if (exitCode == 0) {
        for (final flavor in flavors) {
          final gFile = File(p.join(sharedEnvDir, 'env_$flavor.g.dart'));
          if (gFile.existsSync()) {
            gFile.copySync(p.join(appEnvDir, 'env_$flavor.g.dart'));
          }
        }
        print('✅ env generated for $app');
      } else {
        print('${yellow('⚠️  build_runner failed for $app, .g.dart files may be missing')}');
      }
    }

    // Set example_app as default in shared
    print('🔑 Setting default env to apps/example_app...');
    final exampleDir = p.join(rootPath, 'apps', 'example_app');
    for (final flavor in flavors) {
      final enviedFile = File(p.join(exampleDir, '.envied.$flavor'));
      if (enviedFile.existsSync()) {
        enviedFile.copySync(p.join(sharedAppDir, '.envied.$flavor'));
      }
    }
    final exampleEnvDir = Directory(p.join(exampleDir, 'env'));
    if (exampleEnvDir.existsSync()) {
      final sharedEnv = Directory(sharedEnvDir);
      if (sharedEnv.existsSync()) sharedEnv.deleteSync(recursive: true);
      await _copyDirectory(exampleEnvDir, sharedEnv);
    }
  }

  Future<void> _generateVsCodeConfigs() async {
    print('📁 Generating VS Code configs...');

    final aronaConfig = config.aronaConfig!;
    final vscodeDir = Directory(p.join(rootPath, '.vscode'));
    if (!vscodeDir.existsSync()) {
      vscodeDir.createSync(recursive: true);
    }

    // Generate tasks.json — copy .envied.* + env/ to shared
    final tasksJson = '''{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "env:example_app",
      "type": "shell",
      "command": "cp apps/example_app/.envied.* packages/shared/lib/src/app/ && cp -r apps/example_app/env/ packages/shared/lib/src/app/env/",
      "presentation": { "reveal": "silent" }
    },
    {
      "label": "env:$_appFolderName",
      "type": "shell",
      "command": "cp apps/$_appFolderName/.envied.* packages/shared/lib/src/app/ && cp -r apps/$_appFolderName/env/ packages/shared/lib/src/app/env/",
      "presentation": { "reveal": "silent" }
    }
  ]
}
''';
    File(p.join(vscodeDir.path, 'tasks.json')).writeAsStringSync(tasksJson);

    // Helper to generate 6 configs (Local/Dev/Prod × Debug/Release) for an app
    String appConfigs(String name, String program, String taskLabel) {
      final flavors = [
        {'flavor': 'local', 'label': 'Local'},
        {'flavor': 'dev', 'label': 'Dev'},
        {'flavor': 'prod', 'label': 'Prod'},
      ];
      final configs = <String>[];
      for (final f in flavors) {
        for (final release in [false, true]) {
          final suffix = release ? ' (Release)' : ' (Debug)';
          final args = ['"--flavor"', '"${f['flavor']}"', '"--dart-define=FLAVOR=${f['flavor']}"', '"--target"', '"lib/main.dart"'];
          if (release) args.add('"--release"');
          configs.add('''    {
      "name": "$name ${f['label']}$suffix",
      "request": "launch",
      "type": "dart",
      "program": "$program",
      "args": [${args.join(', ')}],
      "preLaunchTask": "$taskLabel"
    }''');
        }
      }
      return configs.join(',\n');
    }

    final launchJson = '''{
  "version": "0.2.0",
  "configurations": [
${appConfigs('Example App', 'apps/example_app/lib/main.dart', 'env:example_app')},
${appConfigs(aronaConfig.displayName, 'apps/$_appFolderName/lib/main.dart', 'env:$_appFolderName')}
  ]
}
''';
    File(p.join(vscodeDir.path, 'launch.json')).writeAsStringSync(launchJson);

    // Generate settings.json for FVM if FVM is detected
    if (useFvm) {
      print('📁 Generating VS Code settings.json for FVM...');
      final settingsJson = '''{
  "dart.flutterSdkPath": ".fvm/flutter_sdk"
}
''';
      File(p.join(vscodeDir.path, 'settings.json')).writeAsStringSync(settingsJson);
    }
  }

  Future<void> _generateAndroidStudioRunConfigs() async {
    print('📁 Generating Android Studio run configurations...');

    final aronaConfig = config.aronaConfig!;
    final runDir = Directory(p.join(rootPath, '.run'));
    if (!runDir.existsSync()) {
      runDir.createSync(recursive: true);
    }

    // Example app (no-flavor) configuration
    final exampleConfigXml = '''<component name="ProjectRunConfigurationManager">
  <configuration default="false" name="Example App (Debug)" type="FlutterRunConfigurationType" factoryName="Flutter">
    <option name="filePath" value="\$PROJECT_DIR\$/apps/example_app/lib/main.dart" />
    <method v="2" />
  </configuration>
</component>
''';
    File(p.join(runDir.path, 'example_app_debug.run.xml')).writeAsStringSync(exampleConfigXml);

    // Flavor-specific configurations only (no-flavor configs won't work with flavorizr)
    final flavors = ['local', 'dev', 'prod'];

    for (final flavor in flavors) {
      final flavorTitle = flavor[0].toUpperCase() + flavor.substring(1);
      final configXml = '''<component name="ProjectRunConfigurationManager">
  <configuration default="false" name="${aronaConfig.displayName} $flavorTitle (Debug)" type="FlutterRunConfigurationType" factoryName="Flutter">
    <option name="buildFlavor" value="$flavor" />
    <option name="filePath" value="\$PROJECT_DIR\$/apps/$_appFolderName/lib/main.dart" />
    <method v="2" />
  </configuration>
</component>
''';
      File(p.join(runDir.path, '${aronaConfig.packageName}_${flavor}_debug.run.xml')).writeAsStringSync(configXml);

      final releaseConfigXml = '''<component name="ProjectRunConfigurationManager">
  <configuration default="false" name="${aronaConfig.displayName} $flavorTitle (Release)" type="FlutterRunConfigurationType" factoryName="Flutter">
    <option name="buildFlavor" value="$flavor" />
    <option name="additionalArgs" value="--release" />
    <option name="filePath" value="\$PROJECT_DIR\$/apps/$_appFolderName/lib/main.dart" />
    <method v="2" />
  </configuration>
</component>
''';
      File(p.join(runDir.path, '${aronaConfig.packageName}_${flavor}_release.run.xml')).writeAsStringSync(releaseConfigXml);
    }
  }
}

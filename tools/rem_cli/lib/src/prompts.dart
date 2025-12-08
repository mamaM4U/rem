import 'dart:io';

import 'package:dcli/dcli.dart';

import 'config.dart';

Future<ProjectConfig> promptConfig() async {
  print('');
  print('🚀 ${green('Welcome to REM Project Initializer!')}');
  print('');

  final workspaceName = ask(
    'Project name (workspace, e.g. my_workspace):',
    defaultValue: 'rem',
  ).replaceAll('-', '_').toLowerCase();

  print('');
  print('Select components to include:');

  final includeArona = confirm(
    '  Include Mobile App (arona)?',
    defaultValue: true,
  );

  final includePlana = confirm(
    '  Include API Server (plana)?',
    defaultValue: true,
  );

  final includeArisu = confirm(
    '  Include Landing Page (arisu)?',
    defaultValue: false,
  );

  if (!includeArona && !includePlana && !includeArisu) {
    print(red('Error: You must select at least one component!'));
    exit(1);
  }

  AronaConfig? aronaConfig;
  PlanaConfig? planaConfig;
  ArisuConfig? arisuConfig;

  if (includeArona) {
    print('');
    print('${cyan('--- Mobile App (arona) ---')}');

    final bundleIdBase = ask(
      'Bundle ID (e.g. com.rem.arona):',
      defaultValue: 'com.$workspaceName.arona',
    );

    // Derive package name from bundle ID (last segment)
    final packageName = bundleIdBase.split('.').last.replaceAll('-', '_').toLowerCase();

    final displayName = ask(
      'App display name (e.g. Arona):',
      defaultValue: _toTitleCase(packageName),
    );

    print('');
    print('  Flavors that will be created:');
    print('    ${green('local')} → ${bundleIdBase}.local → "$displayName Local"');
    print('    ${green('dev')}   → ${bundleIdBase}.dev   → "$displayName Dev"');
    print('    ${green('prod')}  → $bundleIdBase        → "$displayName"');

    aronaConfig = AronaConfig(
      packageName: packageName,
      displayName: displayName,
      bundleIdBase: bundleIdBase,
    );
  }

  if (includePlana) {
    print('');
    print('${cyan('--- API Server (plana) ---')}');

    final packageName = ask(
      'Dart package name (pubspec.yaml name, e.g. ${workspaceName}_api):',
      defaultValue: 'plana',
    ).replaceAll('-', '_').toLowerCase();

    final databaseName = ask(
      'PostgreSQL database name:',
      defaultValue: '${workspaceName}_db',
    ).replaceAll('-', '_').toLowerCase();

    planaConfig = PlanaConfig(
      packageName: packageName,
      databaseName: databaseName,
    );
  }

  if (includeArisu) {
    print('');
    print('${cyan('--- Landing Page (arisu) ---')}');

    final packageName = ask(
      'Dart package name (pubspec.yaml name, e.g. my_web):',
      defaultValue: 'arisu',
    ).replaceAll('-', '_').toLowerCase();

    arisuConfig = ArisuConfig(packageName: packageName);
  }

  return ProjectConfig(
    workspaceName: workspaceName,
    includeArona: includeArona,
    includePlana: includePlana,
    includeArisu: includeArisu,
    aronaConfig: aronaConfig,
    planaConfig: planaConfig,
    arisuConfig: arisuConfig,
  );
}

String _toTitleCase(String text) {
  return text
      .split('_')
      .map((word) => word.isEmpty
          ? word
          : '${word[0].toUpperCase()}${word.substring(1)}')
      .join(' ');
}



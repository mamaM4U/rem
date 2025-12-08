import 'dart:io';

import 'package:path/path.dart' as p;

import 'prompts.dart';
import 'renamer.dart';

Future<void> runInit() async {
  final rootPath = _findRootPath();
  if (rootPath == null) {
    print('Error: Could not find project root (pubspec.yaml with melos config)');
    exit(1);
  }

  final config = await promptConfig();

  print('');
  print('Configuration summary:');
  print('  Workspace: ${config.workspaceName}');
  print('  Components:');
  if (config.includeArona) {
    print('    ✓ arona → ${config.aronaConfig?.packageName}');
  }
  if (config.includePlana) {
    print('    ✓ plana → ${config.planaConfig?.packageName}');
  }
  if (config.includeArisu) {
    print('    ✓ arisu → ${config.arisuConfig?.packageName}');
  }
  print('');

  final renamer = ProjectRenamer(rootPath: rootPath, config: config);
  await renamer.run();
}

String? _findRootPath() {
  var current = Directory.current;

  for (var i = 0; i < 10; i++) {
    final pubspecFile = File(p.join(current.path, 'pubspec.yaml'));
    if (pubspecFile.existsSync()) {
      final content = pubspecFile.readAsStringSync();
      if (content.contains('melos:')) {
        return current.path;
      }
    }

    final parent = current.parent;
    if (parent.path == current.path) break;
    current = parent;
  }

  return null;
}

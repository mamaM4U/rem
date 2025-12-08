import 'dart:io';

import 'package:rem_cli/rem_cli.dart';

void main(List<String> args) async {
  if (args.isEmpty) {
    printUsage();
    exit(1);
  }

  final command = args.first;

  switch (command) {
    case 'init':
      await runInit();
      break;
    case 'help':
    case '--help':
    case '-h':
      printUsage();
      break;
    default:
      print('Unknown command: $command');
      printUsage();
      exit(1);
  }
}

void printUsage() {
  print('''
REM CLI - Project Initializer

Usage: 
  cd tools/rem_cli && dart run bin/rem_cli.dart <command>
  
  Or from project root:
  dart run --directory=tools/rem_cli bin/rem_cli.dart <command>

Commands:
  init    Initialize and configure the project
  help    Show this help message

Example:
  cd tools/rem_cli && dart run bin/rem_cli.dart init
''');
}

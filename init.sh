#!/bin/bash

# REM Project Initializer
# Usage: ./init.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLI_DIR="$SCRIPT_DIR/tools/rem_cli"

# Auto-detect FVM
if [ -f "$SCRIPT_DIR/.fvmrc" ] && command -v fvm &> /dev/null; then
  DART_CMD="fvm dart"
  echo "🎯 FVM detected, using fvm dart"
else
  DART_CMD="dart"
fi

echo "Installing CLI dependencies..."
cd "$CLI_DIR"
$DART_CMD pub get

echo ""
$DART_CMD run bin/rem_cli.dart init

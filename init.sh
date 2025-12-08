#!/bin/bash

# REM Project Initializer
# Usage: ./init.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLI_DIR="$SCRIPT_DIR/tools/rem_cli"

echo "Installing CLI dependencies..."
cd "$CLI_DIR"
dart pub get

echo ""
dart run bin/rem_cli.dart init

@echo off
REM REM Project Initializer for Windows
REM Usage: init.bat

echo Installing CLI dependencies...
cd tools\rem_cli
call dart pub get

echo.
call dart run bin/rem_cli.dart init
cd ..\..

import 'package:flutter/material.dart';

abstract class BaseColors {
  // Core Branding
  Color get primary;
  Color get lightPrimary;
  Color get darkPrimary;
  Color get accent;

  // Typography
  Color get fontLight;
  Color get fontWhite;
  Color get fontSemiDark;
  Color get fontGrey;

  // Backgrounds
  Color get backgroundSemiDark;
  Color get backgroundPrimary;
  Color get backgroundDanger;

  // Feedback/Status
  Color get danger;
  Color get lightDanger;
  Color get disabled;
  Color get warning;
  Color get disabledInput;

  // UI Elements
  Color get shadowCard;
  Color get border;
  Color get gridTileGrey;
  Color get cardBackground;

  Color get chipLightBlue;
  Color get chipGreen;
  Color get chipLightGreen;
  Color get chipAmber;
}

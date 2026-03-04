import 'package:flutter/material.dart';
import 'base_colors.dart';

class DefaultColors implements BaseColors {
  @override
  Color get primary => const Color(0xFF295C8A); // Zolog Blue
  @override
  Color get lightPrimary => const Color(0xFFE5F7FE);
  @override
  Color get darkPrimary => const Color(0xFF0D1B34);
  @override
  Color get accent => const Color(0xFF2F4E9E); // Zolog Accent Blue

  @override
  Color get fontLight => const Color(0xFF8D8D8D);
  @override
  Color get fontWhite => const Color(0xFFFFFFFF);
  @override
  Color get fontSemiDark => const Color(0xFF545454);
  @override
  Color get fontGrey => const Color(0xFF333333);

  @override
  Color get backgroundSemiDark => const Color(0xFFF6F6F6);
  @override
  Color get backgroundPrimary => const Color(0xFFE6F7FE);
  @override
  Color get backgroundDanger => const Color(0xFFFDE5E5);

  @override
  Color get danger => const Color(0xFFFF0000);
  @override
  Color get lightDanger => const Color.fromARGB(255, 238, 218, 218);
  @override
  Color get disabled => const Color(0xFFBCBCBC);
  @override
  Color get warning => const Color(0xFFFFD600);
  @override
  Color get disabledInput => const Color.fromARGB(255, 233, 233, 233);

  @override
  Color get shadowCard => const Color(0xFF5A75A7);
  @override
  Color get border => const Color.fromARGB(255, 220, 220, 220);
  @override
  Color get gridTileGrey => const Color(0xFF666666);
  @override
  Color get cardBackground => const Color(0xFFFFF5F5);

  @override
  Color get chipLightBlue => const Color(0xFF536DFE);
  @override
  Color get chipGreen => const Color(0xFF00C853);
  @override
  Color get chipLightGreen => const Color(0xFFB2FF59);
  @override
  Color get chipAmber => const Color(0xFFFFAB40);
}

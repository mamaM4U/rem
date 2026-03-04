import 'base_colors.dart';
import 'default_colors.dart';

import 'base_assets.dart';
import 'default_assets.dart';

class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  static AppConfig get instance => _instance;

  AppConfig._internal();

  BaseColors _colors = DefaultColors();
  BaseAssets _assets = DefaultAssets();

  static BaseColors get colors => _instance._colors;
  static BaseAssets get assets => _instance._assets;

  void init({BaseColors? customColors, BaseAssets? customAssets}) {
    if (customColors != null) {
      _colors = customColors;
    }
    if (customAssets != null) {
      _assets = customAssets;
    }
  }
}

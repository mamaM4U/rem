import 'base_assets.dart';

class DefaultAssets implements BaseAssets {
  static const String _sharedPackage = 'packages/shared';

  @override
  String get logoTextWhite => '$_sharedPackage/assets/images/logo_text_white.png';
}

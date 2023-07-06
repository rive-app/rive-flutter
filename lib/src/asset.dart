import 'package:rive/src/rive_core/assets/file_asset.dart';

export 'package:rive/src/generated/artboard_base.dart';

/// TODO: do we prefer this, or do we want to wrap our FileAssets
/// into a custom asset class.
extension FileAssetExtension on FileAsset {
  Extension get extension => _getExtension(fileExtension);
  Type get type => _getType(fileExtension);
}

Extension _getExtension(String extension) {
  switch (extension) {
    case 'png':
      return Extension.png;
    case 'jpeg':
      return Extension.jpeg;
    case 'webp':
      return Extension.webp;
    case 'otf':
      return Extension.otf;
    case 'ttf':
      return Extension.ttf;
  }
  return Extension.unknown;
}

Type _getType(String extension) {
  switch (extension) {
    case 'png':
    case 'jpeg':
    case 'webp':
      return Type.image;
    case 'otf':
    case 'ttf':
      return Type.font;
  }
  return Type.unknown;
}

enum Extension {
  otf,
  ttf,
  jpeg,
  png,
  webp,
  unknown,
}

enum Type {
  font,
  image,
  unknown,
}

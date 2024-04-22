// ignore_for_file: deprecated_member_use_from_same_package

import 'package:rive/src/rive_core/assets/file_asset.dart';

export 'package:rive/src/generated/artboard_base.dart';

const _deprecationExtensionMessage =
    '''This Extension is no longer maintained. Similar behaviour can
be re-created with a custom extension.

Example: https://gist.github.com/HayesGordon/5d37d3fb26f54b2c231760c2c8685963

''';

const _deprecationEnumMessage =
    '''This Enum is no longer maintained. Similar behaviour can
be re-created with a custom Enum.

Example: https://gist.github.com/HayesGordon/5d37d3fb26f54b2c231760c2c8685963

''';

@Deprecated(_deprecationExtensionMessage)
extension FileAssetExtension on FileAsset {
  @Deprecated(_deprecationExtensionMessage)
  Extension get extension => _getExtension(fileExtension);
  @Deprecated(_deprecationExtensionMessage)
  Type get type => _getType(fileExtension);
}

Extension _getExtension(String ext) {
  switch (ext) {
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

Type _getType(String ext) {
  switch (ext) {
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

@Deprecated(_deprecationEnumMessage)
enum Extension {
  otf,
  ttf,
  jpeg,
  png,
  webp,
  unknown,
}

@Deprecated(_deprecationEnumMessage)
enum Type {
  font,
  image,
  unknown,
}

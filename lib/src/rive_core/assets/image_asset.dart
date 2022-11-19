import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:rive/src/generated/assets/image_asset_base.dart';
import 'package:rive/src/rive_core/shapes/image.dart';

export 'package:rive/src/generated/assets/image_asset_base.dart';

class ImageAsset extends ImageAssetBase {
  ui.Image? _image;
  ui.Image? get image => _image;

  ImageAsset();

  @visibleForTesting
  ImageAsset.fromTestImage(this._image);

  set image(ui.Image? image) {
    if (_image == image) {
      return;
    }
    _image = image;
  }

  @override
  Future<void> decode(Uint8List bytes) {
    final completer = Completer<void>();
    ui.decodeImageFromList(bytes, (value) {
      image = value;
      completer.complete();
    });
    return completer.future;
  }

  Image getDefaultObject() => Image()
    ..asset = this
    ..name = name;

  static final imageExtensions = ['png', 'webp', 'jpeg'];

  @override
  String get fileExtension => imageExtensions[format];

  int get format => 0;
}

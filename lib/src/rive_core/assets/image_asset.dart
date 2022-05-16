import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:rive/src/generated/assets/image_asset_base.dart';
import 'package:rive/src/rive_core/shapes/image.dart';

export 'package:rive/src/generated/assets/image_asset_base.dart';

class ImageAsset extends ImageAssetBase {
  ui.Image? _image;
  ui.Image? get image => _image;

  /// A list of Images that need to know when the underlying bytes have been
  ///   successfully decoded.
  List<Image>? _decodeListeners;

  ImageAsset();

  @visibleForTesting
  ImageAsset.fromTestImage(this._image);

  @visibleForTesting
  set image(ui.Image? image) {
    _image = image;
  }

  /// Registers [asset] to know when these image bytes have been decoded.
  void addDecodeListener(Image asset) {
    (_decodeListeners ??= []).add(asset);
  }

  @override
  Future<void> decode(Uint8List bytes) {
    final completer = Completer<void>();
    ui.decodeImageFromList(bytes, (value) {
      _image = value;
      completer.complete();

      // Tell listeners that the image is ready to be drawn: mark them dirty.
      _decodeListeners
        ?..forEach((e) => e.context.markNeedsAdvance())
        ..clear();
    });
    return completer.future;
  }

  Image getDefaultObject() => Image()
    ..asset = this
    ..name = name;

  /// The editor works with images as PNGs, even if their sources may have come
  /// from other formats.
  @override
  String get fileExtension => 'png';
}

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:rive/src/generated/assets/image_asset_base.dart';
export 'package:rive/src/generated/assets/image_asset_base.dart';

class ImageAsset extends ImageAssetBase {
  ui.Image? _image;
  ui.Image? get image => _image;

  @override
  Future<void> decode(Uint8List bytes) {
    var completer = Completer<void>();
    ui.decodeImageFromList(bytes, (value) {
      _image = value;
      completer.complete();
    });
    return completer.future;
  }
}

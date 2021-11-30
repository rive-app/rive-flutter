import 'dart:ui' as ui;

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/shapes/image_base.dart';
import 'package:rive/src/rive_core/assets/file_asset.dart';
import 'package:rive/src/rive_core/assets/image_asset.dart';
import 'package:rive/src/rive_core/math/aabb.dart';

export 'package:rive/src/generated/shapes/image_base.dart';

class Image extends ImageBase with FileAssetReferencer<ImageAsset> {
  @override
  AABB get localBounds {
    if (asset == null) {
      return AABB.empty();
    }
    final halfWidth = asset!.width / 2;
    final halfHeight = asset!.height / 2;
    return AABB.fromValues(-halfWidth, -halfHeight, halfWidth, halfHeight);
  }

  @override
  void assetIdChanged(int from, int to) {}

  @override
  void draw(ui.Canvas canvas) {
    var uiImage = asset?.image;
    if (uiImage == null) {
      return;
    }
    bool clipped = clip(canvas);

    final paint = ui.Paint()..color = ui.Color.fromRGBO(0, 0, 0, renderOpacity);

    final width = asset!.width;
    final height = asset!.height;

    canvas.save();
    canvas.transform(worldTransform.mat4);
    canvas.drawImage(uiImage, ui.Offset(-width / 2, -height / 2), paint);
    canvas.restore();

    if (clipped) {
      canvas.restore();
    }
  }


  @override
  int get assetIdPropertyKey => ImageBase.assetIdPropertyKey;

  @override
  bool import(ImportStack stack) {
    if (!registerWithImporter(stack)) {
      return false;
    }
    return super.import(stack);
  }

  @override
  void copy(covariant Image source) {
    super.copy(source);
    asset = source.asset;
  }
}

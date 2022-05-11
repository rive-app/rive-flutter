import 'dart:ui' as ui;

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/shapes/image_base.dart';
import 'package:rive/src/rive_core/assets/file_asset.dart';
import 'package:rive/src/rive_core/assets/image_asset.dart';
import 'package:rive/src/rive_core/bones/skinnable.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/math/aabb.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/shapes/mesh.dart';
import 'package:rive/src/rive_core/shapes/mesh_vertex.dart';

export 'package:rive/src/generated/shapes/image_base.dart';

class Image extends ImageBase
    with FileAssetReferencer<ImageAsset>, SkinnableProvider<MeshVertex> {
  ui.Image? get image => asset?.image;
  Mesh? _mesh;
  Mesh? get mesh => _mesh;
  bool get hasMesh => _mesh != null;

  AABB get localBounds {
    if (hasMesh && _mesh!.draws) {
      return _mesh!.bounds;
    }
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
    canvas.transform(renderTransform.mat4);
    if (_mesh == null || !_mesh!.draws) {
      canvas.drawImage(uiImage, ui.Offset(-width / 2, -height / 2), paint);
    } else {
      paint.shader = ui.ImageShader(
          uiImage,
          ui.TileMode.clamp,
          ui.TileMode.clamp,
          Float64List.fromList(<double>[
            1 / width,
            0.0,
            0.0,
            0.0,
            0.0,
            1 / height,
            0.0,
            0.0,
            0.0,
            0.0,
            1.0,
            0.0,
            0.0,
            0.0,
            0.0,
            1.0
          ]));
      _mesh!.draw(canvas, paint);
    }
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

  @override
  void childAdded(Component child) {
    super.childAdded(child);
    if (child is Mesh) {
      _mesh = child;
    }
  }

  @override
  void childRemoved(Component child) {
    super.childRemoved(child);
    if (child is Mesh && _mesh == child) {
      _mesh = null;
    }
  }

  @override
  Skinnable<MeshVertex>? get skinnable => _mesh;

  Mat2D get renderTransform {
    var mesh = _mesh;
    if (mesh != null && mesh.draws) {
      return mesh.worldTransform;
    }
    return worldTransform;
  }
}

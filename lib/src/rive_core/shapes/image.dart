import 'dart:ui' as ui;

import 'package:rive/src/generated/shapes/image_base.dart';
import 'package:rive/src/rive_core/assets/file_asset.dart';
import 'package:rive/src/rive_core/assets/image_asset.dart';
import 'package:rive/src/rive_core/bones/skinnable.dart';
import 'package:rive/src/rive_core/bounds_provider.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/container_component.dart';
import 'package:rive/src/rive_core/shapes/mesh.dart';
import 'package:rive/src/rive_core/shapes/mesh_vertex.dart';
import 'package:rive_common/math.dart';

export 'package:rive/src/generated/shapes/image_base.dart';

// const _logr = Debugr(true, prefix: 'image');

class Image extends ImageBase
    with
        FileAssetReferencer<ImageAsset>,
        SkinnableProvider<MeshVertex>,
        Sizable {
  ui.Image? get image => asset?.image;
  Mesh? _mesh;
  Mesh? get mesh => _mesh;
  bool get hasMesh => _mesh != null;

  double get width => image?.width.toDouble() ?? asset!.width;
  double get height => image?.height.toDouble() ?? asset!.height;

  @override
  AABB get localBounds {
    if (hasMesh && _mesh!.draws) {
      return _mesh!.bounds;
    }
    if (asset == null) {
      return AABB.empty();
    }
    return AABB.fromValues(
      -width * originX,
      -height * originY,
      -width * originX + width,
      -height * originY + height,
    );
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

    // if (width == 256 && height == 256 && {'badge_outline', 'ai_badge'}.contains(name) && Randoms().hit(0.005)) {
    //   _logr.log(() => 'DRAW > $runtimeType $name:$name_ assetId=$assetId size=$width:$height asset=${asset?.fileExtension}');
    //   debugPrintStack();
    // }

    final paint = ui.Paint()
      ..color = ui.Color.fromRGBO(0, 0, 0, renderOpacity)
      ..filterQuality = ui.FilterQuality.high
      ..blendMode = blendMode;

    canvas.save();
    canvas.transform(renderTransform.mat4);
    if (_mesh == null || !_mesh!.draws) {
      canvas.drawImage(
          uiImage, ui.Offset(-width * originX, -height * originY), paint);
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

  @override
  void originXChanged(double from, double to) => markTransformDirty();

  @override
  void originYChanged(double from, double to) => markTransformDirty();

  @override
  ui.Size computeIntrinsicSize(ui.Size min, ui.Size max) {
    return ui.Size(width * scaleX, height * scaleY);
  }

  @override
  void controlSize(ui.Size size) {
    scaleX = size.width / width;
    scaleY = size.height / height;

    markTransformDirty();
  }

  Mat2D get renderTransform {
    var mesh = _mesh;
    if (mesh != null && mesh.draws) {
      return mesh.worldTransform;
    }
    return worldTransform;
  }
}

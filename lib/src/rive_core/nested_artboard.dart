import 'dart:ui';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/backboard.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/generated/nested_artboard_base.dart';
export 'package:rive/src/generated/nested_artboard_base.dart';

/// Represents the nested Artboard that'll actually be mounted and placed into
/// the [NestedArtboard] component.
abstract class MountedArtboard {
  void draw(Canvas canvas);
  Mat2D get worldTransform;
  set worldTransform(Mat2D value);
}

class NestedArtboard extends NestedArtboardBase {
  MountedArtboard? _mountedArtboard;
  MountedArtboard? get mountedArtboard => _mountedArtboard;
  set mountedArtboard(MountedArtboard? value) {
    if (value == _mountedArtboard) {
      return;
    }
    _mountedArtboard = value;
    _mountedArtboard?.worldTransform = worldTransform;
    addDirt(ComponentDirt.paint);
  }

  @override
  void artboardIdChanged(int from, int to) {}


  @override
  void updateWorldTransform() {
    super.updateWorldTransform();
    _mountedArtboard?.worldTransform = worldTransform;
  }

  @override
  void draw(Canvas canvas) => mountedArtboard?.draw(canvas);

  @override
  bool import(ImportStack stack) {
    var backboardImporter =
        stack.latest<BackboardImporter>(BackboardBase.typeKey);
    if (backboardImporter == null) {
      return false;
    }
    backboardImporter.addNestedArtboard(this);

    return super.import(stack);
  }
}

import 'package:rive/src/generated/joystick_base.dart';
import 'package:rive/src/rive_core/animation/linear_animation.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/container_component.dart';
import 'package:rive/src/rive_core/transform_component.dart';
import 'package:rive/src/rive_core/world_transform_component.dart';
import 'package:rive_common/math.dart';

export 'package:rive/src/generated/joystick_base.dart';

class JoystickFlags {
  /// Whether to invert the application of the x axis.
  static const int invertX = 1 << 0;

  /// Whether to invert the application of the y axis.
  static const int invertY = 1 << 1;

  /// Whether this Joystick works in world space.
  static const int worldSpace = 1 << 2;
}

class Joystick extends JoystickBase {
  double get clampedX => x.clamp(-1, 1);
  double get clampedY => y.clamp(-1, 1);

  bool get isComplex => handleSource != null;

  @override
  void update(int dirt) {
    if (dirt & (ComponentDirt.transform | ComponentDirt.worldTransform) != 0) {
      _worldTransform = computeWorldTransform();
      Mat2D.invert(_inverseWorldTransform, _worldTransform);
      if (isComplex) {
        var pos = _inverseWorldTransform * handleSource!.worldTranslation;
        var local = localBounds.factorFrom(pos);

        x = local.x;
        y = local.y;
      }
    }
  }

  bool get invertX => (joystickFlags & JoystickFlags.invertX) != 0;
  set invertX(bool value) {
    if (value) {
      joystickFlags |= JoystickFlags.invertX;
    } else {
      joystickFlags &= ~JoystickFlags.invertX;
    }
  }

  bool get invertY => (joystickFlags & JoystickFlags.invertY) != 0;
  set invertY(bool value) {
    if (value) {
      joystickFlags |= JoystickFlags.invertY;
    } else {
      joystickFlags &= ~JoystickFlags.invertY;
    }
  }

  bool get inWorldSpace =>
      (joystickFlags & JoystickFlags.worldSpace) != 0 || handleSource != null;
  set inWorldSpace(bool value) {
    if (value) {
      joystickFlags |= JoystickFlags.worldSpace;
    } else {
      joystickFlags &= ~JoystickFlags.worldSpace;
    }
  }

  void apply(CoreContext context) {
    var animation = _xAnimation;

    if (animation != null) {
      var value = invertX ? -x : x;
      animation.apply(
        (value + 1) / 2 * animation.durationSeconds,
        coreContext: context,
      );
    }
    animation = _yAnimation;
    if (animation != null) {
      var value = invertY ? -y : y;
      animation.apply(
        (value + 1) / 2 * animation.durationSeconds,
        coreContext: context,
      );
    }
  }

  @override
  void xChanged(double from, double to) {
    context.markNeedsAdvance();
  }

  @override
  void buildDependencies() {
    super.buildDependencies();
    parent?.addDependent(this);
    handleSource?.addDependent(this);
  }

  Vec2D get position => Vec2D.fromValues(posX, posY);
  Mat2D _worldTransform = Mat2D();
  final Mat2D _inverseWorldTransform = Mat2D();

  Mat2D computeWorldTransform() {
    var local = Mat2D.fromTranslation(position);
    if (parent is WorldTransformComponent) {
      var world = Mat2D.multiply(
          Mat2D(), (parent as WorldTransformComponent).worldTransform, local);
      if (!inWorldSpace) {
        return Mat2D.fromTranslation(world.translation);
      }
      return world;
    }
    return local;
  }

  Mat2D get worldTransform =>
      inWorldSpace ? _worldTransform : computeWorldTransform();

  @override
  void yChanged(double from, double to) {
    context.markNeedsAdvance();
  }

  @override
  void xIdChanged(int from, int to) {
    xAnimation = xId == Core.missingId ? null : context.resolve(xId);
  }

  @override
  void yIdChanged(int from, int to) {
    yAnimation = yId == Core.missingId ? null : context.resolve(yId);
  }

  LinearAnimation? _xAnimation;
  LinearAnimation? _yAnimation;

  LinearAnimation? get xAnimation => _xAnimation;
  LinearAnimation? get yAnimation => _yAnimation;

  set xAnimation(LinearAnimation? value) {
    if (_xAnimation == value) {
      return;
    }

    _xAnimation = value;
  }

  set yAnimation(LinearAnimation? value) {
    if (_yAnimation == value) {
      return;
    }

    _yAnimation = value;
  }

  @override
  void onAdded() {
    super.onAdded();
    if (xId >= 0 && xId < context.animations.length) {
      var found = context.animations[xId];
      if (found is LinearAnimation) {
        xAnimation = found;
      }
    }
    if (yId >= 0 && yId < context.animations.length) {
      var found = context.animations[yId];
      if (found is LinearAnimation) {
        yAnimation = found;
      }
    }
  }

  @override
  void onAddedDirty() {
    super.onAddedDirty();

    handleSource = context.resolve(handleSourceId);
  }

  void _transformChanged() {
    markTransformDirty();
  }

  @override
  void heightChanged(double from, double to) {}

  @override
  void posXChanged(double from, double to) => _transformChanged();

  @override
  void posYChanged(double from, double to) => _transformChanged();

  @override
  void widthChanged(double from, double to) {}

  static const double minStageSize = 0;
  bool get isSliderY => xAnimation == null && yAnimation != null;
  bool get isSliderX => yAnimation == null && xAnimation != null;

  double get stageWidth => isSliderY ? minStageSize : width;
  double get stageHeight => isSliderX ? minStageSize : height;

  AABB get localBounds => AABB.fromValues(
        -stageWidth * originX,
        -stageHeight * originY,
        -stageWidth * originX + stageWidth,
        -stageHeight * originY + stageHeight,
      );

  Mat2D get transform => Mat2D.fromTranslation(position);

  @override
  void originXChanged(double from, double to) => _transformChanged();

  @override
  void originYChanged(double from, double to) => _transformChanged();

  @override
  void joystickFlagsChanged(int from, int to) {
    context.markNeedsAdvance();

    markTransformDirty();
  }

  TransformComponent? _handleSource;
  TransformComponent? get handleSource => _handleSource;
  set handleSource(TransformComponent? value) {
    if (_handleSource == value) {
      return;
    }

    _handleSource = value;
    handleSourceId = value?.id ?? Core.missingId;
    markTransformDirty();
  }

  @override
  void handleSourceIdChanged(int from, int to) {
    handleSource = context.resolve(to);
    markRebuildDependencies();
  }

  void markTransformDirty() {
    if (!inWorldSpace) {
      return;
    }
    if (!addDirt(ComponentDirt.transform)) {
      return;
    }
    addDirt(ComponentDirt.worldTransform, recurse: true);
  }
}

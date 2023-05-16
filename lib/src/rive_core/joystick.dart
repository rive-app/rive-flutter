import 'package:rive/src/generated/joystick_base.dart';
import 'package:rive/src/rive_core/animation/linear_animation.dart';
import 'package:rive/src/rive_core/container_component.dart';

export 'package:rive/src/generated/joystick_base.dart';

class Joystick extends JoystickBase {
  double get clampedX => x.clamp(-1, 1);
  double get clampedY => y.clamp(-1, 1);

  @override
  void update(int dirt) {}

  void apply(CoreContext context) {
    var animation = _xAnimation;
    if (animation != null) {
      animation.apply(
        (x + 1) / 2 * animation.durationSeconds,
        coreContext: context,
      );
    }
    animation = _yAnimation;
    if (animation != null) {
      animation.apply(
        (y + 1) / 2 * animation.durationSeconds,
        coreContext: context,
      );
    }
  }

  @override
  void xChanged(double from, double to) {
    context.markNeedsAdvance();
  }

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
}

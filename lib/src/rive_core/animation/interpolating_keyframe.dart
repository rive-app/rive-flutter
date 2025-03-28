import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/interpolating_keyframe_base.dart';
import 'package:rive/src/rive_core/animation/cubic_interpolator.dart';
import 'package:rive/src/rive_core/animation/cubic_value_interpolator.dart';
import 'package:rive/src/rive_core/animation/interpolator.dart';
import 'package:rive/src/rive_core/animation/keyframe_interpolation.dart';
import 'package:rive/src/rive_core/enum_helper.dart';

export 'package:rive/src/generated/animation/interpolating_keyframe_base.dart';

abstract class InterpolatingKeyFrame extends InterpolatingKeyFrameBase {
  @override
  bool get canInterpolate => true;

  KeyFrameInterpolation get interpolation => enumAt(KeyFrameInterpolation.values, interpolationType);
  set interpolation(KeyFrameInterpolation value) => interpolationType = value.index;

  Interpolator _interpolator = Interpolators.initial;
  Interpolator? get interpolator => _interpolator == Interpolators.initial ? null : _interpolator;
  set interpolator(Interpolator? value) {
    if (_interpolator == value) {
      return;
    }

    _interpolator = value ?? Interpolators.initial;
    // interpolatorId = value?.id ?? Core.missingId;
    // interpolatorId = value;//?.id ?? Core.missingId;
  }

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is InterpolatingKeyFrame) {
      _interpolator = source._interpolator;
    }
  }

  /// The id of the custom interpolator used when interpolation is Cubic.
  @override
  // int get interpolatorId => _interpolator?.id ?? Core.missingId;
  int get interpolatorId => _interpolator.id;

  // Interpolator _interpolator = nullInterpolator;
  // Interpolator? get interpolator => _interpolator == nullInterpolator ? null : _interpolator;
  // set interpolator(Interpolator? value) {
  //   if (_interpolator == value) {
  //     return;
  //   }
  //
  //   _interpolator = value == null ? nullInterpolator :  value;
  //   interpolatorId = value?.id ?? Core.missingId;
  // }

  @override
  void interpolatorIdChanged(int from, int to) {
    // This might resolve to null during a load or if context isn't available
    // yet so we also do this in onAddedDirty.
    if (hasValidated) {
      _interpolator = context.resolve(to) ?? Interpolators.late(to);
    } else {
      _interpolator = Interpolators.late(to);
    }
  }

  @override
  void onAddedDirty() {
    super.onAddedDirty();
    if (interpolatorId != Core.missingId && _interpolator.late) {
      _interpolator = context.resolve(interpolatorId) ?? Interpolators.late(interpolatorId);
    }
    // Ensure interpolation types are valid, correct them if not.
    switch (interpolation) {
      case KeyFrameInterpolation.cubicValue:
        if (interpolator is! CubicValueInterpolator) {
          interpolation = canInterpolate
              ? KeyFrameInterpolation.linear
              : KeyFrameInterpolation.hold;
        }
        break;
      case KeyFrameInterpolation.cubic:
        if (interpolator is! CubicInterpolator) {
          interpolation = canInterpolate
              ? KeyFrameInterpolation.linear
              : KeyFrameInterpolation.hold;
        }
        break;
      default:
        break;
    }
  }
}

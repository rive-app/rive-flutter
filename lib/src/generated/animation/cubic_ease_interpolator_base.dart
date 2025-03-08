// Core automatically generated
// lib/src/generated/animation/cubic_ease_interpolator_base.dart.
// Do not modify manually.

import 'package:rive/src/generated/animation/keyframe_interpolator_base.dart';
import 'package:rive/src/rive_core/animation/cubic_interpolator.dart';

const _coreTypes = <int>{
  CubicEaseInterpolatorBase.typeKey,
  CubicInterpolatorBase.typeKey,
  KeyFrameInterpolatorBase.typeKey
};

abstract class CubicEaseInterpolatorBase extends CubicInterpolator {
  static const int typeKey = 28;
  @override
  int get coreType => CubicEaseInterpolatorBase.typeKey;
  @override
  Set<int> get coreTypes => _coreTypes;
}

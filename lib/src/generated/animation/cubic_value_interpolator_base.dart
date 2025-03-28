// Core automatically generated
// lib/src/generated/animation/cubic_value_interpolator_base.dart.
// Do not modify manually.

import 'package:rive/src/generated/animation/keyframe_interpolator_base.dart';
import 'package:rive/src/rive_core/animation/cubic_interpolator.dart';

const _coreTypes = <int>{
  CubicValueInterpolatorBase.typeKey,
  CubicInterpolatorBase.typeKey,
  KeyFrameInterpolatorBase.typeKey
};

abstract class CubicValueInterpolatorBase extends CubicInterpolator {
  static const int typeKey = 138;
  @override
  int get coreType => CubicValueInterpolatorBase.typeKey;
  @override
  Set<int> get coreTypes => _coreTypes;
}

import 'package:rive/src/rive_core/animation/cubic_interpolator.dart';

abstract class CubicEaseInterpolatorBase extends CubicInterpolator {
  static const int typeKey = 28;
  @override
  int get coreType => CubicEaseInterpolatorBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {CubicEaseInterpolatorBase.typeKey, CubicInterpolatorBase.typeKey};
}

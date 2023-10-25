/// The type of interpolation used for a keyframe.
enum KeyFrameInterpolation {
  /// Hold the incoming value until the next keyframe is reached.
  hold,

  /// Linearly interpolate from the incoming to the outgoing value.
  linear,

  /// Cubicly interpolate from incoming to outgoing value based on the
  /// [CubicInterpolator]'s parameters.
  cubic,

  /// Cubicly interpolate from incoming to outgoing value based on the
  /// [CubicInterpolator]'s parameters.
  cubicValue,

  /// Elastic easing.
  elastic,
}

extension KeyFrameInterpolationExtension on KeyFrameInterpolation {
  /// Should this type use the interpolation value field beneath the
  /// curve preview
  bool get usesValuesField => [
        KeyFrameInterpolation.hold,
        KeyFrameInterpolation.linear,
        KeyFrameInterpolation.cubic,
      ].contains(this);
}

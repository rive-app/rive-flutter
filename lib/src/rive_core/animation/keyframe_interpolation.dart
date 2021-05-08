/// The type of interpolation used for a keyframe.
enum KeyFrameInterpolation {
  /// Hold the incoming value until the next keyframe is reached.
  hold,

  /// Linearly interpolate from the incoming to the outgoing value.
  linear,

  /// Cubicly interpolate from incoming to outgoing value based on the
  /// [CubicInterpolator]'s parameters.
  cubic,
}

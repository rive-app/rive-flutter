class ComponentFlags {
  /// Whether the component should be drawn (at runtime this only used by
  /// drawables and paths).
  static const int hidden = 1 << 0;

  // Whether the component was locked for editing in the editor.
  static const int locked = 1 << 1;

  /// These options are used by [TransformComponentConstraint]s, any other
  /// component that's not in that class hierarchy can re-use these values as
  /// they won't collide.
  ///
  /// -----------

  /// Whether the [TransformComponentConstraint]'s constrained value is offset
  /// from the design time value (in the matching space).
  static const int offset = 1 << 2;

  /// Whether the transform component is copied.
  static const int copy = 1 << 3;

  /// Set when a minimum value should be applied to the constrained value.
  static const int min = 1 << 4;

  /// Set when a maximum value should be applied to the constrained value.
  static const int max = 1 << 5;

  /// Whether an X transform component is copied.
  static const int copyX = 1 << 3;

  /// Set when a minimum value should be applied to the constrained X value.
  static const int minX = 1 << 4;

  /// Set when a maximum value should be applied to the constrained X value.
  static const int maxX = 1 << 5;

  /// Whether a Y transform component is copied.
  static const int copyY = 1 << 6;

  /// Set when a minimum value should be applied to the constrained Y value.
  static const int minY = 1 << 7;

  /// Set when a maximum value should be applied to the constrained Y value.
  static const int maxY = 1 << 8;

  /// End of TransformComponentConstraint
  ///
  /// ----------

}

class ComponentFlags {
  /// Whether the component should be drawn (at runtime this only used by
  /// drawables and paths).
  static const int hidden = 1 << 0;

  // Whether the component was locked for editing in the editor.
  static const int locked = 1 << 1;
}

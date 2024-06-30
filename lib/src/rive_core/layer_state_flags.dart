class LayerStateFlags {
  /// Whether the state can randomize on exit.
  static const int random = 1 << 0;

  /// Whether the blend should include an instance to reset values on apply
  static const int reset = 1 << 1;
}

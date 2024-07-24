class DataBindFlags {
  /// Whether the main binding direction is to target (0) or to source (1)
  static const int direction = 1 << 0;

  /// Whether the binding direction is twoWay
  static const int twoWay = 1 << 1;

  /// Whether the binding happens only once
  static const int once = 1 << 2;

  static const int toTarget = 0;

  static const int toSource = 1 << 0;
}

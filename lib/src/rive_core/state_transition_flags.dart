class StateTransitionFlags {
  /// Whether the transition is disabled.
  static const int disabled = 1 << 0;

  /// Whether the transition duration is a percentage or time in ms.
  static const int durationIsPercentage = 1 << 1;

  /// Whether exit time is enabled.
  static const int enableExitTime = 1 << 2;

  /// Whether the exit time is a percentage or time in ms.
  static const int exitTimeIsPercentage = 1 << 3;

  /// Whether the animation is held at exit or if it keeps advancing during
  /// mixing.
  static const int pauseOnExit = 1 << 4;
}

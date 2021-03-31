class StateTransitionFlags {
  static const int disabled = 1 << 0;
  static const int durationIsPercentage = 1 << 1;
  static const int enableExitTime = 1 << 2;
  static const int exitTimeIsPercentage = 1 << 3;
  static const int pauseOnExit = 1 << 4;
}

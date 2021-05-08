/// Loop options for linear animations.
enum Loop {
  /// Play until the duration or end of work area of the animation.
  oneShot,

  /// Play until the duration or end of work area of the animation and then go
  /// back to the start (0 seconds).
  loop,

  /// Play to the end of the duration/work area and then play back.
  pingPong,
}

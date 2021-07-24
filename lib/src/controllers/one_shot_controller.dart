import 'dart:ui' show VoidCallback;

import 'package:flutter/widgets.dart';
import 'package:rive/src/controllers/simple_controller.dart';

/// Controller tailered for managing one-shot animations
class OneShotAnimation extends SimpleAnimation {
  /// Prevents animation from resetting when animation stops being active
  final bool resetOnStop;
  
  /// Fires when the animation stops being active
  final VoidCallback? onStop;

  /// Fires when the animation starts being active
  final VoidCallback? onStart;

  OneShotAnimation(
    String animationName, {
    double mix = 1,
    bool autoplay = true,
    this.resetOnStop = true,
    this.onStop,
    this.onStart,
  }) : super(animationName, mix: mix, autoplay: autoplay) {
    isActiveChanged.addListener(onActiveChanged);
  }

  /// Dispose of any callback listeners
  @override
  void dispose() {
    super.dispose();
    isActiveChanged.removeListener(onActiveChanged);
  }

  /// Perform tasks when the animation's active state changes
  void onActiveChanged() {
    // If the animation stops and it is at the end of the one-shot, reset the
    // animation back to the starting time
    if (!isActive && resetOnStop) {
      reset();
    }
    // Fire any callbacks
    isActive
        ? onStart?.call()
        // onStop can fire while widgets are still drawing
        : WidgetsBinding.instance?.addPostFrameCallback((_) => onStop?.call());
  }
}

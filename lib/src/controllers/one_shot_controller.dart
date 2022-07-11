import 'package:flutter/widgets.dart';
import 'package:rive/src/controllers/simple_controller.dart';

/// This allows a value of type T or T?
/// to be treated as a value of type T?.
///
/// We use this so that APIs that have become
/// non-nullable can still be used with `!` and `?`
/// to support older versions of the API as well.
T? _ambiguate<T>(T? value) => value;

/// Controller tailored for managing one-shot animations
class OneShotAnimation extends SimpleAnimation {
  /// Fires when the animation stops being active
  final VoidCallback? onStop;

  /// Fires when the animation starts being active
  final VoidCallback? onStart;

  OneShotAnimation(
    String animationName, {
    double mix = 1,
    bool autoplay = true,
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
    if (!isActive) {
      reset();
    }
    // Fire any callbacks
    isActive
        ? onStart?.call()
        // onStop can fire while widgets are still drawing
        : _ambiguate(WidgetsBinding.instance)
            ?.addPostFrameCallback((_) => onStop?.call());
  }
}

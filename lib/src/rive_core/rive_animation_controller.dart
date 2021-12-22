import 'package:flutter/foundation.dart';

/// Abstraction for receiving a per frame callback while isPlaying is true to
/// apply animation based on an elapsed amount of time.
abstract class RiveAnimationController<T> {
  final _isActive = ValueNotifier<bool>(false);
  ValueListenable<bool> get isActiveChanged => _isActive;

  bool get isActive => _isActive.value;
  set isActive(bool value) {
    if (_isActive.value != value) {
      _isActive.value = value;
      if (value) {
        onActivate();
      } else {
        onDeactivate();
      }
    }
  }

  @protected
  void onActivate() {}
  @protected
  void onDeactivate() {}

  /// Apply animation to objects registered in [core]. Note that a [core]
  /// context is specified as animations can be applied to instances.
  void apply(T core, double elapsedSeconds);

  bool init(T core) => true;
  void dispose() {}
}

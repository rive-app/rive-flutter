import 'package:flutter/foundation.dart';

/// Abstraction for receiving a per frame callback while isPlaying is true to
/// apply animation based on an elapsed amount of time.
abstract class RiveAnimationController<T> {
  final _isActive = ValueNotifier<bool>(false);
  ValueListenable<bool> get isActiveChanged => _isActive;

  // TODO: this is a hack.
  // Ideally nestedArtboards are not run in the Artboard.advance, but instead
  // always controlled by AnimationControllers.
  // SimpleAnimationControllers kinda throw a spanner in the works here.
  // unless we do some magic that means multiple simple animation controllers
  // won't all compete for advancing the nested artboard....
  final suppressesNestedArtboards = false;

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

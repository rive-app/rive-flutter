import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

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
  void apply(T core, double elapsedSeconds);
  bool init(T core) => true;
  void dispose() {}
}

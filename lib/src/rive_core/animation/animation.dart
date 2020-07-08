import 'package:rive/src/core/core.dart';
import 'package:meta/meta.dart';
import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/generated/animation/animation_base.dart';
export 'package:rive/src/generated/animation/animation_base.dart';

class Animation extends AnimationBase<RuntimeArtboard> {
  Artboard _artboard;
  Artboard get artboard => _artboard;
  set artboard(Artboard value) {
    if (_artboard == value) {
      return;
    }
    var old = _artboard;
    _artboard = value;
    artboardChanged(old, value);
  }

  @protected
  void artboardChanged(Artboard from, Artboard to) {
    from?.internalRemoveAnimation(this);
    to?.internalAddAnimation(this);
  }

  @override
  void onAdded() {}
  @override
  void onAddedDirty() {}
  @override
  void onRemoved() {
    artboard = null;
  }

  @override
  void nameChanged(String from, String to) {}
}

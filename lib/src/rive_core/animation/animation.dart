import 'package:rive/src/core/core.dart';
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
    _artboard?.internalRemoveAnimation(this);
    _artboard = value;
    _artboard?.internalAddAnimation(this);
  }

  @override
  void onAdded() {}
  @override
  void onAddedDirty() {}
  @override
  void onRemoved() {
    artboard = null;
    super.onRemoved();
  }

  @override
  void nameChanged(String from, String to) {}
}

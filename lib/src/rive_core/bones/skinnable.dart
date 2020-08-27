import 'package:rive/src/rive_core/bones/skin.dart';
import 'package:rive/src/rive_core/component.dart';

abstract class Skinnable {
  Skin _skin;
  Skin get skin => _skin;
  void appendChild(Component child);
  void addSkin(Skin skin) {
    assert(skin != null);
    _skin = skin;
    markSkinDirty();
  }

  void removeSkin(Skin skin) {
    if (_skin == skin) {
      _skin = null;
      markSkinDirty();
    }
  }

  void markSkinDirty();
}

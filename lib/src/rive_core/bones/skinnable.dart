import 'package:rive/src/rive_core/bones/skin.dart';
import 'package:rive/src/rive_core/component.dart';

import 'package:rive/src/rive_core/shapes/vertex.dart';

/// An abstraction to give a common interface to any container component that
/// can contain a skin to bind bones to.
abstract class Skinnable<T extends Vertex> {
  // _skin is null when this object isn't connected to bones.
  Skin? _skin;
  Skin? get skin => _skin;

  void appendChild(Component child);

  // ignore: use_setters_to_change_properties
  void addSkin(Skin skin) {
    // Notify old skin/maybe support multiple skins in the future?
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

abstract class SkinnableProvider<T extends Vertex> {
  Skinnable<T>? get skinnable;
}

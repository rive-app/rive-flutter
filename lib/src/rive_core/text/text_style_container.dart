import 'dart:collection';

import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/container_component.dart';
import 'package:rive/src/rive_core/text/text_style.dart';
import 'package:rive_common/utilities.dart';

/// An abstraction to give a common interface to any component that can contain
/// TextStyles. Currently used by the [Text] object but we can later support
/// file-wide styles by making them owned by an [Artboard] or [Backboard].
abstract class TextStyleContainer {
  int _nextShaperId = 0;
  final Set<TextStyle> styles = <TextStyle>{}; // preserve order
  final HashMap<int, TextStyle> _styleLookup = HashMap<int, TextStyle>();

  // TextStyle? styleFromShaperId(int id) => _styleLookup[id];

  void disposeStyleContainer() {
    _styleLookup.clear();
    styles.clear();
  }

  bool addStyle(TextStyle style) {
    if (styles.add(style)) {
      _registerStyle(style);

      return true;
    }
    return false;
  }

  void _registerStyle(TextStyle style) {
    if (style.shaperId == -1) {
      style.shaperId = _nextShaperId++;
      _styleLookup[style.shaperId] = style;
    }
  }

  ContainerChildren get children;
  void updateStyles() {
    var nextStyles = children.whereType<TextStyle>();
    if (!iterableEquals(nextStyles, styles)) {
      styles.clear();
      styles.addAll(nextStyles);

      // styles.forEach(_registerStyle);
      for (final s in styles) {
        _registerStyle(s);
      }
    }
  }

  bool removeStyle(TextStyle style) {
    if (styles.remove(style)) {
      return true;
    }
    return false;
  }

  /// These usually gets auto implemented as this mixin is meant to be added to
  /// a ComponentBase. This way the implementor doesn't need to cast
  /// ShapePaintContainer to ContainerComponent/Shape/Artboard/etc.
  bool addDirt(int value, {bool recurse = false});

  bool addDependent(Component dependent, {Component? via});
  void appendChild(Component child);
  // Mat2D get worldTransform;
  // Vec2D get worldTranslation;
}

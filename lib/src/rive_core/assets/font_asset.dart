import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:rive/src/generated/assets/font_asset_base.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/text/text_style.dart';
import 'package:rive_common/rive_text.dart';

export 'package:rive/src/generated/assets/font_asset_base.dart';

class FontAsset extends FontAssetBase {
  final Set<VoidCallback> _callbacks = HashSet<VoidCallback>();//{};

  /// Call [callback] when the font is ready. Set [notifyAlreadySet] to
  /// specify if you want to be called if the font is already set.
  bool setFontCallback(
    VoidCallback callback, {
    bool notifyAlreadySet = true,
  }) {
    if (font != null) {
      if (notifyAlreadySet) {
        callback();
      }
      return true;
    }

    _callbacks.add(callback);
    return false;
  }

  Font? _font;
  Font? get font => _font;
  set font(Font? font) {
    if (_font == font) {
      return;
    }
    _font = font;

    var callbacks = _callbacks.toList(growable: false);
    _callbacks.clear();
    for (final callback in callbacks) {
      callback();
    }

    // the referencer could register a callback as well rather
    // actual referencers. might be cleaner for this specific scenario
    // but i'm not sure if there are other use-cases for the back-ref
    // that will require a different paradigm
    for (final referencer in fileAssetReferencers) {
      final target = referencer.target;
      if (target is TextStyle) {
        target.addDirt(ComponentDirt.textShape);
      }
    }
  }

  @override
  Future<void> decode(Uint8List bytes) async {
    font = await parseBytes(bytes);
  }

  static Future<Font?> parseBytes(Uint8List bytes) async {
    return Font.decode(bytes);
  }

  @override
  void onRemoved() {
    super.onRemoved();
    font?.dispose();
    font = null;
  }

  // 'otf' supported as well. This getter isn't being used for fontAssets so
  // fine just being ttf for now.
  @override
  String get fileExtension => 'ttf';
}

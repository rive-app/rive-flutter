import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rive/src/generated/assets/font_asset_base.dart';
import 'package:rive_common/rive_text.dart';

export 'package:rive/src/generated/assets/font_asset_base.dart';

class FontAsset extends FontAssetBase {
  final Set<VoidCallback> _callbacks = {};

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

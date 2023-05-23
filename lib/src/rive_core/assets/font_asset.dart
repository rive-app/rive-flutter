import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rive/src/generated/assets/font_asset_base.dart';
import 'package:rive_common/rive_text.dart';

export 'package:rive/src/generated/assets/font_asset_base.dart';

class FontAsset extends FontAssetBase {
  final Set<VoidCallback> _decodedCallbacks = {};

  /// Call [callback] when the font is ready. Set [notifyAlreadyDecoded] to
  /// specify if you want to be called if the font is already decoded.
  bool whenDecoded(VoidCallback callback, {bool notifyAlreadyDecoded = true}) {
    if (font != null) {
      if (notifyAlreadyDecoded) {
        callback();
      }
      return true;
    }

    _decodedCallbacks.add(callback);
    return false;
  }

  Font? font;
  @override
  Future<void> decode(Uint8List bytes) async {
    font = Font.decode(bytes);
    var callbacks = _decodedCallbacks.toList(growable: false);
    _decodedCallbacks.clear();
    for (final callback in callbacks) {
      callback();
    }
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

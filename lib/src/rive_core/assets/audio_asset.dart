import 'dart:typed_data';

import 'package:rive/src/generated/assets/audio_asset_base.dart';
import 'package:rive/src/rive_core/assets/file_asset.dart';

export 'package:rive/src/generated/assets/audio_asset_base.dart';

class AudioAsset extends AudioAssetBase {
  // TODO: we probably want a specific audio object in the future..
  Uint8List? _audioBytes;
  Uint8List? get audioBytes => _audioBytes;
  set audioBytes(Uint8List? bytes) {
    if (_audioBytes == bytes) {
      return;
    }
    _audioBytes = bytes;
  }

  @override
  Future<void> decode(Uint8List bytes) async {
    audioBytes = bytes;
  }

  @override
  String get fileExtension => 'wav';

  @override
  void onAssetError() {}

  @override
  bool get isAnalyzed => true;

  @override
  bool get canDraw => isAnalyzed && audioBytes != null;
}

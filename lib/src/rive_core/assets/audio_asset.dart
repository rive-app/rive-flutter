import 'package:flutter/foundation.dart';
import 'package:rive/src/generated/assets/audio_asset_base.dart';
import 'package:rive_common/rive_audio.dart';

export 'package:rive/src/generated/assets/audio_asset_base.dart';

enum AudioContainerFormat { unknown, wav, flac, mp3 }

class AudioAsset extends AudioAssetBase {
  Uint8List? _audioBytes;
  final ValueNotifier<StreamingAudioSource?> audioSource = ValueNotifier(null);

  Uint8List? get audioBytes => _audioBytes;
  set audioBytes(Uint8List? bytes) {
    if (_audioBytes == bytes) {
      return;
    }
    _audioBytes = bytes;
    audioSource.value?.dispose();
    if (bytes != null) {
      audioSource.value = AudioEngine.loadSource(bytes);
    } else {
      audioSource.value = null;
    }
  }

  @override
  Future<void> decode(Uint8List bytes) async {
    audioBytes = bytes;
  }

  static AudioContainerFormat containerFormatFromName(String name) {
    switch (name) {
      case 'flac':
        return AudioContainerFormat.flac;
      case 'mp3':
        return AudioContainerFormat.mp3;
      case 'wav':
        return AudioContainerFormat.wav;
    }
    return AudioContainerFormat.unknown;
  }

  // See comment in font_asset.dart
  @override
  String get fileExtension => 'wav';
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

/// An example showing how to load audio assets.
///
/// See: https://rive.app/docs/runtimes/loading-assets
class ExampleOutOfBandAssetAudioLoading extends StatefulWidget {
  const ExampleOutOfBandAssetAudioLoading({Key? key}) : super(key: key);

  @override
  State<ExampleOutOfBandAssetAudioLoading> createState() =>
      _ExampleOutOfBandAssetAudioLoadingState();
}

class _ExampleOutOfBandAssetAudioLoadingState
    extends State<ExampleOutOfBandAssetAudioLoading> {
  var _loading = true;
  late RiveWidgetController _controller;

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadAudio(AudioAsset asset) async {
    final bytes = await rootBundle.load('assets/audio/${asset.uniqueFilename}');
    asset.decode(bytes.buffer.asUint8List());

    // Alternatively, if you know the names you can preload the audio files before
    // loading the Rive file.

    // AudioSource? audioSource =
    //     await Factory.rive.decodeAudio(bytes.buffer.asUint8List());
    // if (audioSource != null) {
    //   asset.audio(audioSource);
    // }
  }

  Future<void> _loadFiles() async {
    final file = await File.asset(
      'assets/ping_pong_audio_demo.riv',
      riveFactory: Factory.rive,
      assetLoader: (asset, bytes) {
        if (asset is AudioAsset && bytes == null) {
          _loadAudio(asset);
          return true;
        }
        return false;
      },
    );
    if (file == null) {
      return;
    }
    setState(() {
      _loading = false;
    });
    _controller = RiveWidgetController(file);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return RiveWidget(controller: _controller);
  }
}

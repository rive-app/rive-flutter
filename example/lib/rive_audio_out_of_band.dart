import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RiveAudioOutOfBandExample extends StatefulWidget {
  const RiveAudioOutOfBandExample({super.key});

  @override
  State<RiveAudioOutOfBandExample> createState() =>
      _RiveAudioOutOfBandExampleState();
}

class _RiveAudioOutOfBandExampleState extends State<RiveAudioOutOfBandExample> {
  @override
  void initState() {
    super.initState();
    _loadRiveFile();
  }

  RiveFile? _riveAudioAssetFile;

  Future<void> _loadRiveFile() async {
    final riveFile = await RiveFile.asset(
      'assets/ping_pong_audio_demo.riv',
      assetLoader: LocalAssetLoader(audioPath: 'assets/audio'),
    );
    setState(() {
      _riveAudioAssetFile = riveFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_riveAudioAssetFile == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rive Audio [Out-of-Band]'),
      ),
      body: RiveAnimation.direct(
        _riveAudioAssetFile!,
        stateMachines: const ['State Machine 1'],
        fit: BoxFit.cover,
      ),
    );
  }
}

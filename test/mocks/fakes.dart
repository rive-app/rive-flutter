import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';

class ArtboardFake extends Fake implements Artboard {
  bool _isPlaying = true;

  @override
  bool get isPlaying => _isPlaying;

  @override
  void pause() {
    _isPlaying = false;
  }

  @override
  void play() {
    _isPlaying = true;
  }
}

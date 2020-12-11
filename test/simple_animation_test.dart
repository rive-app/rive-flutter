import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';

void main() {
  ByteData riveData;

  void loadTestAssets() {
    riveData = ByteData.sublistView(
      File('assets/animations_0_6_2.riv').readAsBytesSync(),
    );
  }

  setUp(loadTestAssets);

  test('SimpleAnimation exposes mix', () {
    // Load a Rive file
    final riveFile = RiveFile();
    expect(riveFile.import(riveData), true);
    expect(riveFile.mainArtboard.name, 'My Artboard');

    final firstController =
        SimpleAnimation(riveFile.mainArtboard.animations.first.name);
    expect(firstController.animationName, 'First');
    expect(firstController.mix, 1.0);

    firstController.mix = 0.5;
    expect(firstController.mix, 0.5);

    firstController.mix = 2.5;
    expect(firstController.mix, 1.0);

    firstController.mix = -1;
    expect(firstController.mix, 0.0);

    final secondController =
        SimpleAnimation(riveFile.mainArtboard.animations.last.name, mix: 0.8);
    expect(secondController.animationName, 'Second');
    expect(secondController.mix, 0.8);
  });
}

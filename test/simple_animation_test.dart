import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';

import 'src/utils.dart';

void main() {
  late RiveFile riveFile;

  setUp(() {
    final riveBytes = loadFile('assets/rive-flutter-test-asset.riv');
    riveFile = RiveFile.import(riveBytes);
  });

  test('SimpleAnimation exposes mix', () {
    expect(riveFile.mainArtboard.name, 'Artboard 1');

    final firstController =
        SimpleAnimation(riveFile.mainArtboard.animations.first.name);
    expect(firstController.animationName, 'Animation 1');
    expect(firstController.mix, 1.0);

    firstController.mix = 0.5;
    expect(firstController.mix, 0.5);

    firstController.mix = 2.5;
    expect(firstController.mix, 1.0);

    firstController.mix = -1;
    expect(firstController.mix, 0.0);

    final secondController =
        SimpleAnimation(riveFile.mainArtboard.animations[1].name, mix: 0.8);
    expect(secondController.animationName, 'Animation 2');
    expect(secondController.mix, 0.8);
  });
}

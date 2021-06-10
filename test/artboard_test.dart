import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';

import 'src/utils.dart';

void main() {
  late RiveFile riveFile;

  setUp(() {
    final riveBytes = loadFile('assets/rive-flutter-test-asset.riv');
    riveFile = RiveFile.import(riveBytes);
  });

  test('Artboards can be read from files', () {
    expect(riveFile.mainArtboard.name, 'Artboard 1');
    expect(riveFile.artboards.length, 2);
    expect(riveFile.artboardByName('Artboard 2'), isNotNull);
  });

  test('Animations can be read from artboards', () {
    final artboard = riveFile.mainArtboard;
    expect(artboard.animations.length, 3);
    expect(artboard.animations.first.name, 'Animation 1');
    expect(artboard.animations[1].name, 'Animation 2');
    expect(artboard.animations.last.name, 'State Machine 1');
  });

  test('Animations can be read by name from artboards', () {
    final artboard = riveFile.mainArtboard;
    expect(artboard.animationByName('Animation 1'), isNotNull);
    expect(artboard.animationByName('Animation 2'), isNotNull);
    expect(artboard.animationByName('Does Not Exist'), isNull);
    expect(artboard.animationByName('Animation 1') is LinearAnimationInstance,
        true);
  });

  test('Linear animations can be retreived ffrom artboards', () {
    final artboard = riveFile.mainArtboard;
    expect(artboard.linearAnimations.toList().length, 2);
    expect(artboard.stateMachines.toList().length, 1);
  });
}

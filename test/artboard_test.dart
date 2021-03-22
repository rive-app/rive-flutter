import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';

void main() {
  late ByteData multipleArtboardsBytes;

  void loadTestAssets() {
    multipleArtboardsBytes = ByteData.sublistView(
        File('assets/animations_0_6_2.riv').readAsBytesSync());
  }

  setUp(loadTestAssets);

  test('Artboards can be read from files', () {
    RiveFile riveFile = RiveFile.import(multipleArtboardsBytes);
    expect(riveFile.mainArtboard.name, 'My Artboard');
  });

  test('Animations can be read from artboards', () {
    final riveFile = RiveFile.import(multipleArtboardsBytes);
    final artboard = riveFile.mainArtboard;
    expect(artboard.animations.length, 2);
    expect(artboard.animations.first.name, 'First');
    expect(artboard.animations.last.name, 'Second');
  });

  test('Animations can be read by name from artboards', () {
    final riveFile = RiveFile.import(multipleArtboardsBytes);
    final artboard = riveFile.mainArtboard;
    expect(artboard.animationByName('First'), isNotNull);
    expect(artboard.animationByName('Second'), isNotNull);
    expect(artboard.animationByName('Does Not Exist'), isNull);
    expect(artboard.animationByName('First') is LinearAnimationInstance, true);
  });
}

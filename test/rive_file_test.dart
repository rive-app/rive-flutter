import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';

import 'src/utils.dart';

void main() {
  late RiveFile riveFile;

  setUp(() {
    final riveBytes = loadFile('assets/rive-flutter-test-asset.riv');
    riveFile = RiveFile.import(riveBytes);
  });

  test('Rive files contain the correct number of artboards', () {
    expect(riveFile.artboards.length, 2);
  });

  test('A default artboard is available in a Rive file', () {
    // Create a dummy RiveFile
    expect(riveFile.mainArtboard, isNotNull);
    expect(riveFile.mainArtboard.name, 'Artboard 1');
  });

  test('Artboards can be retrieved by name', () {
    var artboard = riveFile.artboardByName('Artboard 1');
    expect(artboard, isNotNull);
    expect(artboard!.name, 'Artboard 1');

    artboard = riveFile.artboardByName('Artboard 2');
    expect(artboard, isNotNull);
    expect(artboard!.name, 'Artboard 2');

    artboard = riveFile.artboardByName('Nonexistant');
    expect(artboard, isNull);
  });
}

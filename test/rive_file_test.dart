import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';

void main() {
  late ByteData multipleArtboardsBytes;

  void loadTestAssets() {
    multipleArtboardsBytes = ByteData.sublistView(
        File('assets/multiple_artboards_0_6_2.riv').readAsBytesSync());
  }

  setUp(loadTestAssets);

  test('Rive files load', () {
    // Create a dummy RiveFile
    RiveFile.import(multipleArtboardsBytes);
  });

  test('Rive files contain the correct number of artboards', () {
    // Create a dummy RiveFile
    final riveFile = RiveFile.import(multipleArtboardsBytes);
    expect(riveFile.artboards.length, 4);
  });

  test('A default artboard is available in a Rive file', () {
    // Create a dummy RiveFile
    final riveFile = RiveFile.import(multipleArtboardsBytes);
    expect(riveFile.mainArtboard, isNotNull);
    expect(riveFile.mainArtboard.name, 'Artboard 1');
  });

  test('Artboards can be retrieved by name', () {
    // Create a dummy RiveFile
    final riveFile = RiveFile.import(multipleArtboardsBytes);

    var artboard = riveFile.artboardByName('Artboard 1');
    expect(artboard, isNotNull);
    expect(artboard!.name, 'Artboard 1');

    artboard = riveFile.artboardByName('Artboard 3');
    expect(artboard, isNotNull);
    expect(artboard!.name, 'Artboard 3');

    artboard = riveFile.artboardByName('Nonexistant');
    expect(artboard, isNull);
  });
}

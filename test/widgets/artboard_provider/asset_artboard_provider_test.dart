import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rive/src/widgets/artboard_provider/asset_artboard_provider.dart';

import '../../rive_test_data.dart';

// ignore_for_file: lines_longer_than_80_chars

void main() {
  group("AssetArtboardProvider", () {
    const assetName = RiveTestData.assetName;
    const mainArtboardName = RiveTestData.mainArtboardName;
    const allArtboardNames = RiveTestData.allArtboardNames;
    final assetByteData = RiveTestData.assetByteData;
    final assetBundle = _AssetBundleMock();

    final assetProvider = AssetArtboardProvider(
      assetName: assetName,
      bundle: assetBundle,
    );

    tearDown(() {
      reset(assetBundle);
    });

    test(
      "creates an instance with the rootBundle as the default asset bundle if the given one is null",
      () {
        final assetProvider = AssetArtboardProvider(
          assetName: assetName,
          bundle: null,
        );

        expect(assetProvider.bundle, equals(rootBundle));
      },
    );

    test(
      ".load() uses the given asset bundle to load the animation bytes",
      () async {
        when(
          assetBundle.load(assetName),
        ).thenAnswer((_) => Future.value(assetByteData));

        assetProvider.load();

        verify(assetBundle.load(assetName)).called(1);
      },
    );

    test(
      ".load() loads the main artboard if the given artboard name is null",
      () async {
        when(
          assetBundle.load(assetName),
        ).thenAnswer((_) => Future.value(assetByteData));

        final artboard = await assetProvider.load(artboardName: null);

        expect(artboard.name, equals(mainArtboardName));
      },
    );

    test(
      ".load() loads the artboard with the given name",
      () async {
        for (final artboardName in allArtboardNames) {
          when(
            assetBundle.load(assetName),
          ).thenAnswer((_) => Future.value(assetByteData));

          final artboard = await assetProvider.load(artboardName: artboardName);

          expect(artboard.name, equals(artboardName));
        }
      },
    );
  });
}

class _AssetBundleMock extends Mock implements AssetBundle {}

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rive/rive.dart';

import 'mocks/mocks.dart';
import 'src/network.dart';
import 'src/utils.dart';

const assetName = 'CleanShot 2023-06-08 at 08.51.19@2x.png';

class MockAssetBundle extends Mock implements AssetBundle {}

void main() {
  setUpAll(() {
    registerFallbackValue(ArtboardFake());
    registerFallbackValue(Uri());
    registerFallbackValue(Stream.value(<int>[]));
  });
  group("Test loading rive file with embedded asset.", () {
    test('Default load does not hit any url', () async {
      final mockHttpClient = getMockHttpClient();

      await HttpOverrides.runZoned(() async {
        final riveBytes = loadFile('assets/sample_image.riv');
        RiveFile.import(
          riveBytes,
        );
      }, createHttpClient: (_) => mockHttpClient);

      verifyNever(() => mockHttpClient.openUrl(any(), any()));
    });

    test('Disabling cdn also does not hit a url', () async {
      final mockHttpClient = getMockHttpClient();

      await HttpOverrides.runZoned(() async {
        final riveBytes = loadFile('assets/sample_image.riv');
        runZonedGuarded(() {
          RiveFile.import(
            riveBytes,
            loadCdnAssets: false,
          );
        }, (error, stack) {
          // importing assets throws rn when we do not end up loading assets..
          // could suppress this too..
          // could ignore them & info log our load attempts.

          // could have a future people can await to get any issues
          // could have a future people can await to get logs...
        });
      }, createHttpClient: (_) => mockHttpClient);

      // network disabled
      verifyNever(() => mockHttpClient.openUrl(any(), any()));
      // by default we try to check for assets
    });

    test('test importing rive file, make sure we get a good callback',
        () async {
      // lets just return an image
      final riveBytes = loadFile('assets/sample_image.riv');
      final imageBytes = loadFile('assets/file.png');
      final assets = [];
      final byteList = [];
      RiveFile.import(riveBytes, assetLoader: CallbackAssetLoader(
        (asset, bytes) async {
          assets.add(asset);
          byteList.add(bytes);
          await asset.decode(Uint8List.sublistView(
            imageBytes,
          ));
          return true;
        },
      ));

      final asset = assets.first;

      expect(asset is ImageAsset, true);
      final fileAsset = asset as ImageAsset;
      expect(fileAsset.extension, Extension.png);
      expect(fileAsset.type, Type.image);
      expect(fileAsset.name, assetName);
      expect(fileAsset.assetId, 42981);

      expect(fileAsset.id, -1);

      expect(byteList.first.length, 202385);
    });

    test('test we load embedded assets if loaders are not provided', () async {
      // lets just return an image
      final riveBytes = loadFile('assets/sample_image.riv');

      final assets = [];
      RiveFile.import(riveBytes, assetLoader: CallbackAssetLoader(
        (asset, bytes) async {
          assets.add(asset);
          return false;
        },
      ));

      final asset = assets.first;

      expect(asset is ImageAsset, true);
      final fileAsset = asset as ImageAsset;
      expect(fileAsset.extension, Extension.png);
      expect(fileAsset.type, Type.image);
      expect(fileAsset.name, assetName);
      expect(fileAsset.assetId, 42981);
      // file asset will not be loaded
      expect(fileAsset.image, null);

      expect(fileAsset.id, -1);
      await Future<void>.delayed(const Duration(milliseconds: 100));
      expect(fileAsset.image != null, true);
    });

    test('Make sure the image gets the dimensions once the image is loaded',
        () async {
      // lets just return an image
      final riveBytes = loadFile('assets/sample_image.riv');
      final imageBytes = loadFile('assets/file.png');
      final completer = Completer();

      final file = RiveFile.import(
        riveBytes,
        assetLoader: CallbackAssetLoader(
          (asset, bytes) async {
            await asset.decode(Uint8List.sublistView(
              imageBytes,
            ));
            completer.complete(null);
            return true;
          },
        ),
      );
      final image = file.artboards.first
          .component("CleanShot 2023-06-08 at 08.51.19@2x.png");
      print(image);

      expect(image.width, 2444);
      expect(image.height, 1634);
      await completer.future;
      expect(image.width, 256);
      expect(image.height, 331);
    });
  });
  group("Test loading rive file with cdn asset.", () {
    late MockHttpClient mockHttpClient;
    setUp(() {
      mockHttpClient = getMockHttpClient();
      final imageBytes = loadFile('assets/file.png');
      prepMockRequest(mockHttpClient, Uint8List.sublistView(imageBytes));
    });

    test('Default load will his the cdn', () async {
      await HttpOverrides.runZoned(() async {
        final riveBytes = loadFile('assets/cdn_image.riv');
        RiveFile.import(
          riveBytes,
        );
      }, createHttpClient: (_) => mockHttpClient);

      verify(() => mockHttpClient.openUrl(
            any(),
            // ok, hardcoded for the cdn_image.riv file.
            Uri.parse(
                'https://public.rive.app/cdn/uuid/b86dc1e6-35f7-4490-96fc-89ebdf848473'),
          )).called(1);
    });

    test('Disabling cdn will mean no url hit', () async {
      await HttpOverrides.runZoned(() async {
        final riveBytes = loadFile('assets/cdn_image.riv');

        RiveFile.import(
          riveBytes,
          loadCdnAssets: false,
        );
      }, createHttpClient: (_) => mockHttpClient);

      // network disabled
      verifyNever(() => mockHttpClient.openUrl(any(), any()));
      // by default we try to check for assets
    });
    test(
        'If we provide a callback, we are hit first, and success means '
        'no cdn hit', () async {
      // lets just return an image
      final imageBytes = loadFile('assets/file.png');
      final parameters = [];
      await HttpOverrides.runZoned(() async {
        final riveBytes = loadFile('assets/cdn_image.riv');
        RiveFile.import(riveBytes, assetLoader: CallbackAssetLoader(
          (asset, bytes) async {
            parameters.add(asset);
            await asset.decode(Uint8List.sublistView(
              imageBytes,
            ));
            return true;
          },
        ));
      }, createHttpClient: (_) => mockHttpClient);

      final asset = parameters.first;

      expect(asset is ImageAsset, true);
      verifyNever(() => mockHttpClient.openUrl(any(), any()));
    });

    test(
        'If we provide a callback, we are hit first, a failure means we '
        'hit cdn', () async {
      // lets just return an image
      final parameters = [];
      await HttpOverrides.runZoned(() async {
        final riveBytes = loadFile('assets/cdn_image.riv');

        RiveFile.import(riveBytes, assetLoader: CallbackAssetLoader(
          (asset, bytes) async {
            parameters.add(asset);
            return false;
          },
        ));
      }, createHttpClient: (_) => mockHttpClient);

      final asset = parameters.first;

      expect(asset is ImageAsset, true);
      verify(() => mockHttpClient.openUrl(any(), any())).called(1);
    });

    testWidgets('Loading hosted assets will default to rives public cdn',
        (WidgetTester tester) async {
      await HttpOverrides.runZoned(() async {
        final riveBytes = loadFile('assets/image_asset_prod.riv');
        RiveFile.import(
          riveBytes,
        );
      }, createHttpClient: (_) => mockHttpClient);

      verify(() => mockHttpClient.openUrl(
            any(),
            // ok, hardcoded for the cdn_image.riv file.
            Uri.parse(
                'https://public.rive.app/cdn/uuid/69a03ce3-83f0-4fcb-94a5-0d401b8c030e'),
          )).called(1);
    });

    testWidgets('Loading hosted assets can have custom cdns set',
        (WidgetTester tester) async {
      await HttpOverrides.runZoned(() async {
        final riveBytes = loadFile('assets/image_asset_uat.riv');
        RiveFile.import(
          riveBytes,
        );
      }, createHttpClient: (_) => mockHttpClient);

      verify(() => mockHttpClient.openUrl(
            any(),
            // ok, hardcoded for the cdn_image.riv file.
            Uri.parse(
                'https://public.uat.rive.app/cdn/uuid/69a03ce3-83f0-4fcb-94a5-0d401b8c030e'),
          )).called(1);
    });

    testWidgets('Uses AssetBundle of context instead of rootBundle',
        (WidgetTester tester) async {
      await HttpOverrides.runZoned(() async {
        final assetBundle = MockAssetBundle();
        final riveBytes = loadFile('assets/image_asset_uat.riv');

        when(() => assetBundle.load(any())).thenAnswer((_) async => riveBytes);

        await tester.pumpWidget(
          DefaultAssetBundle(
            bundle: assetBundle,
            child: const RiveAnimation.asset('assets/image_asset_uat.riv'),
          ),
        );

        verify(() => assetBundle.load(any())).called(1);
      }, createHttpClient: (_) => mockHttpClient);
    });
  });
}

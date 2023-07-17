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
    testWidgets('Default load does not hit any url',
        (WidgetTester tester) async {
      final mockHttpClient = getMockHttpClient();

      await HttpOverrides.runZoned(() async {
        final riveBytes = loadFile('assets/sample_image.riv');
        RiveFile.import(
          riveBytes,
        );
      }, createHttpClient: (_) => mockHttpClient);

      verifyNever(() => mockHttpClient.openUrl(any(), any()));
    });

    testWidgets('Disabling embedded assets also does not hit a url',
        (WidgetTester tester) async {
      final mockHttpClient = getMockHttpClient();

      await HttpOverrides.runZoned(() async {
        final riveBytes = loadFile('assets/sample_image.riv');

        RiveFile.import(
          riveBytes,
          loadEmbeddedAssets: false,
        );
      }, createHttpClient: (_) => mockHttpClient);

      // by default we try to make a network request
      verifyNever(() => mockHttpClient.openUrl(any(), any()));
    });

    testWidgets('Disabling cdn also does not hit a url',
        (WidgetTester tester) async {
      final mockHttpClient = getMockHttpClient();

      await HttpOverrides.runZoned(() async {
        final riveBytes = loadFile('assets/sample_image.riv');
        runZonedGuarded(() {
          RiveFile.import(
            riveBytes,
            loadEmbeddedAssets: false,
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
    testWidgets('test importing rive file, make sure we get a good callback',
        (WidgetTester tester) async {
      // lets just return an image
      final riveBytes = loadFile('assets/sample_image.riv');
      final imageBytes = loadFile('assets/file.png');
      final parameters = [];
      RiveFile.import(riveBytes, loadEmbeddedAssets: false,
          assetLoader: CallbackAssetLoader(
        (asset) async {
          parameters.add(asset);
          await asset.decode(Uint8List.sublistView(
            imageBytes,
          ));
          return true;
        },
      ));

      final asset = parameters.first;

      expect(asset is ImageAsset, true);
      final fileAsset = asset as ImageAsset;
      expect(fileAsset.extension, Extension.png);
      expect(fileAsset.type, Type.image);
      expect(fileAsset.name, assetName);
      expect(fileAsset.assetId, 42981);
      expect(fileAsset.id, -1);
    });
  });
  group("Test loading rive file with cdn asset.", () {
    late MockHttpClient mockHttpClient;
    setUp(() {
      mockHttpClient = getMockHttpClient();
      final imageBytes = loadFile('assets/file.png');
      prepMockRequest(mockHttpClient, Uint8List.sublistView(imageBytes));
    });

    testWidgets('Default load will his the cdn', (WidgetTester tester) async {
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

    testWidgets('Disabling embedded assets also hits a url',
        (WidgetTester tester) async {
      await HttpOverrides.runZoned(() async {
        final riveBytes = loadFile('assets/cdn_image.riv');
        runZonedGuarded(() {
          RiveFile.import(
            riveBytes,
            loadEmbeddedAssets: false,
          );
        }, (error, stack) {
          print('what?');
        });
      }, createHttpClient: (_) => mockHttpClient);

      // by default we try to make a network request
      verify(() => mockHttpClient.openUrl(any(), any())).called(1);
    });

    testWidgets('Disabling cdn will mean no url hit',
        (WidgetTester tester) async {
      await HttpOverrides.runZoned(() async {
        final riveBytes = loadFile('assets/cdn_image.riv');

        RiveFile.import(
          riveBytes,
          loadEmbeddedAssets: false,
          loadCdnAssets: false,
        );
      }, createHttpClient: (_) => mockHttpClient);

      // network disabled
      verifyNever(() => mockHttpClient.openUrl(any(), any()));
      // by default we try to check for assets
    });
    testWidgets(
        'If we provide a callback, we are hit first, and success means no cdn hit',
        (WidgetTester tester) async {
      // lets just return an image
      final imageBytes = loadFile('assets/file.png');
      final parameters = [];
      await HttpOverrides.runZoned(() async {
        final riveBytes = loadFile('assets/cdn_image.riv');

        RiveFile.import(riveBytes, loadEmbeddedAssets: false,
            assetLoader: CallbackAssetLoader(
          (asset) async {
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

    testWidgets(
        'If we provide a callback, we are hit first, a failure means we hit cdn',
        (WidgetTester tester) async {
      // lets just return an image
      final parameters = [];
      await HttpOverrides.runZoned(() async {
        final riveBytes = loadFile('assets/cdn_image.riv');

        RiveFile.import(riveBytes, loadEmbeddedAssets: false,
            assetLoader: CallbackAssetLoader(
          (asset) async {
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

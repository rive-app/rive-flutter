import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rive/rive.dart';
import 'package:rive/src/widgets/artboard_provider/artboard_provider.dart';
import 'package:rive/src/widgets/artboard_provider/asset_artboard_provider.dart';

import '../rive_test_data.dart';

// ignore_for_file: lines_longer_than_80_chars

void main() {
  group("RiveAnimation", () {
    final artboardProvider = _ArtboardProviderMock();
    final assetBundle = _AssetBundleMock();
    final artboard = RiveTestData.mainArtboard;
    const assetName = RiveTestData.assetName;
    final assetByteData = RiveTestData.assetByteData;

    const useArtboardSize = true;
    const loadingWidget = Text('loading');
    final animationController = SimpleAnimation('animationName');
    const alignment = Alignment.topLeft;
    const fit = BoxFit.fitHeight;

    Rive _getRive(WidgetTester tester) {
      return tester.firstWidget<Rive>(find.byType(Rive));
    }

    RiveAnimation _getRiveAnimation(WidgetTester tester) {
      return tester.firstWidget<RiveAnimation>(find.byType(RiveAnimation));
    }

    tearDown(() {
      reset(artboardProvider);
      reset(assetBundle);
    });

    testWidgets(
      "displays the SizedBox as the default loading builder",
      (WidgetTester tester) async {
        when(artboardProvider.load()).thenAnswer((_) => artboard);

        await tester.pumpWidget(_MaterialAppTestbed(
          child: RiveAnimation(
            artboardProvider: artboardProvider,
            loadingBuilder: null,
          ),
        ));

        expect(find.byType(SizedBox), findsOneWidget);
      },
    );

    testWidgets(
      "uses the given loading builder when loading the animation",
      (WidgetTester tester) async {
        when(artboardProvider.load()).thenAnswer((_) => artboard);

        await tester.pumpWidget(_MaterialAppTestbed(
          child: RiveAnimation(
            artboardProvider: artboardProvider,
            loadingBuilder: (_) => loadingWidget,
          ),
        ));

        expect(find.byWidget(loadingWidget), findsOneWidget);
      },
    );

    testWidgets(
      "loads the artboard using the given artboard provider",
      (WidgetTester tester) async {
        when(artboardProvider.load()).thenAnswer((_) => artboard);

        await tester.pumpWidget(_MaterialAppTestbed(
          child: RiveAnimation(
            artboardProvider: artboardProvider,
          ),
        ));

        verify(artboardProvider.load()).called(1);
      },
    );

    testWidgets(
      "loads the artboard with the given name using the artboard provider",
      (WidgetTester tester) async {
        const expectedArtboardName = 'name';
        when(
          artboardProvider.load(artboardName: expectedArtboardName),
        ).thenAnswer((_) => artboard);

        await tester.pumpWidget(_MaterialAppTestbed(
          child: RiveAnimation(
            artboardProvider: artboardProvider,
            artboardName: expectedArtboardName,
          ),
        ));

        verify(
          artboardProvider.load(artboardName: expectedArtboardName),
        ).called(1);
      },
    );

    testWidgets(
      "displays the Rive widget with the loaded artboard",
      (WidgetTester tester) async {
        when(artboardProvider.load()).thenAnswer((_) => artboard);

        await tester.pumpWidget(_MaterialAppTestbed(
          child: RiveAnimation(
            artboardProvider: artboardProvider,
          ),
        ));

        await tester.pump();

        final rive = _getRive(tester);

        expect(rive.artboard, equals(artboard));
      },
    );

    testWidgets(
      "displays the Rive widget with the artboard having the given animation controller",
      (WidgetTester tester) async {
        when(artboardProvider.load()).thenAnswer((_) => artboard);

        await tester.pumpWidget(_MaterialAppTestbed(
          child: RiveAnimation(
            artboardProvider: artboardProvider,
            controller: animationController,
          ),
        ));

        await tester.pump();

        final rive = _getRive(tester);
        final riveArtboard = rive.artboard;

        // .addController() returns false if already contains
        // the given controller
        final containsController = !riveArtboard.addController(
          animationController,
        );

        expect(containsController, isTrue);
      },
    );

    testWidgets(
      "displays the Rive widget with the given alignment",
      (WidgetTester tester) async {
        when(artboardProvider.load()).thenAnswer((_) => artboard);

        await tester.pumpWidget(_MaterialAppTestbed(
          child: RiveAnimation(
            artboardProvider: artboardProvider,
            alignment: alignment,
          ),
        ));

        await tester.pump();

        final rive = _getRive(tester);

        expect(rive.alignment, equals(alignment));
      },
    );

    testWidgets(
      "displays the Rive widget with the default Alignment.center if the given alignment is `null`",
      (WidgetTester tester) async {
        when(artboardProvider.load()).thenAnswer((_) => artboard);

        await tester.pumpWidget(_MaterialAppTestbed(
          child: RiveAnimation(
            artboardProvider: artboardProvider,
            alignment: null,
          ),
        ));

        await tester.pump();

        final rive = _getRive(tester);

        expect(rive.alignment, equals(Alignment.center));
      },
    );

    testWidgets(
      "displays the Rive widget with the given fit",
      (WidgetTester tester) async {
        when(artboardProvider.load()).thenAnswer((_) => artboard);

        await tester.pumpWidget(_MaterialAppTestbed(
          child: RiveAnimation(
            artboardProvider: artboardProvider,
            fit: fit,
          ),
        ));

        await tester.pump();

        final rive = _getRive(tester);

        expect(rive.fit, equals(fit));
      },
    );

    testWidgets(
      "displays the Rive widget with the default BoxFit.contain if the given fit is null",
      (WidgetTester tester) async {
        when(artboardProvider.load()).thenAnswer((_) => artboard);

        await tester.pumpWidget(_MaterialAppTestbed(
          child: RiveAnimation(
            artboardProvider: artboardProvider,
            fit: null,
          ),
        ));

        await tester.pump();

        final rive = _getRive(tester);

        expect(rive.fit, equals(BoxFit.contain));
      },
    );

    testWidgets(
      "displays the Rive widget that applies the given use artboard size parameter",
      (WidgetTester tester) async {
        when(artboardProvider.load()).thenAnswer((_) => artboard);

        await tester.pumpWidget(_MaterialAppTestbed(
          child: RiveAnimation(
            artboardProvider: artboardProvider,
            useArtboardSize: useArtboardSize,
          ),
        ));

        await tester.pump();

        final rive = _getRive(tester);

        expect(rive.useArtboardSize, equals(useArtboardSize));
      },
    );

    testWidgets(
      "displays the Rive widget with the default false use artboard size parameter if the given use artboard size parameter is null",
      (WidgetTester tester) async {
        when(artboardProvider.load()).thenAnswer((_) => artboard);

        await tester.pumpWidget(_MaterialAppTestbed(
          child: RiveAnimation(
            artboardProvider: artboardProvider,
            useArtboardSize: null,
          ),
        ));

        await tester.pump();

        final rive = _getRive(tester);

        expect(rive.useArtboardSize, isFalse);
      },
    );

    testWidgets(
      ".asset() uses the AssetArtboardProvider as the artboard provider",
      (WidgetTester tester) async {
        when(
          assetBundle.load(assetName),
        ).thenAnswer((_) => Future.value(assetByteData));

        await tester.pumpWidget(_MaterialAppTestbed(
          child: RiveAnimation.asset(
            assetName,
            bundle: assetBundle,
          ),
        ));

        final riveAnimation = _getRiveAnimation(tester);

        expect(riveAnimation.artboardProvider, isA<AssetArtboardProvider>());
      },
    );

    testWidgets(
      ".asset() uses the AssetArtboardProvider with the given asset name and bundle",
      (WidgetTester tester) async {
        when(
          assetBundle.load(assetName),
        ).thenAnswer((_) => Future.value(assetByteData));

        await tester.pumpWidget(_MaterialAppTestbed(
          child: RiveAnimation.asset(
            assetName,
            bundle: assetBundle,
          ),
        ));

        final riveAnimation = _getRiveAnimation(tester);
        final artboardProvider =
            riveAnimation.artboardProvider as AssetArtboardProvider;

        expect(artboardProvider.assetName, equals(assetName));
        expect(artboardProvider.bundle, equals(assetBundle));
      },
    );

    testWidgets(
      ".asset() uses the AssetArtboardProvider with the rootBundle as asset bundle if the given asset bundle is null",
      (WidgetTester tester) async {
        await tester.runAsync(() async {
          ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
            'flutter/assets',
            (_) => Future.value(assetByteData),
          );
        });

        await tester.pumpWidget(DefaultAssetBundle(
          bundle: assetBundle,
          child: _MaterialAppTestbed(
            child: RiveAnimation.asset(
              assetName,
              bundle: null,
            ),
          ),
        ));

        final riveAnimation = _getRiveAnimation(tester);
        final artboardProvider =
            riveAnimation.artboardProvider as AssetArtboardProvider;

        expect(artboardProvider.bundle, equals(rootBundle));
      },
    );

    testWidgets(
      ".asset() loads the animation asset from the given asset bundle",
      (WidgetTester tester) async {
        when(
          assetBundle.load(assetName),
        ).thenAnswer((_) => Future.value(assetByteData));

        await tester.pumpWidget(DefaultAssetBundle(
          bundle: assetBundle,
          child: _MaterialAppTestbed(
            child: RiveAnimation.asset(
              assetName,
              bundle: assetBundle,
            ),
          ),
        ));

        verify(assetBundle.load(assetName)).called(1);
      },
    );

    testWidgets(
      ".asset() displays the SizedBox as the default loading builder",
      (WidgetTester tester) async {
        when(
          assetBundle.load(assetName),
        ).thenAnswer((_) => Future.value(assetByteData));

        await tester.pumpWidget(_MaterialAppTestbed(
          child: RiveAnimation.asset(
            assetName,
            bundle: assetBundle,
          ),
        ));

        expect(find.byType(SizedBox), findsOneWidget);
      },
    );

    testWidgets(
      ".asset() uses the given loading builder when loading the animation",
      (WidgetTester tester) async {
        when(
          assetBundle.load(assetName),
        ).thenAnswer((_) => Future.value(assetByteData));

        await tester.pumpWidget(_MaterialAppTestbed(
          child: RiveAnimation.asset(
            assetName,
            bundle: assetBundle,
            loadingBuilder: (_) => loadingWidget,
          ),
        ));

        expect(find.byWidget(loadingWidget), findsOneWidget);
      },
    );

    testWidgets(
      "displays the Rive widget with the artboard having the given animation controller",
      (WidgetTester tester) async {
        when(
          assetBundle.load(assetName),
        ).thenAnswer((_) => Future.value(assetByteData));

        await tester.pumpWidget(_MaterialAppTestbed(
          child: RiveAnimation.asset(
            assetName,
            bundle: assetBundle,
            controller: animationController,
          ),
        ));

        await tester.pump();

        final rive = _getRive(tester);
        final riveArtboard = rive.artboard;

        // .addController() returns false if already contains
        // the given controller
        final containsController = !riveArtboard.addController(
          animationController,
        );

        expect(containsController, isTrue);
      },
    );

    testWidgets(
      ".asset() displays the Rive widget with the given alignment",
      (WidgetTester tester) async {
        when(
          assetBundle.load(assetName),
        ).thenAnswer((_) => Future.value(assetByteData));

        await tester.pumpWidget(_MaterialAppTestbed(
          child: RiveAnimation.asset(
            assetName,
            bundle: assetBundle,
            alignment: alignment,
          ),
        ));

        await tester.pump();

        final rive = _getRive(tester);

        expect(rive.alignment, equals(alignment));
      },
    );

    testWidgets(
      ".asset() displays the Rive widget with the default Alignment.center if the given alignment is null",
      (WidgetTester tester) async {
        when(
          assetBundle.load(assetName),
        ).thenAnswer((_) => Future.value(assetByteData));

        await tester.pumpWidget(_MaterialAppTestbed(
          child: RiveAnimation.asset(
            assetName,
            bundle: assetBundle,
            alignment: null,
          ),
        ));

        await tester.pump();

        final rive = _getRive(tester);

        expect(rive.alignment, equals(Alignment.center));
      },
    );

    testWidgets(
      ".asset() displays the Rive widget with the given fit",
      (WidgetTester tester) async {
        when(
          assetBundle.load(assetName),
        ).thenAnswer((_) => Future.value(assetByteData));

        await tester.pumpWidget(_MaterialAppTestbed(
          child: RiveAnimation.asset(
            assetName,
            bundle: assetBundle,
            fit: fit,
          ),
        ));

        await tester.pump();

        final rive = _getRive(tester);

        expect(rive.fit, equals(fit));
      },
    );

    testWidgets(
      ".asset() displays the Rive widget with the default BoxFit.contain if the given fit is null",
      (WidgetTester tester) async {
        when(
          assetBundle.load(assetName),
        ).thenAnswer((_) => Future.value(assetByteData));

        await tester.pumpWidget(_MaterialAppTestbed(
          child: RiveAnimation.asset(
            assetName,
            bundle: assetBundle,
            fit: null,
          ),
        ));

        await tester.pump();

        final rive = _getRive(tester);

        expect(rive.fit, equals(BoxFit.contain));
      },
    );

    testWidgets(
      ".asset() displays the Rive that applies the given use artboard size parameter",
      (WidgetTester tester) async {
        when(
          assetBundle.load(assetName),
        ).thenAnswer((_) => Future.value(assetByteData));

        await tester.pumpWidget(_MaterialAppTestbed(
          child: RiveAnimation.asset(
            assetName,
            bundle: assetBundle,
            useArtboardSize: useArtboardSize,
          ),
        ));

        await tester.pump();

        final rive = _getRive(tester);

        expect(rive.useArtboardSize, equals(useArtboardSize));
      },
    );

    testWidgets(
      ".asset() displays the Rive with the default false use artboard size parameter if the given use artboard size parameter is null",
      (WidgetTester tester) async {
        when(
          assetBundle.load(assetName),
        ).thenAnswer((_) => Future.value(assetByteData));

        await tester.pumpWidget(_MaterialAppTestbed(
          child: RiveAnimation.asset(
            assetName,
            bundle: assetBundle,
            useArtboardSize: null,
          ),
        ));

        await tester.pump();

        final rive = _getRive(tester);

        expect(rive.useArtboardSize, isFalse);
      },
    );
  });
}

/// A testbed class needed to test the [RiveAnimation] widget.
class _MaterialAppTestbed extends StatelessWidget {
  /// A child of this testbed to display;
  final Widget child;

  /// Creates a new instance of this testbed with the given [child].
  const _MaterialAppTestbed({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }
}

class _ArtboardProviderMock extends Mock implements ArtboardProvider {}

class _AssetBundleMock extends Mock implements AssetBundle {}

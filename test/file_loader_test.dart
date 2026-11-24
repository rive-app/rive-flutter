import 'dart:async';
import 'dart:io' as io;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';

const _assetKey = 'test.riv';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  void setAssetHandler(Future<ByteData?>? Function(ByteData?)? handler) =>
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', handler);

  tearDown(() => setAssetHandler(null));

  group('disposed mid-load', () {
    late Uint8List bytes;
    late Completer<void> gate;

    setUpAll(() => bytes =
        io.File('test/assets/rive_file_controller_test.riv').readAsBytesSync());

    setUp(() {
      // Serve the asset only once the test opens the gate, so the loader can
      // be disposed while File.asset is still in flight.
      gate = Completer<void>();
      setAssetHandler((message) async {
        await gate.future;
        return ByteData.sublistView(bytes);
      });
    });

    final disposedMidLoad = isA<RiveFileLoaderException>()
        .having((e) => e.message, 'message', contains('disposed'));

    test('file() fails with RiveFileLoaderException', () async {
      final loader =
          FileLoader.fromAsset(_assetKey, riveFactory: Factory.flutter);
      final load = loader.file();
      final waiter = loader.file();

      loader.dispose();
      gate.complete();

      await Future.wait([
        expectLater(load, throwsA(disposedMidLoad)),
        expectLater(waiter, throwsA(disposedMidLoad)),
      ]);
      expect(loader.fileSync, isNull);
    });

    test('file() after dispose() loads the file again', () async {
      gate.complete();
      final loader =
          FileLoader.fromAsset(_assetKey, riveFactory: Factory.flutter);
      final first = await loader.file();
      loader.dispose();
      expect(loader.fileSync, isNull);

      final second = await loader.file();
      expect(second, isNot(same(first)));
      expect(loader.fileSync, same(second));
      loader.dispose();
    });

    test('file() after a mid-load dispose() gets its own file', () async {
      final loader =
          FileLoader.fromAsset(_assetKey, riveFactory: Factory.flutter);
      final overtaken = loader.file();
      loader.dispose();
      final reload = loader.file();
      gate.complete();

      await expectLater(overtaken, throwsA(disposedMidLoad));
      final reloaded = await reload;
      expect(loader.fileSync, same(reloaded));
      loader.dispose();
    });

    testWidgets('an unmounted RiveWidgetBuilder reports no error',
        (tester) async {
      final loader = _ObservedFileLoader();
      // Real async throughout: File.decode does not complete under fake time.
      await tester.runAsync(() async {
        await tester.pumpWidget(RiveWidgetBuilder(
          fileLoader: loader,
          builder: (context, state) => const SizedBox.shrink(),
        ));
        expect(loader.load, isNotNull);

        // Navigate away, then the owner disposes the loader.
        await tester.pumpWidget(const SizedBox.shrink());
        loader.dispose();

        gate.complete();
        await loader.load!.then<void>((_) {}, onError: (_) {});
      });
      await tester.pump();
    });
  });

  testWidgets('RiveWidgetBuilder reports a failed load once, via onFailed',
      (tester) async {
    setAssetHandler((message) async => null);
    final loader = _ObservedFileLoader();
    final errors = <Object>[];
    await tester.runAsync(() async {
      await tester.pumpWidget(RiveWidgetBuilder(
        fileLoader: loader,
        builder: (context, state) => const SizedBox.shrink(),
        onFailed: (error, stackTrace) => errors.add(error),
      ));
      await loader.load!.then<void>((_) {}, onError: (_) {});
    });
    await tester.pump();

    expect(errors, [isA<RiveFileLoaderException>()]);
  });
}

class _ObservedFileLoader extends FileLoader {
  _ObservedFileLoader()
      : super.fromAsset(_assetKey, riveFactory: Factory.flutter);

  Future<File>? load;

  @override
  Future<File> file() => load = super.file();
}

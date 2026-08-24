import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';

import 'src/utils.dart';

/// The fixture `global_view_models_test.riv` has a main view model named
/// "Main" and global view models named (in file order) "Sizes", "Colors",
/// "Labels".
void main() {
  late File riveFile;
  late FileLoader fileLoader;

  setUp(() async {
    riveFile = await decodeRiveFixture(
      'test/assets/global_view_models_test.riv',
    );
    fileLoader = FileLoader.fromFile(riveFile, riveFactory: Factory.flutter);
  });

  tearDown(() {
    fileLoader.dispose();
  });

  Widget builderWidget(
    FileLoader loader,
    void Function(RiveLoaded) onLoaded, {
    Controller? controller,
    RiveOnFailed? onFailed,
  }) {
    return MaterialApp(
      home: RiveWidgetBuilder(
        fileLoader: loader,
        controller: controller,
        onLoaded: onLoaded,
        onFailed: onFailed,
        builder: (context, state) => const SizedBox.shrink(),
      ),
    );
  }

  testWidgets(
    'does not dispose a user-provided view model instance on unmount',
    (tester) async {
      final vmi = makeDefaultInstance(riveFile, 'Main');

      RiveLoaded? loaded;
      await tester.pumpWidget(
        builderWidget(
          fileLoader,
          (state) => loaded = state,
          controller: (file) =>
              RiveWidgetController(file, main: DataBind.byInstance(vmi)),
        ),
      );
      await tester.pumpAndSettle();

      expect(loaded, isNotNull);
      // The bound instance is the exact object the user passed.
      expect(identical(loaded!.controller.viewModelInstance, vmi), isTrue);

      // Unmount the widget.
      await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));

      // The user's instance survives the widget: they own it and may be using
      // it elsewhere.
      expect(vmi.isDisposed, isFalse);

      vmi.dispose();
    },
  );

  testWidgets('reconfiguring disposes the previous widget-created instance', (
    tester,
  ) async {
    final userVmi = makeDefaultInstance(riveFile, 'Main');

    RiveLoaded? loaded;
    await tester.pumpWidget(
      builderWidget(fileLoader, (state) => loaded = state),
    );
    await tester.pumpAndSettle();
    final firstVmi = loaded!.controller.viewModelInstance!;

    // Reconfigure (new file loader) to a controller pinning a caller-owned
    // instance: the replaced controller is disposed, releasing the instance
    // it auto-bound for the previous configuration. (Decode via runAsync:
    // real async work deadlocks the fake-async test zone.)
    final secondFile = (await tester.runAsync(
      () => decodeRiveFixture('test/assets/global_view_models_test.riv'),
    ))!;
    final secondLoader = FileLoader.fromFile(
      secondFile,
      riveFactory: Factory.flutter,
    );
    addTearDown(secondLoader.dispose);

    await tester.pumpWidget(
      builderWidget(
        secondLoader,
        (state) => loaded = state,
        controller: (file) =>
            RiveWidgetController(file, main: DataBind.byInstance(userVmi)),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      firstVmi.isDisposed,
      isTrue,
      reason: 'the replaced controller owned the auto-created instance',
    );
    expect(identical(loaded!.controller.viewModelInstance, userVmi), isTrue);
    expect(userVmi.isDisposed, isFalse);

    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
    expect(userVmi.isDisposed, isFalse);

    userVmi.dispose();
  });

  testWidgets('disposes a view model instance it created on unmount', (
    tester,
  ) async {
    RiveLoaded? loaded;
    await tester.pumpWidget(
      builderWidget(fileLoader, (state) => loaded = state),
    );
    await tester.pumpAndSettle();

    expect(loaded, isNotNull);
    final vmi = loaded!.controller.viewModelInstance;
    expect(vmi, isNotNull);
    expect(vmi!.isDisposed, isFalse);

    // Unmount the widget.
    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));

    // The controller resolved this instance, so disposing the controller
    // (at unmount) disposes it.
    expect(vmi.isDisposed, isTrue);
  });

  testWidgets('a failing reconfigure disposes the previous controller', (
    tester,
  ) async {
    RiveLoaded? loaded;
    await tester.pumpWidget(
      builderWidget(fileLoader, (state) => loaded = state),
    );
    await tester.pumpAndSettle();
    final firstVmi = loaded!.controller.viewModelInstance!;

    final secondFile = (await tester.runAsync(
      () => decodeRiveFixture('test/assets/global_view_models_test.riv'),
    ))!;
    final secondLoader = FileLoader.fromFile(
      secondFile,
      riveFactory: Factory.flutter,
    );
    addTearDown(secondLoader.dispose);

    Object? failure;
    await tester.pumpWidget(
      builderWidget(
        secondLoader,
        (state) => loaded = state,
        controller: (file) => throw Exception('controller builder failed'),
        onFailed: (error, stackTrace) => failure = error,
      ),
    );
    await tester.pumpAndSettle();

    expect(failure, isNotNull);
    expect(
      firstVmi.isDisposed,
      isTrue,
      reason: 'the failed reconfigure hides the previous controller, so the '
          'widget must dispose it',
    );
  });

  testWidgets('a throwing onLoaded does not leak the controller', (
    tester,
  ) async {
    ViewModelInstance? vmi;
    Object? failure;
    await tester.pumpWidget(
      builderWidget(
        fileLoader,
        (state) {
          vmi = state.controller.viewModelInstance;
          throw Exception('onLoaded failed');
        },
        onFailed: (error, stackTrace) => failure = error,
      ),
    );
    await tester.pumpAndSettle();

    expect(failure, isNotNull);
    expect(
      vmi!.isDisposed,
      isTrue,
      reason: 'the failure hides the just-loaded controller, so the widget '
          'must dispose it',
    );
  });
}

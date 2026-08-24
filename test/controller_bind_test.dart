import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';

import 'src/utils.dart';

/// The fixture `global_view_models_test.riv` has a main view model named
/// "Main" and global view models named (in file order) "Sizes", "Colors",
/// "Labels".
void main() {
  late File riveFile;
  late RiveWidgetController controller;

  setUpAll(() async {
    riveFile = await decodeRiveFixture(
      'test/assets/global_view_models_test.riv',
    );
  });

  /// A controller past its first advance: the tests below rebind
  /// deliberately, and a rebind before the first advance triggers the debug
  /// early-rebind warning.
  RiveWidgetController advancedController() =>
      RiveWidgetController(riveFile)..advance(0.016);

  setUp(() {
    controller = advancedController();
  });

  tearDown(() {
    controller.dispose();
  });

  test('binds main and globals in one call', () {
    final colors = makeDefaultInstance(riveFile, 'Colors');

    controller.bind(
      main: DataBind.auto(),
      globals: {'Colors': DataBind.byInstance(colors)},
    );

    expect(controller.viewModelInstance, isNotNull);
    // A user-passed instance comes back as the exact same object.
    expect(
      identical(controller.globalViewModelInstance('Colors'), colors),
      isTrue,
    );

    colors.dispose();
  });

  test('construction binds defaults for main and every global', () {
    // No bind() call anywhere: the constructor already bound.
    expect(controller.viewModelInstance, isNotNull);
    for (final name in riveFile.globalViewModelNames) {
      final instance = controller.globalViewModelInstance(name);
      expect(instance, isNotNull, reason: 'global $name not auto-created');
      // Reads are stable: the same object every time.
      expect(
        identical(controller.globalViewModelInstance(name), instance),
        isTrue,
      );
    }
  });

  test(
    'constructor main and globals config is applied in the initial bind',
    () {
      final colors = makeDefaultInstance(riveFile, 'Colors');
      final localController = RiveWidgetController(
        riveFile,
        main: DataBind.auto(),
        globals: {'Colors': DataBind.byInstance(colors)},
      );

      expect(localController.viewModelInstance, isNotNull);
      expect(
        identical(localController.globalViewModelInstance('Colors'), colors),
        isTrue,
      );
      // Unconfigured slots still received defaults.
      expect(localController.globalViewModelInstance('Sizes'), isNotNull);

      // Constructor byInstance pins are caller-owned like bind()'s.
      localController.dispose();
      expect(colors.isDisposed, isFalse);
      colors.dispose();
    },
  );

  test('constructor with an unknown global name throws', () {
    expect(
      () => RiveWidgetController(
        riveFile,
        globals: {'DoesNotExist': DataBind.auto()},
      ),
      throwsA(isA<RiveDataBindException>()),
    );
  });

  test('constructor failure cleanup never touches caller-owned instances', () {
    final colors = makeDefaultInstance(riveFile, 'Colors');

    // 'Colors' resolves first (the user's instance), then 'Sizes' fails to
    // resolve: the constructor disposes what it created and rethrows.
    expect(
      () => RiveWidgetController(
        riveFile,
        globals: {
          'Colors': DataBind.byInstance(colors),
          'Sizes': DataBind.byName('does-not-exist'),
        },
      ),
      throwsA(isA<RiveDataBindException>()),
    );
    expect(colors.isDisposed, isFalse);

    // A disposed byInstance is rejected at construction too.
    colors.dispose();
    expect(
      () => RiveWidgetController(riveFile, main: DataBind.byInstance(colors)),
      throwsA(isA<RiveDataBindException>()),
    );
  });

  test(
    'construction is a harmless no-op bind on content without data binding',
    () async {
      final plainFile = await decodeRiveFixture(
        'test/assets/electrified_button_simple.riv',
      );
      expect(plainFile.globalViewModelNames, isEmpty);

      // The constructor always binds; with no view models anywhere there is
      // nothing to complete, so nothing is created or bound.
      final plainController = RiveWidgetController(plainFile);
      expect(plainController.viewModelInstance, isNull);

      plainController.dispose();
      plainFile.dispose();
    },
  );

  test('auto on a rebind resets an occupied slot to a fresh default', () {
    final autoColors = controller.globalViewModelInstance('Colors');
    expect(autoColors, isNotNull);

    controller.bind(globals: {'Colors': DataBind.auto()});

    // A fresh default replaced the previous occupant.
    final resetColors = controller.globalViewModelInstance('Colors');
    expect(resetColors, isNotNull);
    expect(identical(resetColors, autoColors), isFalse);
  });

  test('subsequent calls are deltas: untouched slots keep their instances', () {
    final autoColors = controller.globalViewModelInstance('Colors');
    expect(autoColors, isNotNull);

    final sizes = makeDefaultInstance(riveFile, 'Sizes');
    controller.bind(globals: {'Sizes': DataBind.byInstance(sizes)});

    expect(
      identical(controller.globalViewModelInstance('Colors'), autoColors),
      isTrue,
    );
    expect(
      identical(controller.globalViewModelInstance('Sizes'), sizes),
      isTrue,
    );

    sizes.dispose();
  });

  test('per-slot DataBind variants resolve against the slot view model', () {
    controller.bind(globals: {'Colors': DataBind.byIndex(0)});

    final colors = controller.globalViewModelInstance('Colors');
    expect(colors, isNotNull);
  });

  test('unknown global name throws and stages nothing', () {
    final colors = makeDefaultInstance(riveFile, 'Colors');
    final before = controller.globalViewModelInstance('Colors');

    expect(
      () => controller.bind(
        globals: {
          'Colors': DataBind.byInstance(colors),
          'DoesNotExist': DataBind.auto(),
        },
      ),
      throwsA(isA<RiveDataBindException>()),
    );

    // Atomic: the valid slot was not staged either - it still holds the
    // instance bound at construction.
    expect(
      identical(controller.globalViewModelInstance('Colors'), before),
      isTrue,
    );

    colors.dispose();
  });

  test('a non-global view model name is rejected', () {
    expect(
      () => controller.bind(globals: {'Main': DataBind.auto()}),
      throwsA(isA<RiveDataBindException>()),
    );
  });

  // Duplicate slots are impossible by construction: the main is a single
  // named parameter and the globals are a map keyed by name.

  List<String> captureDebugPrints(void Function() body) {
    final messages = <String>[];
    final original = debugPrint;
    debugPrint = (String? message, {int? wrapWidth}) {
      if (message != null) messages.add(message);
    };
    try {
      body();
    } finally {
      debugPrint = original;
    }
    return messages;
  }

  test('warns once when bind runs before the first advance', () {
    final localController = RiveWidgetController(riveFile);
    final warnings = captureDebugPrints(() {
      localController.bind();
      localController.bind();
    });
    expect(warnings, hasLength(1));
    expect(warnings.single, contains('constructor'));
    localController.dispose();
  });

  test('does not warn when bind follows an advance', () {
    final localController = advancedController();
    final warnings = captureDebugPrints(localController.bind);
    expect(warnings, isEmpty);
    localController.dispose();
  });

  test('a read-back instance cannot be bound again', () {
    final localController = advancedController();

    final readBack = localController.globalViewModelInstance('Colors')!;

    // Read-backs are plain ViewModelInstance, so byInstance is a compile
    // error, and the runtime constructs views from a class that does not
    // implement BindableViewModelInstance - even the cast throws.
    expect(readBack, isNot(isA<BindableViewModelInstance>()));
    expect(
      () => readBack as BindableViewModelInstance,
      throwsA(isA<TypeError>()),
    );
    // The slot it came from is untouched.
    expect(
      identical(localController.globalViewModelInstance('Colors'), readBack),
      isTrue,
    );

    localController.dispose();
  });

  test('same-call cross-slot sharing of a user instance never disposes it', () {
    final localController = advancedController();
    final mine = makeDefaultInstance(riveFile, 'Colors');

    // One call binds the same user instance into two slots.
    localController.bind(
      globals: {
        'Colors': DataBind.byInstance(mine),
        'Labels': DataBind.byInstance(mine),
      },
    );

    expect(mine.isDisposed, isFalse);
    expect(
      identical(localController.globalViewModelInstance('Colors'), mine),
      isTrue,
    );
    expect(
      identical(localController.globalViewModelInstance('Labels'), mine),
      isTrue,
    );

    // Replacing one slot leaves the shared instance alive in the other.
    localController.bind(globals: {'Colors': DataBind.auto()});
    expect(mine.isDisposed, isFalse);
    expect(
      identical(localController.globalViewModelInstance('Labels'), mine),
      isTrue,
    );

    localController.dispose();
    expect(
      mine.isDisposed,
      isFalse,
      reason: 'user-created instances are never disposed by the controller',
    );
    mine.dispose();
  });

  test('staging a disposed byInstance instance throws', () {
    final disposed = makeDefaultInstance(riveFile, 'Colors');
    disposed.dispose();

    expect(
      () => controller.bind(globals: {'Colors': DataBind.byInstance(disposed)}),
      throwsA(isA<RiveDataBindException>()),
    );
    expect(
      () => controller.bind(main: DataBind.byInstance(disposed)),
      throwsA(isA<RiveDataBindException>()),
    );
  });

  test('sharing across controllers requires a user-created instance', () {
    final controllerA = RiveWidgetController(riveFile);

    // A read-back from A cannot be pinned into another controller: it is a
    // view, and even the cast to the bindable type throws.
    expect(
      () =>
          controllerA.globalViewModelInstance('Colors')!
              as BindableViewModelInstance,
      throwsA(isA<TypeError>()),
    );

    // The blessed pattern: create the instance yourself and pin it into
    // both controllers - it outlives each of them.
    final shared = makeDefaultInstance(riveFile, 'Colors');
    controllerA.advance(0.016);
    controllerA.bind(globals: {'Colors': DataBind.byInstance(shared)});
    final controllerB = RiveWidgetController(
      riveFile,
      globals: {'Colors': DataBind.byInstance(shared)},
    );

    controllerA.dispose();
    expect(shared.isDisposed, isFalse);
    expect(
      identical(controllerB.globalViewModelInstance('Colors'), shared),
      isTrue,
    );

    controllerB.dispose();
    expect(
      shared.isDisposed,
      isFalse,
      reason: 'user-created instances outlive every controller',
    );
    shared.dispose();
  });

  test('controller dispose releases resolved instances, never user-passed', () {
    final localController = advancedController();
    final sizes = makeDefaultInstance(riveFile, 'Sizes');

    localController.bind(
      main: DataBind.auto(),
      globals: {'Sizes': DataBind.byInstance(sizes), 'Colors': DataBind.auto()},
    );

    final resolvedMain = localController.viewModelInstance!;
    final resolvedColors = localController.globalViewModelInstance('Colors')!;

    localController.dispose();

    expect(resolvedMain.isDisposed, isTrue);
    expect(resolvedColors.isDisposed, isTrue);
    expect(sizes.isDisposed, isFalse);

    sizes.dispose();
  });
}

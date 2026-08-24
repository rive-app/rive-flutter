import 'package:flutter_test/flutter_test.dart';
import 'package:rive/legacy.dart';
import 'package:rive/rive.dart';

import 'src/utils.dart';

/// Locks the opt-in `package:rive/legacy.dart` shims to the removed
/// members' contracts.
void main() {
  late File riveFile;
  late RiveWidgetController controller;

  setUpAll(() async {
    riveFile = await decodeRiveFixture(
      'test/assets/global_view_models_test.riv',
    );
  });

  setUp(() {
    controller = RiveWidgetController(riveFile)..advance(0.016);
  });

  tearDown(() {
    controller.dispose();
  });

  test('legacy dataBind binds and returns a caller-owned instance', () {
    final local = RiveWidgetController(riveFile)..advance(0.016);
    final vmi = local.dataBind(DataBind.auto());

    // Bound: the controller's read-back is the exact staged object.
    expect(identical(local.viewModelInstance, vmi), isTrue);

    // Caller-owned, exactly the removed method's contract: the controller
    // never disposes it, the caller does.
    local.dispose();
    expect(vmi.isDisposed, isFalse);
    vmi.dispose();
  });

  test('legacy dataBind empty binds a blank caller-owned instance', () {
    final local = RiveWidgetController(riveFile)..advance(0.016);
    final vmi = local.dataBind(DataBind.empty());
    expect(identical(local.viewModelInstance, vmi), isTrue);
    local.dispose();
    vmi.dispose();
  });

  test('legacy dataBind rejects a disposed byInstance instance', () {
    final disposed = makeDefaultInstance(riveFile, 'Main');
    disposed.dispose();
    expect(
      () => controller.dataBind(DataBind.byInstance(disposed)),
      throwsA(isA<RiveDataBindException>()),
    );
  });

  test('legacy RiveLoaded.viewModelInstance forwards to the controller', () {
    final loaded = RiveLoaded(file: riveFile, controller: controller);
    expect(
      identical(loaded.viewModelInstance, controller.viewModelInstance),
      isTrue,
    );
  });
}

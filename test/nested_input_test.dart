import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';

import 'src/utils.dart';

void main() {
  late RiveFile riveFile;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    final riveBytes = loadFile('assets/runtime_nested_inputs.riv');
    riveFile = RiveFile.import(riveBytes);
  });

  test('Nested boolean input can be get/set', () async {
    final artboard = riveFile.artboards.first.instance();
    expect(artboard, isNotNull);
    final artboardInstance = artboard.instance();
    expect(artboardInstance, isNotNull);
    final bool = artboard.getBoolInput("CircleOuterState", "CircleOuter");
    expect(bool, isNotNull);
    expect(bool!.value, false);
    bool.value = true;
    expect(bool.value, true);
  });

  test('Nested number input can be get/set', () async {
    final artboard = riveFile.artboards.first.instance();
    expect(artboard, isNotNull);
    final artboardInstance = artboard.instance();
    expect(artboardInstance, isNotNull);
    final num = artboard.getNumberInput("CircleOuterNumber", "CircleOuter");
    expect(num, isNotNull);
    expect(num!.value, 0);
    num.value = 99;
    expect(num.value, 99);
  });

  test('Nested trigger can be get/fired', () async {
    final artboard = riveFile.artboards.first.instance();
    expect(artboard, isNotNull);
    final artboardInstance = artboard.instance();
    expect(artboardInstance, isNotNull);
    final trigger =
        artboard.getTriggerInput("CircleOuterTrigger", "CircleOuter");
    expect(trigger, isNotNull);
    trigger!.fire();
  });

  test('Nested boolean input can be get/set multiple levels deep', () async {
    final artboard = riveFile.artboards.first.instance();
    expect(artboard, isNotNull);
    final artboardInstance = artboard.instance();
    expect(artboardInstance, isNotNull);
    final bool =
        artboard.getBoolInput("CircleInnerState", "CircleOuter/CircleInner");
    expect(bool, isNotNull);
    expect(bool!.value, false);
    bool.value = true;
    expect(bool.value, true);
  });
}

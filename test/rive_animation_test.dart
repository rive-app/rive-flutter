import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rive/rive.dart';

import 'mocks/mocks.dart';
import 'src/utils.dart';

const _changeAnimationButtonKey = Key('btnChangeAnimation');
const _changeStateMachineButtonKey = Key('btnChangeStateMachine');
const _changeControllerButtonKey = Key('btnChangeController');
const _updateWidgetPropertiesButtonKey = Key('btnUpdateWidgetProperties');

const _placeHolderWidgetOne = Text('placeholder one');
const _placeHolderWidgetTwo = Text('placeholder two');

class TestApp extends StatefulWidget {
  final RiveFile file;
  const TestApp(
    this.file, {
    this.onInit,
    Key? key,
  }) : super(key: key);

  final OnInitCallback? onInit;

  @override
  _TestAppState createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  int _counter = 0;

  final animations = ["one", "two"];
  final stateMachines = ["one", "two"];
  final controllers = [SimpleAnimation('one'), SimpleAnimation('two')];

  late String animation = animations.first;
  late String stateMachine = stateMachines.first;
  late SimpleAnimation controller = controllers.first;

  BoxFit fit = BoxFit.contain;
  Alignment alignment = Alignment.topCenter;
  bool anitaliasing = true;
  Widget placeholder = _placeHolderWidgetOne;

  void _changeAnimation() {
    setState(() {
      _counter += 1;
      animation = animations[_counter % animations.length];
    });
  }

  void _changeStateMachine() {
    setState(() {
      _counter += 1;
      stateMachine = stateMachines[_counter % stateMachines.length];
    });
  }

  void _changeController() {
    setState(() {
      _counter += 1;
      controller = controllers[_counter % stateMachines.length];
    });
  }

  void _updateWidgetProperties() {
    setState(() {
      fit = BoxFit.fitHeight;
      alignment = Alignment.bottomCenter;
      anitaliasing = false;
      placeholder = _placeHolderWidgetTwo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: RiveAnimation.direct(
                widget.file,
                animations: [animation],
                stateMachines: [stateMachine],
                controllers: [controller],
                fit: fit,
                alignment: alignment,
                antialiasing: anitaliasing,
                placeHolder: placeholder,
                onInit: widget.onInit,
              ),
            ),
            ElevatedButton(
              key: _changeAnimationButtonKey,
              onPressed: _changeAnimation,
              child: const Text('Change Animation'),
            ),
            ElevatedButton(
              key: _changeStateMachineButtonKey,
              onPressed: _changeStateMachine,
              child: const Text('Change State Machine'),
            ),
            ElevatedButton(
              key: _changeControllerButtonKey,
              onPressed: _changeController,
              child: const Text('Change Controller'),
            ),
            ElevatedButton(
              key: _updateWidgetPropertiesButtonKey,
              onPressed: _updateWidgetProperties,
              child: const Text('Update widget properties'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  setUpAll(() {
    registerFallbackValue(ArtboardFake());
  });

  late OnInitCallbackMock initMock;

  setUp(
    () {
      initMock = OnInitCallbackMock();
    },
  );

  testWidgets('Render a rive file', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final riveBytes = loadFile('assets/rive-flutter-test-asset.riv');
    final riveFile = RiveFile.import(riveBytes);
    await tester.pumpWidget(MaterialApp(home: RiveAnimation.direct(riveFile)));
  });

  group('Test updates to rive widget:', () {
    testWidgets('Changing animation changes rive widget',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      final riveBytes = loadFile('assets/rive-flutter-test-asset.riv');
      final riveFile = RiveFile.import(riveBytes);

      await tester.pumpWidget(
        MaterialApp(
          home: TestApp(
            riveFile,
            onInit: initMock.call,
          ),
        ),
      );

      final state =
          tester.state(find.byType(RiveAnimation).first) as RiveAnimationState;

      expect(state.widget.animations, ["one"]);

      await tester.tap(find.byKey(_changeAnimationButtonKey));
      await tester.pumpAndSettle();

      expect(state.widget.animations, ["two"]);
      verify(() => initMock.call(any())).called(2);
    });

    testWidgets('Changing state machines changes rive widget',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      final riveBytes = loadFile('assets/rive-flutter-test-asset.riv');
      final riveFile = RiveFile.import(riveBytes);

      await tester.pumpWidget(
        MaterialApp(
          home: TestApp(
            riveFile,
            onInit: initMock.call,
          ),
        ),
      );

      final state =
          tester.state(find.byType(RiveAnimation).first) as RiveAnimationState;

      expect(state.widget.stateMachines, ["one"]);

      await tester.tap(find.byKey(_changeStateMachineButtonKey));
      await tester.pumpAndSettle();

      expect(state.widget.stateMachines, ["two"]);
      verify(() => initMock.call(any())).called(2);
    });

    testWidgets('Changing controller changes rive widget',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      final riveBytes = loadFile('assets/rive-flutter-test-asset.riv');
      final riveFile = RiveFile.import(riveBytes);

      await tester.pumpWidget(
        MaterialApp(
          home: TestApp(
            riveFile,
            onInit: initMock.call,
          ),
        ),
      );

      final state =
          tester.state(find.byType(RiveAnimation).first) as RiveAnimationState;

      expect((state.widget.controllers.first as SimpleAnimation).animationName,
          "one");

      await tester.tap(find.byKey(_changeControllerButtonKey));
      await tester.pumpAndSettle();

      expect((state.widget.controllers.first as SimpleAnimation).animationName,
          "two");
      verify(() => initMock.call(any())).called(2);
    });

    testWidgets(
        'Changing fit|alignment|anitaliasing|placeholder does not call onInit',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      final riveBytes = loadFile('assets/rive-flutter-test-asset.riv');
      final riveFile = RiveFile.import(riveBytes);

      await tester.pumpWidget(
        MaterialApp(
          home: TestApp(
            riveFile,
            onInit: initMock.call,
          ),
        ),
      );

      final state =
          tester.state(find.byType(RiveAnimation).first) as RiveAnimationState;

      expect(state.widget.alignment, Alignment.topCenter);
      expect(state.widget.fit, BoxFit.contain);
      expect(state.widget.antialiasing, true);
      expect(state.widget.placeHolder, _placeHolderWidgetOne);

      await tester.tap(find.byKey(_updateWidgetPropertiesButtonKey));
      await tester.pumpAndSettle();

      expect(state.widget.alignment, Alignment.bottomCenter);
      expect(state.widget.fit, BoxFit.fitHeight);
      expect(state.widget.antialiasing, false);
      expect(state.widget.placeHolder, _placeHolderWidgetTwo);

      // should not call onInit more than onces when updating these properties
      verify(() => initMock.call(any())).called(1);
    });
  });
}

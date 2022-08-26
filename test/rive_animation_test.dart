import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';
import 'src/utils.dart';

class TestApp extends StatefulWidget {
  final RiveFile file;
  const TestApp(this.file) : super();

  @override
  _TestAppState createState() => _TestAppState();
}

class _TestAppState extends State<TestApp> {
  int _counter = 0;
  String animation = "";
  final animations = ["one", "two"];

  @override
  void initState() {
    animation = animations.first;
  }

  void _changeAnimation() {
    setState(() {
      _counter += 1;
      animation = animations[_counter % animations.length];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RiveAnimation.direct(
          widget.file,
          animations: [animation],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: _changeAnimation),
    );
  }
}

void main() {
  testWidgets('Render a rive file', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final riveBytes = loadFile('assets/rive-flutter-test-asset.riv');
    final riveFile = RiveFile.import(riveBytes);
    await tester.pumpWidget(MaterialApp(home: RiveAnimation.direct(riveFile)));
  });

  testWidgets('Changing animation changes rive widget',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final riveBytes = loadFile('assets/rive-flutter-test-asset.riv');
    final riveFile = RiveFile.import(riveBytes);

    await tester.pumpWidget(MaterialApp(home: TestApp(riveFile)));

    final initialState =
        tester.state(find.byType(RiveAnimation).first) as RiveAnimationState;
    expect(initialState.widget.animations, ["one"]);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    final finalState =
        tester.state(find.byType(RiveAnimation).first) as RiveAnimationState;
    expect(finalState.widget.animations, ["two"]);
  });
}

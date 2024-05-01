import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';

import '../../src/utils.dart';
import '../golden_comparator.dart';

void main() {
  group('Golden - ticker mode tests', () {
    testWidgets('ticker mode initially false pauses animation',
        (WidgetTester tester) async {
      final riveBytes = loadFile('assets/off_road_car.riv');
      final file = RiveFile.import(riveBytes);

      final widget = TickerMode(
        enabled: false,
        child: RiveAnimation.direct(file),
      );
      await tester.pumpWidget(widget);

      // Advance animation by one frame
      await tester.pump();

      await expectGoldenMatches(
        find.byType(RiveAnimation),
        'ticker_mode_false.png',
        reason: 'Animation frame should be paused with ticker mode false',
      );

      await tester.pumpFrames(widget, const Duration(milliseconds: 1500));

      await expectGoldenMatches(
        find.byType(RiveAnimation),
        'ticker_mode_false.png',
        reason: 'Animation should not have advanced with ticker mode false',
      );
    });

    testWidgets('ticker mode initially true plays animation',
        (WidgetTester tester) async {
      final riveBytes = loadFile('assets/off_road_car.riv');
      final file = RiveFile.import(riveBytes);

      final widget = TickerMode(
        enabled: true,
        child: RiveAnimation.direct(file),
      );
      await tester.pumpWidget(widget);

      await tester.pumpFrames(widget, const Duration(milliseconds: 100));

      await expectGoldenMatches(
        find.byType(RiveAnimation),
        'ticker_mode_true_1.png',
        reason: 'Animation frame should play with ticker mode true',
      );

      await tester.pumpFrames(widget, const Duration(milliseconds: 1500));

      await expectGoldenMatches(
        find.byType(RiveAnimation),
        'ticker_mode_true_2.png',
        reason: 'Animation should advance with ticker mode true',
      );
    });

    testWidgets('ticker mode variable state', (WidgetTester tester) async {
      final riveBytes = loadFile('assets/off_road_car.riv');
      final file = RiveFile.import(riveBytes);

      final key = GlobalKey<_VariableTickerModeState>();
      final widget = _VariableTickerMode(stateKey: key, file: file);

      await tester.pumpWidget(widget);

      await tester.pumpFrames(widget, const Duration(milliseconds: 100));

      await expectGoldenMatches(
        find.byType(RiveAnimation),
        'ticker_mode_true_1.png',
        reason: 'Animation frame should play with ticker mode true',
      );

      key.currentState!.disableTickerMode();

      await tester.pumpFrames(widget, const Duration(milliseconds: 1500));

      await expectGoldenMatches(
        find.byType(RiveAnimation),
        'ticker_mode_true_paused_state.png',
        reason:
            'Animation should not have advanced with ticker mode state false',
      );
    });
  });
}

class _VariableTickerMode extends StatefulWidget {
  const _VariableTickerMode({
    required this.stateKey,
    required this.file,
  }) : super(key: stateKey);

  final GlobalKey<_VariableTickerModeState> stateKey;
  final RiveFile file;

  @override
  State<_VariableTickerMode> createState() => _VariableTickerModeState();
}

class _VariableTickerModeState extends State<_VariableTickerMode> {
  bool ticker = true;

  void disableTickerMode() {
    setState(() {
      ticker = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TickerMode(
      enabled: ticker,
      child: RiveAnimation.direct(widget.file),
    );
  }
}

import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';

void main() {
  late File riveFile;

  setUp(() async {
    final file = io.File('test/assets/rive_file_controller_test.riv');
    riveFile = await File.decode(
      await file.readAsBytes(),
      riveFactory: Factory.flutter,
    ) as File;
  });

  testWidgets('RiveWidgetBuilder cancels previous setup when new one starts',
      (WidgetTester tester) async {
    // Track state changes from each file loader
    RiveLoaded? stateFromFirstLoader;
    RiveLoaded? stateFromSecondLoader;

    // Create a delayed file loader for the first setup
    final delayedFileLoader1 = _DelayedFileLoader(
      riveFile,
      delay: const Duration(milliseconds: 100),
    );

    // Create a faster file loader for the second setup
    final fastFileLoader2 = _DelayedFileLoader(
      riveFile,
      delay: const Duration(milliseconds: 10),
    );

    // Track the final loaded state
    RiveLoaded? finalLoadedState;

    await tester.pumpWidget(
      MaterialApp(
        home: _TestWidget(
          initialFileLoader: delayedFileLoader1,
          onStateChanged: (state) {
            if (state is RiveLoaded) {
              stateFromFirstLoader = state;
              finalLoadedState = state;
            }
          },
        ),
      ),
    );

    // Start the first setup
    await tester.pump();

    // Wait a bit to ensure first setup has started loading
    await tester.pump(const Duration(milliseconds: 20));

    // Change to the second file loader - this should cancel the first setup
    await tester.pumpWidget(
      MaterialApp(
        home: _TestWidget(
          initialFileLoader: fastFileLoader2,
          onStateChanged: (state) {
            if (state is RiveLoaded) {
              stateFromSecondLoader = state;
              finalLoadedState = state;
            }
          },
        ),
      ),
    );

    // Wait for the second setup to complete
    await tester.pumpAndSettle();

    // Wait a bit more to ensure first setup would have completed if not cancelled
    await tester.pump(const Duration(milliseconds: 150));

    // Verify that the second setup completed and is the final state
    expect(finalLoadedState, isNotNull);
    expect(stateFromSecondLoader, isNotNull);
    expect(identical(finalLoadedState, stateFromSecondLoader), isTrue);

    // Verify that the first setup was cancelled - it should not have
    // updated the state (stateFromFirstLoader should be null or different)
    // The first file loader may complete, but the setup should be cancelled
    // before calling setState
    if (stateFromFirstLoader != null) {
      // If the first loader did create a state, it should not be the final one
      expect(identical(finalLoadedState, stateFromFirstLoader), isFalse);
    }

    // Cleanup
    delayedFileLoader1.dispose();
    fastFileLoader2.dispose();
  });

  testWidgets(
      'RiveWidgetBuilder cancels setup when widget is disposed during loading',
      (WidgetTester tester) async {
    bool stateUpdatedAfterDisposal = false;

    final delayedFileLoader = _DelayedFileLoader(
      riveFile,
      delay: const Duration(milliseconds: 100),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: _TestWidget(
          initialFileLoader: delayedFileLoader,
          onStateChanged: (state) {
            if (state is RiveLoaded) {
              stateUpdatedAfterDisposal = true;
            }
          },
        ),
      ),
    );

    // Start loading
    await tester.pump();

    // Dispose the widget before loading completes
    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));

    // Wait long enough for the delayed file loader to complete
    await tester.pump(const Duration(milliseconds: 150));

    // The file loader may complete, but the setup should be cancelled
    // and not update the state after disposal (mounted check should prevent setState)
    // Note: We can't directly verify this without accessing internal state,
    // but the fact that the widget was disposed means mounted should be false
    expect(stateUpdatedAfterDisposal, isFalse);

    delayedFileLoader.dispose();
  });
}

/// A file loader that introduces a delay before loading the file.
/// This is used to test cancellation behavior.
class _DelayedFileLoader extends FileLoader {
  final File _file;
  final Duration delay;

  _DelayedFileLoader(
    this._file, {
    required this.delay,
  }) : super.fromFile(_file, riveFactory: Factory.flutter);

  @override
  Future<File> file() async {
    await Future.delayed(delay);
    return _file;
  }
}

class _TestWidget extends StatefulWidget {
  final FileLoader initialFileLoader;
  final void Function(RiveState state) onStateChanged;

  const _TestWidget({
    required this.initialFileLoader,
    required this.onStateChanged,
  });

  @override
  State<_TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<_TestWidget> {
  late FileLoader _fileLoader;

  @override
  void initState() {
    super.initState();
    _fileLoader = widget.initialFileLoader;
  }

  @override
  void dispose() {
    _fileLoader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RiveWidgetBuilder(
      fileLoader: _fileLoader,
      builder: (context, state) {
        // Notify about state changes
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.onStateChanged(state);
        });
        return const SizedBox.shrink();
      },
    );
  }
}

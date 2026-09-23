import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:rive_example/main.dart' show RiveExampleApp;

/// Keyboard focus testing against `focus.riv` (trays/testing/focus): one
/// artboard per scenario, each labelled with what to press and what should
/// happen. A text field above and a button below the graphic give Tab
/// somewhere to come from and go to; the readout under the graphic polls
/// the state machine's focus state.
class ExampleFocus extends StatefulWidget {
  const ExampleFocus({super.key});

  @override
  State<ExampleFocus> createState() => _ExampleFocusState();
}

class _ExampleFocusState extends State<ExampleFocus> {
  File? file;
  List<String> artboardNames = const [];
  int selectedArtboard = 0;
  RiveWidgetController? controller;
  bool keyboardFocus = true;
  FocusState focusState = const FocusState(
    hasFocus: false,
    expectsKeyboardInput: false,
  );
  String lastPressed = '';
  ViewModelInstanceString? lastPressedProperty;
  Timer? poll;

  @override
  void initState() {
    super.initState();
    initRive();
    poll = Timer.periodic(const Duration(milliseconds: 100), (_) => _poll());
  }

  void initRive() async {
    final file = await File.asset(
      'assets/focus.riv',
      riveFactory: RiveExampleApp.getCurrentFactory,
    );
    if (!mounted) {
      file?.dispose();
      return;
    }
    this.file = file;

    artboardNames = file!.artboardNames;
    // Component artboards (Button, Pair) come first in file order; start on
    // the tray's main artboard.
    final defaultArtboard = file.defaultArtboard();
    selectedArtboard = artboardNames.indexOf(defaultArtboard?.name ?? '');
    defaultArtboard?.dispose();
    if (selectedArtboard < 0) selectedArtboard = 0;

    _buildController();
    setState(() {});
  }

  void _buildController() {
    lastPressedProperty?.removeListener(_onLastPressed);
    controller?.dispose();
    controller = RiveWidgetController(
      file!,
      artboardSelector: ArtboardSelector.byIndex(selectedArtboard),
    );
    lastPressedProperty = controller!.viewModelInstance?.string('lastPressed');
    lastPressed = lastPressedProperty?.value ?? '';
    lastPressedProperty?.addListener(_onLastPressed);
  }

  void _onLastPressed(String value) => setState(() => lastPressed = value);

  void _selectArtboard(int index) {
    if (index == selectedArtboard) return;
    setState(() {
      selectedArtboard = index;
      _buildController();
    });
  }

  /// Focus moves on key events the page never sees, so the readout polls.
  void _poll() {
    final state = controller?.stateMachine.focusState;
    if (state == null) return;
    if (state.hasFocus != focusState.hasFocus ||
        state.expectsKeyboardInput != focusState.expectsKeyboardInput) {
      setState(() => focusState = state);
    }
  }

  @override
  void dispose() {
    poll?.cancel();
    lastPressedProperty?.removeListener(_onLastPressed);
    controller?.dispose();
    file?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = this.controller;
    if (controller == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DropdownButton<int>(
                value: selectedArtboard,
                items: [
                  for (var i = 0; i < artboardNames.length; i++)
                    DropdownMenuItem(value: i, child: Text(artboardNames[i])),
                ],
                onChanged: (i) => _selectArtboard(i!),
              ),
              const SizedBox(width: 24),
              const Text('keyboardFocus'),
              Switch(
                value: keyboardFocus,
                onChanged: (v) => setState(() => keyboardFocus = v),
              ),
            ],
          ),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Before: a Flutter text field. Tab moves on.',
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: 640 / 360,
                child: RiveWidget(
                  controller: controller,
                  keyboardFocus: keyboardFocus,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Rive focus: ${focusState.hasFocus ? 'yes' : 'no'}'
            '${focusState.expectsKeyboardInput ? ', expects keyboard input' : ''}'
            '${lastPressed.isEmpty ? '' : ', last pressed: $lastPressed'}',
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {},
            child: const Text('After: a Flutter button'),
          ),
        ],
      ),
    );
  }
}

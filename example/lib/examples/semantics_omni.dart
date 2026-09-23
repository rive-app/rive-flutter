import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart' show SemanticsBinding, SemanticsHandle;
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:rive/rive.dart';
import 'package:rive_example/main.dart' show RiveExampleApp;

/// All-purpose semantics testing against a single file, `semantics.riv`.
///
/// This is the primary semantics test surface: one omni file holding many
/// artboards, each exercising a semantics case. Pick an artboard from the
/// dropdown to test it in isolation. Keyboard: S toggles forced semantics,
/// D toggles the semantics debugger overlay.
class ExampleSemanticsOmni extends StatefulWidget {
  const ExampleSemanticsOmni({super.key});

  @override
  State<ExampleSemanticsOmni> createState() => _ExampleSemanticsOmniState();
}

class _ExampleSemanticsOmniState extends State<ExampleSemanticsOmni> {
  File? file;
  List<String> artboardNames = const [];
  int selectedArtboard = 0;
  RiveWidgetController? controller;
  SemanticsHandle? semanticsHandle;
  bool showDebugger = false;

  @override
  void initState() {
    super.initState();
    initRive();
  }

  void initRive() async {
    final file = await File.asset(
      'assets/semantics.riv',
      riveFactory: RiveExampleApp.getCurrentFactory,
    );
    if (!mounted) {
      file?.dispose();
      return;
    }
    this.file = file;

    artboardNames = file!.artboardNames;

    _buildController();
    setState(() {});
  }

  void _buildController() {
    controller?.dispose();
    controller = RiveWidgetController(
      file!,
      artboardSelector: ArtboardSelector.byIndex(selectedArtboard),
    );
  }

  void _selectArtboard(int index) {
    if (index == selectedArtboard) return;
    setState(() {
      selectedArtboard = index;
      _buildController();
    });
  }

  @override
  void dispose() {
    semanticsHandle?.dispose();
    controller?.dispose();
    file?.dispose();
    super.dispose();
  }

  void _toggleForcedSemantics(bool on) {
    if (on) {
      semanticsHandle ??= SemanticsBinding.instance.ensureSemantics();
    } else {
      semanticsHandle?.dispose();
      semanticsHandle = null;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final controller = this.controller;
    // The SemanticsDebugger paints the whole view's semantic tree in its own
    // render box's coordinate space, so it must sit at the route root (above
    // the AppBar) or the overlay is offset by the AppBar height. This page is
    // registered as selfManaged, so it owns its Scaffold and wraps it here.
    return _maybeDebugger(
      Scaffold(
        appBar: AppBar(title: const Text('Semantics [Omni]')),
        body: controller == null
            ? const Center(child: CircularProgressIndicator())
            : _buildBody(controller),
      ),
    );
  }

  Widget _buildBody(RiveWidgetController controller) {
    final graphic = RiveWidget(
      // A key per artboard forces a fresh subtree when the selection
      // (and thus the controller) changes.
      key: ValueKey(selectedArtboard),
      controller: controller,
      // The omni artboards are layout-based, so fill the available view.
      fit: Fit.layout,
      semantics: RiveSemantics.auto,
    );

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyS): () =>
            _toggleForcedSemantics(semanticsHandle == null),
        const SingleActivator(LogicalKeyboardKey.keyD): () =>
            setState(() => showDebugger = !showDebugger),
      },
      child: Focus(
        autofocus: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  FilterChip(
                    label: const Text('Force semantics (S)'),
                    selected: semanticsHandle != null,
                    onSelected: _toggleForcedSemantics,
                    visualDensity: VisualDensity.compact,
                  ),
                  FilterChip(
                    label: const Text('Debugger (D)'),
                    selected: showDebugger,
                    onSelected: (on) => setState(() => showDebugger = on),
                    visualDensity: VisualDensity.compact,
                  ),
                  DropdownButton<int>(
                    value: selectedArtboard,
                    isDense: true,
                    items: [
                      for (var i = 0; i < artboardNames.length; i++)
                        DropdownMenuItem(
                          value: i,
                          child: Text(artboardNames[i]),
                        ),
                    ],
                    onChanged: (value) {
                      if (value != null) _selectArtboard(value);
                    },
                  ),
                ],
              ),
            ),
            Expanded(child: graphic),
          ],
        ),
      ),
    );
  }

  Widget _maybeDebugger(Widget child) =>
      showDebugger ? SemanticsDebugger(child: child) : child;
}

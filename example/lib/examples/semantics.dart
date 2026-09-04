import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart' show SemanticsBinding, SemanticsHandle;
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:rive/rive.dart';
import 'package:rive_example/main.dart' show RiveExampleApp;

/// Demonstrates [RiveWidget.semantics].
///
/// A dropdown selects one semantics example at a time; each graphic uses
/// [RiveSemantics.auto], so nothing tracks semantics until a screen reader
/// connects or the force switch turns on. Keyboard: S toggles forced
/// semantics, D toggles the semantics debugger overlay.
///
/// Flutter only builds its semantics tree once the platform asks for one
/// (a screen reader connects; on web that happens after activating the
/// hidden "Enable accessibility" element). The force switch uses
/// [SemanticsBinding.ensureSemantics] so the tree is inspectable without
/// a screen reader, e.g. in the browser's accessibility devtools.
class ExampleSemantics extends StatefulWidget {
  const ExampleSemantics({super.key});

  @override
  State<ExampleSemantics> createState() => _ExampleSemanticsState();
}

/// One selectable semantics example: a display name, an optional
/// explanation shown under the picker, and the widgets to show.
class _ExampleEntry {
  final String name;
  final String? info;
  final List<Widget> Function() build;
  const _ExampleEntry({required this.name, this.info, required this.build});
}

class _ExampleSemanticsState extends State<ExampleSemantics> {
  File? tabFile;
  File? dropdownFile;
  File? focusListFile;
  File? zeroAreaFile;
  RiveWidgetController? tabController;
  RiveWidgetController? dropdownController;
  RiveWidgetController? focusListController;
  RiveWidgetController? zeroAreaController;
  String enumValue = '';
  String lastPressed = '';
  SemanticsHandle? semanticsHandle;
  bool showDebugger = false;
  int selectedExample = 0;

  @override
  void initState() {
    super.initState();
    initRive();
  }

  void initRive() async {
    // The page can be disposed while a load is awaiting; dispose() only
    // covers fields assigned so far, so each continuation disposes its
    // own just-loaded file when unmounted.
    final factory = RiveExampleApp.getCurrentFactory;
    final tabFile = await File.asset(
      'assets/tabtest.riv',
      riveFactory: factory,
    );
    if (!mounted) {
      tabFile?.dispose();
      return;
    }
    this.tabFile = tabFile;

    final dropdownFile = await File.asset(
      'assets/data_binding_lists.riv',
      riveFactory: factory,
    );
    if (!mounted) {
      dropdownFile?.dispose();
      return;
    }
    this.dropdownFile = dropdownFile;

    final focusListFile = await File.asset(
      'assets/semantic_list_scroll_focus_fixed.riv',
      riveFactory: factory,
    );
    if (!mounted) {
      focusListFile?.dispose();
      return;
    }
    this.focusListFile = focusListFile;

    final zeroAreaFile = await File.asset(
      'assets/zero_area_semantics.riv',
      riveFactory: factory,
    );
    if (!mounted) {
      zeroAreaFile?.dispose();
      return;
    }
    this.zeroAreaFile = zeroAreaFile;

    final tabController = this.tabController = RiveWidgetController(tabFile!);
    final enumProperty = tabController.viewModelInstance?.enumerator(
      'enumProperty',
    );
    enumValue = enumProperty?.value ?? '';
    enumProperty?.addListener(_onEnumChanged);

    dropdownController = RiveWidgetController(dropdownFile!);
    focusListController = RiveWidgetController(focusListFile!);

    final zeroAreaController = this.zeroAreaController = RiveWidgetController(
      zeroAreaFile!,
    );
    final lastPressedProperty = zeroAreaController.viewModelInstance?.string(
      'lastPressed',
    );
    lastPressed = lastPressedProperty?.value ?? '';
    lastPressedProperty?.addListener(_onLastPressedChanged);

    setState(() {});
  }

  void _onEnumChanged(String value) {
    setState(() => enumValue = value);
  }

  void _onLastPressedChanged(String value) {
    setState(() => lastPressed = value);
  }

  @override
  void dispose() {
    semanticsHandle?.dispose();
    tabController?.dispose();
    dropdownController?.dispose();
    focusListController?.dispose();
    zeroAreaController?.dispose();
    tabFile?.dispose();
    dropdownFile?.dispose();
    focusListFile?.dispose();
    zeroAreaFile?.dispose();
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

  List<_ExampleEntry> _entries(
    RiveWidgetController tabs,
    RiveWidgetController dropdown,
    RiveWidgetController focusList,
    RiveWidgetController zeroArea,
  ) => [
    _ExampleEntry(
      name: 'Tabs',
      info:
          'Three tabs writing enumProperty. Activate them with a tap '
          'or a screen reader action; the readout shows the bound value.',
      build: () => [
        SizedBox(
          height: 200,
          child: RiveWidget(controller: tabs, semantics: RiveSemantics.auto),
        ),
        Text('enumProperty: $enumValue'),
      ],
    ),
    _ExampleEntry(
      name: 'Expandable dropdown',
      info:
          'A data-bound list behind an expandable button - expansion '
          'state and list items flow into the semantic tree.',
      build: () => [
        SizedBox(
          height: 400,
          child: RiveWidget(
            controller: dropdown,
            semantics: RiveSemantics.auto,
          ),
        ),
      ],
    ),
    _ExampleEntry(
      name: 'Focusable list',
      info:
          'Cards wired into the focus system (Element 1..5). Move '
          'screen reader focus across them - the previous card must '
          'drop its focused state, and focus leaving the graphic must '
          'clear it.',
      build: () => [
        SizedBox(
          height: 500,
          child: RiveWidget(
            controller: focusList,
            semantics: RiveSemantics.auto,
          ),
        ),
      ],
    ),
    _ExampleEntry(
      name: 'Zero-area cases',
      info:
          'Empty groups, a card collapsing through zero width, a '
          'group scaling through zero, and a hidden subtree. Children '
          'of collapsed containers must stay reachable; hidden content '
          'must never appear. Taps write lastPressed.',
      build: () => [
        SizedBox(
          height: 800,
          child: RiveWidget(
            controller: zeroArea,
            semantics: RiveSemantics.auto,
          ),
        ),
        Text('lastPressed: $lastPressed'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final tabController = this.tabController;
    final dropdownController = this.dropdownController;
    final focusListController = this.focusListController;
    final zeroAreaController = this.zeroAreaController;
    final loading =
        tabController == null ||
        dropdownController == null ||
        focusListController == null ||
        zeroAreaController == null;

    // The SemanticsDebugger paints the whole view's semantic tree in its own
    // render box's coordinate space, so it must sit at the route root (above
    // the AppBar) or the overlay is offset by the AppBar height. This page is
    // registered as selfManaged, so it owns its Scaffold and wraps it here.
    return _maybeDebugger(
      Scaffold(
        appBar: AppBar(title: const Text('Semantics [Examples]')),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : _buildBody(
                tabController,
                dropdownController,
                focusListController,
                zeroAreaController,
              ),
      ),
    );
  }

  Widget _buildBody(
    RiveWidgetController tabController,
    RiveWidgetController dropdownController,
    RiveWidgetController focusListController,
    RiveWidgetController zeroAreaController,
  ) {
    final entries = _entries(
      tabController,
      dropdownController,
      focusListController,
      zeroAreaController,
    );
    final entry = entries[selectedExample];

    final graphics = ListView(
      padding: const EdgeInsets.all(16),
      children: entry.build(),
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
                    value: selectedExample,
                    isDense: true,
                    items: [
                      for (var i = 0; i < entries.length; i++)
                        DropdownMenuItem(
                          value: i,
                          child: Text(entries[i].name),
                        ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedExample = value);
                      }
                    },
                  ),
                ],
              ),
            ),
            if (entry.info != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: Text(
                  entry.info!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            Expanded(child: graphics),
          ],
        ),
      ),
    );
  }

  Widget _maybeDebugger(Widget child) =>
      showDebugger ? SemanticsDebugger(child: child) : child;
}

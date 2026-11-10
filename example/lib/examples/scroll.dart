import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:rive_example/main.dart' show RiveExampleApp;

/// Scroll testing against `scroll.riv` (trays/testing/scroll). A count that
/// goes up while scrolling shows a stray click.
class ExampleScroll extends StatefulWidget {
  const ExampleScroll({super.key});

  @override
  State<ExampleScroll> createState() => _ExampleScrollState();
}

class _ExampleScrollState extends State<ExampleScroll> {
  File? file;
  List<String> feeds = const [];
  String? selected;
  RiveWidgetController? controller;

  @override
  void initState() {
    super.initState();
    initRive();
  }

  void initRive() async {
    final file = await File.asset(
      'assets/scroll.riv',
      riveFactory: RiveExampleApp.getCurrentFactory,
    );
    if (!mounted) {
      file?.dispose();
      return;
    }
    this.file = file;
    // The Row component is a list item, not a page of its own.
    feeds = file!.artboardNames.where((name) => name != 'Row').toList();
    _select(feeds.first);
  }

  void _select(String name) {
    setState(() {
      selected = name;
      controller?.dispose();
      controller = RiveWidgetController(
        file!,
        artboardSelector: ArtboardSelector.byName(name),
      );
    });
  }

  @override
  void dispose() {
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
    return Column(
      children: [
        DropdownButton<String>(
          value: selected,
          items: [
            for (final name in feeds)
              DropdownMenuItem(value: name, child: Text(name)),
          ],
          onChanged: (name) => _select(name!),
        ),
        Expanded(
          child: RiveWidget(
            key: ValueKey(selected),
            controller: controller,
            fit: Fit.layout,
          ),
        ),
      ],
    );
  }
}

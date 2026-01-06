// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:rive_example/advanced/advanced.dart';
import 'package:rive_example/colors.dart';
import 'package:rive_example/examples/examples.dart';
import 'package:rive/rive.dart' as rive;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await rive.RiveNative.init();

  runApp(
    MaterialApp(
      title: 'Rive Example',
      home: const RiveExampleApp(),
      // showPerformanceOverlay: true,
      darkTheme: ThemeData(
        fontFamily: 'JetBrainsMono',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(backgroundColor: appBarColor),
        colorScheme: ColorScheme.fromSwatch(
          brightness: Brightness.dark,
        ).copyWith(primary: primaryColor),
      ),
      themeMode: ThemeMode.dark,
    ),
  );
}

/// Determines which factory/renderer to use for the Rive examples.
///
/// In your app you can combine the usage of the Rive Renderer and the Flutter
/// Renderer. For this example app we have a static variable to determine which
/// factory to use app wide.
///
/// - `rive` uses the Rive Renderer
/// - `flutter` uses the Flutter Renderer (Skia / Impeller)
enum RiveFactoryToUse { rive, flutter }

/// An example application demoing Rive.
class RiveExampleApp extends StatefulWidget {
  const RiveExampleApp({Key? key}) : super(key: key);

  static RiveFactoryToUse factoryToUse = RiveFactoryToUse.rive;

  static rive.Factory get getCurrentFactory => switch (factoryToUse) {
        RiveFactoryToUse.rive => rive.Factory.rive,
        RiveFactoryToUse.flutter => rive.Factory.flutter,
      };

  @override
  State<RiveExampleApp> createState() => _RiveExampleAppState();
}

class _RiveExampleAppState extends State<RiveExampleApp> {
  // ScrollController for the CustomScrollView
  final ScrollController _scrollController = ScrollController();

  // Examples organized into sections
  final _sections = [
    const _Section('Getting Started', [
      _Page(
        'Rive Widget',
        ExampleRiveWidget(),
        'Simple example usage of the Rive widget with common parameters.',
      ),
      _Page(
        'Rive Widget Builder',
        ExampleRiveWidgetBuilder(),
        'Example usage of the Rive builder widget with common parameters.',
      ),
      _Page(
        'Rive Panel [Shared Texture]',
        ExampleRivePanel(),
        'Example usage of the Shared Texture View widget.',
      ),
    ]),
    const _Section('Rive Features', [
      _Page(
        'Data Binding',
        ExampleDataBinding(),
        'Example using Rive data binding at runtime.',
      ),
      _Page(
        'Data Binding - Images',
        ExampleDataBindingImages(),
        'Example using Rive data binding images at runtime.',
      ),
      _Page(
        'Data Binding - Artboards',
        ExampleDataBindingArtboards(),
        'Example using Rive data binding artboards at runtime.',
      ),
      _Page(
        'Data Binding - Lists',
        ExampleDataBindingLists(),
        'Example using Rive data binding lists at runtime.',
      ),
      _Page(
        'Responsive Layouts',
        ExampleResponsiveLayouts(),
        'Create responsive Rive graphics that adapt to screen size.',
      ),
      _Page('Events', ExampleEvents(), 'Handle Rive events.'),
      _Page('Audio', ExampleRiveAudio(), 'Example Rive file with audio.'),
    ]),
    const _Section('Asset Loading', [
      _Page(
        'Network .riv Asset',
        ExampleNetworkAsset(),
        'Load and display Rive graphics from network URLs.',
      ),
      _Page(
        'Out-of-band Assets',
        ExampleOutOfBandAssetLoading(),
        'Load Rive files with external assets (images, audio) separately.',
      ),
      _Page(
        'Out-of-band Assets - Audio',
        ExampleOutOfBandAssetAudioLoading(),
        'Load Rive files with audio assets.',
      ),
      _Page(
        'Out-of-band Assets - Cached',
        ExampleOutOfBandCachedAssetLoading(),
        'Load Rive files with cached external assets for better immediate availability.',
      ),
    ]),
    const _Section('Painters [Advanced]', [
      _Page(
        'State Machine Painter',
        ExampleStateMachinePainter(),
        'Advanced: Custom painter for state machines.',
      ),
      _Page(
        'Single Animation Painter',
        ExampleSingleAnimationPainter(),
        'Advanced: Custom painter for single animation playback.',
      ),
      _Page('Centaur Game', CentaurGameWidget(), 'Advanced: Centaur Game.'),
    ]),
    const _Section('Flutter Concepts/Integration', [
      // _Page('Flutter Lists', Todo(),
      //     'Integrate Rive graphics with Flutter list widgets.'),
      _Page('Pause/Play', ExamplePausePlay(), 'Pause and play Rive graphics.'),
      _Page(
        'Flutter Hit Test + Cursor Behaviour',
        ExampleHitTestBehaviour(),
        'Specifying hit test and cursor behaviour.',
      ),
      _Page(
        'Flutter Ticker Mode',
        ExampleTickerMode(),
        'Rive graphics respect Flutter ticker mode.',
      ),
      _Page(
        'Flutter Time Dilation',
        ExampleTimeDilation(),
        'Rive graphics respect Flutter time dilation.',
      ),
      _Page(
        'Flutter Transform',
        ExampleTransform(),
        'Rive graphics respect Flutter transform.',
      ),
      _Page(
        'Flutter Multi Touch',
        ExampleMultiTouch(),
        'Rive graphics respect Flutter multi touch.',
      ),
      // _Page('Flutter Hero Transitions', Todo(),
      //     'Create smooth transitions between pages with Rive graphics.'),
      // _Page('Flutter State Management', Todo(),
      //     'Manage Rive state with Flutter state management.'),
      // _Page('Flutter Localization', Todo(),
      //     'Localize Rive graphics for different languages.'),
      // _Page('Flutter Internationalization', Todo(),
      //     'Internationalize Rive graphics with Flutter i18n.'),
    ]),
    const _Section('Performance/Memory testing', [
      _Page(
        'Memory cleanup test',
        TestMemoryCleanup(),
        'Test memory cleanup by toggling the visibility of a Rive file widget.',
      ),
    ]),
    const _Section('Legacy Features [Use data binding instead]', [
      _Page(
        'Inputs [Nested]',
        ExampleInputs(),
        'Legacy: Handle input [nested] controls in Rive graphics.',
      ),
      _Page(
        'Text Runs [Nested]',
        ExampleTextRuns(),
        'Legacy: Handle text runs [nested] components in Rive graphics.',
      ),
    ]),
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rive Examples')),
      body: Column(
        children: [
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(8.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        // Calculate which section and item we're at
                        int itemIndex = index;

                        for (int i = 0; i < _sections.length; i++) {
                          if (itemIndex == 0) {
                            // This is a section header
                            return _SectionHeader(_sections[i].title);
                          }
                          itemIndex--;

                          if (itemIndex < _sections[i].pages.length) {
                            // This is a page within the current section
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: _NavButton(
                                page: _sections[i].pages[itemIndex],
                              ),
                            );
                          }
                          itemIndex -= _sections[i].pages.length;
                        }

                        return null;
                      }, childCount: _getTotalItemCount()),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ColoredBox(
            color: Colors.black,
            child: Column(
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Factory to use:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio<RiveFactoryToUse>(
                            value: RiveFactoryToUse.rive,
                            groupValue: RiveExampleApp.factoryToUse,
                            onChanged: (value) {
                              setState(() {
                                RiveExampleApp.factoryToUse =
                                    value as RiveFactoryToUse;
                              });
                            },
                          ),
                          const Text(
                            'Rive Renderer',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio<RiveFactoryToUse>(
                            value: RiveFactoryToUse.flutter,
                            groupValue: RiveExampleApp.factoryToUse,
                            onChanged: (value) {
                              setState(() {
                                RiveExampleApp.factoryToUse =
                                    value as RiveFactoryToUse;
                              });
                            },
                          ),
                          const Text(
                            'Flutter Renderer',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _getTotalItemCount() {
    int count = 0;
    for (final section in _sections) {
      count += 1; // Section header
      count += section.pages.length; // Pages in section
    }
    return count;
  }
}

/// Class used to organize demo sections.
class _Section {
  final String title;
  final List<_Page> pages;

  const _Section(this.title, this.pages);
}

/// Class used to organize demo pages.
class _Page {
  final String name;
  final Widget page;
  final String description;

  const _Page(this.name, this.page, this.description);
}

/// Section header widget with divider.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: primaryColor),
          ),
        ),
        const Divider(color: primaryColor, thickness: 0.5, height: 1),
        const SizedBox(height: 16),
      ],
    );
  }
}

/// Button to navigate to demo pages with hover overlay.
class _NavButton extends StatefulWidget {
  const _NavButton({required this.page});

  final _Page page;

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _isHovered = false;
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showOverlay() {
    _removeOverlay();

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: position.dy - 80, // Position above the button
        left: position.dx + (size.width / 2) - 150, // Center horizontally
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.9),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: primaryColor, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              widget.page.description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _showOverlay();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _removeOverlay();
      },
      child: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _isHovered ? primaryColor.withOpacity(0.1) : null,
            elevation: _isHovered ? 8 : 2,
          ),
          child: SizedBox(
            width: 300,
            child: Center(
              child: Text(
                widget.page.name,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
          onPressed: () {
            _removeOverlay();
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => _WrappedPage(page: widget.page),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Scaffold wrapper for the page.
class _WrappedPage extends StatelessWidget {
  const _WrappedPage({required this.page});

  final _Page page;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(page.name)),
      body: page.page,
    );
  }
}

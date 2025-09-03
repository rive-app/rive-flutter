import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:meta/meta.dart';

/// A widget that creates a shared texture to paint multiple [RiveWidget]s to.
///
/// Useful when using [Factory.rive]. This won't have an effect when using
/// [Factory.flutter], and will unnecessarily create a new render texture that
/// won't be used.
///
/// Painting multiple [RiveWidget]s to the same texture can drastically
/// improve performance under certain conditions. Drawing multiple [RiveWidget]s
/// each to their own texture has a performance cost. The more textures you draw
/// to, the more performance you lose. Additionally, on the web, you are
/// limited to the number of WebGL contexts the browser allows. Drawing to a
/// single texture avoids this limitation.
///
/// Wrap your [RiveWidget]s with a [RivePanel] to enable this behavior, and
/// set `useSharedTexture` to `true` in [RiveWidget]
///
/// Note:
/// - There is a memory cost in allocating a larger texture. However, under some
/// conditions, the memory cost might be better, or the same. Benchmarking
/// is recommended.
/// - Drawing to the same surface will mean that you cannot interleave drawing
/// commands that Rive performs with that of Flutter. If you need to interleave
/// content, you will need to draw to a separate surface - [RivePanel]. Or use
/// [Factory.flutter] - which uses the Flutter rendering pipeline to perform
/// all rendering as a single pass. Benchmarking is recommended - what works
/// for one use case may not work for another.
///
/// ### Example:
/// ```dart
/// class ExampleRivePanel extends StatelessWidget {
///   const ExampleRivePanel({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return const RivePanel(
///       backgroundColor: Colors.red,
///       child: ListViewExample(),
///     );
///   }
///}
///class ListViewExample extends StatefulWidget {
///  const ListViewExample({super.key});
///
///  @override
///  State<ListViewExample> createState() => _ListViewExampleState();
///}
///
///class _ListViewExampleState extends State<ListViewExample> {
///  late final fileLoader = FileLoader.fromAsset(
///    'assets/rating.riv',
///    riveFactory: Factory.rive,
///  );
///
///  @override
///  void dispose() {
///    fileLoader.dispose();
///    super.dispose();
///  }
///
///  @override
///  Widget build(BuildContext context) {
///    return ListView.builder(
///      itemCount: 10,
///      itemBuilder: (context, index) {
///        return MyRiveWidget(fileLoader: fileLoader);
///      },
///    );
///  }
///}
///class MyRiveWidget extends StatelessWidget {
///  const MyRiveWidget({super.key, required this.fileLoader});
///  final FileLoader fileLoader;
///
///  @override
///  Widget build(BuildContext context) {
///    return RiveWidgetBuilder(
///      fileLoader: fileLoader,
///      builder: (context, state) => switch (state) {
///        RiveLoading() => const Center(
///            child: Center(child: CircularProgressIndicator()),
///          ),
///        RiveFailed() => ErrorWidget.withDetails(
///            message: state.error.toString(),
///            error: FlutterError(state.error.toString()),
///          ),
///        RiveLoaded() => RiveWidget(
///            controller: state.controller,
///            fit: Fit.contain,
///
///            /// Set this to true to draw to the nearest `RivePanel`
///            useSharedTexture: true,
///          )
///      },
///    );
///  }
///}
/// ```
///
/// **EXPERIMENTAL**: This API may change or be removed in a future release.
@experimental
class RivePanel extends StatefulWidget {
  const RivePanel({
    super.key,
    this.backgroundColor = Colors.transparent,
    required this.child,
  });

  final Color backgroundColor;
  final Widget child;

  @override
  State<RivePanel> createState() => _RivePanelState();
}

class _RivePanelState extends State<RivePanel> {
  RenderTexture? _renderTexture;
  final GlobalKey _panelKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _renderTexture = RiveNative.instance.makeRenderTexture();
  }

  @override
  void dispose() {
    _renderTexture?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: _renderTexture!.widget(key: _panelKey),
        ),
        RiveSharedTexture(
          panelKey: _panelKey,
          backgroundColor: widget.backgroundColor,
          devicePixelRatio: MediaQuery.devicePixelRatioOf(context),
          texture: _renderTexture,
          child: widget.child,
        ),
      ],
    );
  }
}

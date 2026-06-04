import 'package:flutter/material.dart';
import 'package:rive/rive.dart' hide Animation;
import 'package:rive_example/main.dart' show RiveExampleApp;

class TestGraphicResizing extends StatefulWidget {
  const TestGraphicResizing({super.key});

  @override
  State<TestGraphicResizing> createState() => _TestGraphicResizingState();
}

class _TestGraphicResizingState extends State<TestGraphicResizing>
    with SingleTickerProviderStateMixin {
  late final fileLoader = FileLoader.fromAsset(
    'assets/rating.riv',
    // Choose which renderer to use
    riveFactory: RiveExampleApp.getCurrentFactory,
  );

  late final AnimationController _controller;
  late final Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _sizeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    // This widget state owns the file loader, dispose it.
    fileLoader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: _sizeAnimation,
      builder: (context, child) {
        return SizedBox(
          width: screenSize.width * _sizeAnimation.value,
          height: screenSize.height * _sizeAnimation.value,
          child: RiveWidgetBuilder(
            fileLoader: fileLoader,
            builder: (context, state) => switch (state) {
              RiveLoading() => const Center(child: CircularProgressIndicator()),
              RiveFailed() => ErrorWidget.withDetails(
                  message: state.error.toString(),
                  error: FlutterError(state.error.toString()),
                ),
              RiveLoaded() => RiveWidget(controller: state.controller),
            },
          ),
        );
      },
    );
  }
}

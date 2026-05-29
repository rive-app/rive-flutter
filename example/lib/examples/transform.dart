import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class ExampleTransform extends StatelessWidget {
  const ExampleTransform({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: _MyRiveWidget(riveFactory: Factory.rive)),
            Expanded(child: _MyRiveWidget(riveFactory: Factory.flutter)),
          ],
        ),
      ),
    );
  }
}

class _MyRiveWidget extends StatefulWidget {
  final Factory riveFactory;

  const _MyRiveWidget({required this.riveFactory});

  @override
  State<_MyRiveWidget> createState() => _MyRiveWidgetState();
}

class _MyRiveWidgetState extends State<_MyRiveWidget>
    with SingleTickerProviderStateMixin {
  bool isInitialized = false;

  late final File file;
  late final RiveWidgetController controller;
  late final ViewModelInstance vmi;

  double scale = 1.5;

  // Drives a continuous Z rotation on top of the user-controlled scale so
  // the Rive content has to track a transform that changes every frame.
  late final _rotation = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  )..repeat();

  @override
  void initState() {
    super.initState();
    initRive();
  }

  void initRive() async {
    file = (await File.asset(
      'assets/rive_rendering_test.riv',
      riveFactory: widget.riveFactory,
    ))!;
    controller = RiveWidgetController(
      file,
      artboardSelector: ArtboardSelector.byName('Rive Rendering'),
    );
    vmi = controller.dataBind(DataBind.auto());

    final renderName = vmi.string('rendererName')!;
    renderName.value = widget.riveFactory == Factory.flutter
        ? 'Flutter'
        : 'Rive';

    setState(() => isInitialized = true);
  }

  @override
  void dispose() {
    _rotation.dispose();
    controller.dispose();
    file.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isInitialized
        ? getTransformRiveWidget()
        : const CircularProgressIndicator();
  }

  Widget getTransformRiveWidget() {
    return Listener(
      onPointerSignal: (pointerSignal) {
        if (pointerSignal is PointerScrollEvent) {
          final delta = -pointerSignal.scrollDelta.dy;
          setState(() {
            scale = (scale + delta * 0.008).clamp(0.1, 5.0);
          });
        }
      },
      child: AnimatedBuilder(
        animation: _rotation,
        // [child] is built once and reused across every tick so only the
        // outer Transform rebuilds — the RiveWidget keeps the same
        // controller/painter.
        child: RiveWidget(controller: controller, fit: Fit.contain),
        builder: (context, child) {
          final angle = _rotation.value * 2 * math.pi;
          return Transform(
            transform: Matrix4.identity()
              // ignore: deprecated_member_use
              ..scale(scale, scale, scale)
              ..rotateZ(angle),
            alignment: Alignment.center,
            // filterQuality: FilterQuality.high,
            child: child,
          );
        },
      ),
    );
  }
}

// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

/// A widget that tests the memory cleanup of Rive resources.
/// This widget will create and destroy a Rive graphic's resources with
/// rendering multiple times a second.
class TestMemoryCleanup extends StatefulWidget {
  const TestMemoryCleanup({super.key});

  @override
  State<TestMemoryCleanup> createState() => _TestMemoryCleanupState();
}

class _TestMemoryCleanupState extends State<TestMemoryCleanup> {
  Timer? _visibilityTimer;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _startVisibilityTimer();
  }

  void _startVisibilityTimer() {
    _visibilityTimer = Timer.periodic(const Duration(milliseconds: 110), (
      timer,
    ) {
      setState(() {
        _isVisible = !_isVisible;
      });
    });
  }

  @override
  void dispose() {
    _visibilityTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isVisible ? const _RiveFileWidget() : const SizedBox.shrink(),
    );
  }
}

/// Widget that handles loading and displaying a Rive file.
/// This widget will be created and destroyed each time visibility toggles,
/// ensuring proper lifecycle management of Rive resources.
class _RiveFileWidget extends StatefulWidget {
  const _RiveFileWidget({super.key});

  @override
  State<_RiveFileWidget> createState() => _RiveFileWidgetState();
}

class _RiveFileWidgetState extends State<_RiveFileWidget> {
  File? _riveFile;
  RiveWidgetController? _controller;

  @override
  void initState() {
    super.initState();
    // print('RiveFileWidget: initState - loading file');
    _init();
  }

  Future<void> _init() async {
    _riveFile = await File.asset(
      'assets/rating.riv',
      riveFactory: Factory.rive,
    );
    _controller = RiveWidgetController(_riveFile!);
    setState(() {});
  }

  @override
  void dispose() {
    // print('RiveFileWidget: dispose - cleaning up resources');
    _controller?.dispose();
    _riveFile?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_riveFile == null || _controller == null) {
      return const SizedBox.shrink();
    }
    return RiveWidget(controller: _controller!);
  }
}

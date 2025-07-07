// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

/// We strongly recommend using Data Binding instead of Rive Events for better
/// runtime control if you need to do more advanced logic than simple events.
///
/// See: https://rive.app/docs/runtimes/data-binding
///
/// This example demonstrates how to retrieve custom properties set on a Rive
/// event, and update the UI accordingly.
///
/// See: https://rive.app/docs/runtimes/events
class ExampleEvents extends StatefulWidget {
  const ExampleEvents({super.key});

  @override
  State<ExampleEvents> createState() => _ExampleEventsState();
}

class _ExampleEventsState extends State<ExampleEvents> {
  File? _riveFile;
  RiveWidgetController? _controller;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _riveFile = await File.asset(
      'assets/rating.riv',
      riveFactory: Factory.rive,
    );
    _controller = RiveWidgetController(_riveFile!);
    _controller?.stateMachine.addEventListener(_onRiveEvent);
    setState(() {});
  }

  String ratingValue = 'Rating: 0';

  void _onRiveEvent(Event event) {
    // Access custom properties defined on the event
    print(event);
    var rating = event.numberProperty('rating')?.value ?? 0;
    setState(() {
      ratingValue = 'Rating: $rating';
    });
  }

  @override
  void dispose() {
    _controller?.stateMachine.removeEventListener(_onRiveEvent);
    _controller?.stateMachine.dispose();
    _riveFile?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _riveFile == null
              ? const SizedBox()
              : RiveWidget(controller: _controller!),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            ratingValue,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
        )
      ],
    );
  }
}

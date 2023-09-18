import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:url_launcher/url_launcher.dart';

/// This example demonstrates how to open a URL from a Rive [RiveOpenUrlEvent]..
class EventOpenUrlButton extends StatefulWidget {
  const EventOpenUrlButton({super.key});

  @override
  State<EventOpenUrlButton> createState() => _EventOpenUrlButtonState();
}

class _EventOpenUrlButtonState extends State<EventOpenUrlButton> {
  late StateMachineController _controller;

  @override
  void initState() {
    super.initState();
  }

  void onInit(Artboard artboard) async {
    _controller = StateMachineController.fromArtboard(artboard, 'button')!;
    artboard.addController(_controller);

    _controller.addEventListener(onRiveEvent);
  }

  void onRiveEvent(RiveEvent event) {
    if (event is RiveOpenURLEvent) {
      try {
        final Uri url = Uri.parse(event.url);
        launchUrl(url);
      } on Exception catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  @override
  void dispose() {
    _controller.removeEventListener(onRiveEvent);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Open URL'),
      ),
      body: Column(
        children: [
          Expanded(
            child: RiveAnimation.asset(
              'assets/url_event_button.riv',
              onInit: onInit,
            ),
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Open URL: https://rive.app'),
            ),
          ),
        ],
      ),
    );
  }
}

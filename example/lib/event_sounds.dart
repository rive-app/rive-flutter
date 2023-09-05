import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:just_audio/just_audio.dart';

/// An example demonstrating a simple state machine.
///
/// The "bumpy" state machine will be activated on tap of the vehicle.
class EventSounds extends StatefulWidget {
  const EventSounds({Key? key}) : super(key: key);

  @override
  State<EventSounds> createState() => _EventSoundsState();
}

class _EventSoundsState extends State<EventSounds> {
  Future<void> _onRiveInit(Artboard artboard) async {
    final audioPlayer = AudioPlayer();
    await audioPlayer!.setAsset('assets/step.mp3');
    final controller =
        StateMachineController.fromArtboard(artboard, 'skill-controller');
    artboard.addController(controller!);
    controller.addEventListener((event) {
      if (event.name == 'Step') {
        audioPlayer.stop();
        audioPlayer.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Sounds'),
      ),
      body: Stack(
        children: [
          Center(
            child: RiveAnimation.asset(
              'assets/event_sounds.riv',
              fit: BoxFit.cover,
              onInit: _onRiveInit,
            ),
          ),
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Sound on!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

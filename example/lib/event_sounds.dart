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
  final _audioPlayer = AudioPlayer();
  late final StateMachineController _controller;

  @override
  void initState() {
    super.initState();
    _audioPlayer.setAsset('assets/step.mp3');
  }

  Future<void> _onRiveInit(Artboard artboard) async {
    _controller =
        StateMachineController.fromArtboard(artboard, 'skill-controller')!;
    artboard.addController(_controller);
    _controller.addEventListener(onRiveEvent);
  }

  void onRiveEvent(RiveEvent event) {
    // Seconds since the event was triggered and it being reported.
    // This can be used to scrub the audio forward to the precise locaiton
    // if needed.
    // ignore: unused_local_variable
    var seconds = event.secondsDelay;

    if (event.name == 'Step') {
      _audioPlayer.seek(Duration.zero);
      _audioPlayer.play();
    }
  }

  @override
  void dispose() {
    _controller.removeEventListener(onRiveEvent);
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
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

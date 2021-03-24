import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skill Level',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
          ),
        ),
      ),
      home: const SkillLevel(),
    );
  }
}

class SkillLevel extends StatefulWidget {
  const SkillLevel({Key? key}) : super(key: key);

  @override
  _SkillLevelState createState() => _SkillLevelState();
}

class _SkillLevelState extends State<SkillLevel> {
  /// Tracks if the animation is playing by whether controller is running.
  bool get isPlaying => _controller?.isActive ?? false;

  Artboard? _riveArtboard;
  StateMachineController? _controller;
  StateMachineInput<double>? _levelInput;

  @override
  void initState() {
    super.initState();

    // Load the animation file from the bundle, note that you could also
    // download this. The RiveFile just expects a list of bytes.
    rootBundle.load('assets/skills.riv').then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);

        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;
        var controller =
            StateMachineController.fromArtboard(artboard, 'Designer\'s Test');
        if (controller != null) {
          artboard.addController(controller);
          _levelInput = controller.findInput('Level');
          _levelInput?.value = 0;
        }
        setState(() => _riveArtboard = artboard);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var selectedStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
    );
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text('Skill Level'),
      ),
      body: _riveArtboard == null
          ? const SizedBox()
          : Stack(
              children: [
                Positioned.fill(
                  child: Rive(
                    artboard: _riveArtboard!,
                  ),
                ),
                Positioned(
                  bottom: 100,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: _levelInput?.value == 0 ? selectedStyle : null,
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('Begginer'),
                        ),
                        onPressed: () => setState(
                          () {
                            _levelInput?.value = 0;
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      TextButton(
                        style: _levelInput?.value == 1 ? selectedStyle : null,
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('Intermediate'),
                        ),
                        onPressed: () => setState(
                          () {
                            _levelInput?.value = 1;
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      TextButton(
                        style: _levelInput?.value == 2 ? selectedStyle : null,
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('Expert'),
                        ),
                        onPressed: () => setState(
                          () {
                            _levelInput?.value = 2;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' as rive;
import 'package:rive_example/advanced/centaur_example/centaur_game.dart';

class CentaurGameWidget extends StatefulWidget {
  const CentaurGameWidget({super.key});

  @override
  State<CentaurGameWidget> createState() => _CentaurGameWidgetState();
}

class _CentaurGameWidgetState extends State<CentaurGameWidget> {
  final rive.RenderTexture _renderTexture =
      rive.RiveNative.instance.makeRenderTexture();
  CentaurGame? _centaurPainter;

  @override
  void initState() {
    super.initState();

    load();
  }

  Future<void> load() async {
    var data = await rootBundle.load('assets/centaur_v2.riv');
    var bytes = data.buffer.asUint8List();
    var file = await rive.File.decode(bytes, riveFactory: rive.Factory.rive);
    if (file != null) {
      setState(() {
        _centaurPainter = CentaurGame(file);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _centaurPainter?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Centaur Game')),
        body: ColoredBox(
          color: const Color(0xFF507FBA),
          child: Center(
            child: _centaurPainter == null
                ? const SizedBox()
                : Focus(
                    focusNode: FocusNode(
                      canRequestFocus: true,
                      onKeyEvent: (node, event) {
                        if (event is KeyRepeatEvent) {
                          return KeyEventResult.handled;
                        }
                        double speed = 0;
                        if (event is KeyDownEvent) {
                          speed = 1;
                        } else if (event is KeyUpEvent) {
                          speed = -1;
                        }
                        if (event.logicalKey == LogicalKeyboardKey.keyA) {
                          _centaurPainter!.move -= speed;
                        } else if (event.logicalKey ==
                            LogicalKeyboardKey.keyD) {
                          _centaurPainter!.move += speed;
                        }
                        return KeyEventResult.handled;
                      },
                    )..requestFocus(),
                    child: MouseRegion(
                      onHover: (event) =>
                          _centaurPainter!.aimAt(event.localPosition),
                      child: Listener(
                        behavior: HitTestBehavior.opaque,
                        onPointerDown: _centaurPainter!.pointerDown,
                        onPointerMove: (event) =>
                            _centaurPainter!.aimAt(event.localPosition),
                        child: _renderTexture.widget(
                          painter: _centaurPainter!,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

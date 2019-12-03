library rive;

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class Rive extends StatelessWidget {
  final String filename;
  final String animation;

  const Rive({Key key, this.filename, this.animation}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlareActor(filename, animation: animation);
  }
}

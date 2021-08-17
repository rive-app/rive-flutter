import 'dart:collection';

import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/rive_core/backboard.dart';
import 'package:rive/src/rive_core/nested_artboard.dart';
import 'package:rive/src/runtime_nested_artboard.dart';

class BackboardImporter extends ImportStackObject {
  final Backboard backboard;

  final HashMap<int, Artboard> artboardLookup;
  final Set<NestedArtboard> nestedArtboards = {};
  BackboardImporter(this.artboardLookup, this.backboard);

  void addArtboard(Artboard object) {}
  void addNestedArtboard(NestedArtboard nestedArtboard) =>
      nestedArtboards.add(nestedArtboard);

  @override
  bool resolve() {
    for (final nestedArtboard in nestedArtboards) {
      var artboard = artboardLookup[nestedArtboard.artboardId];

      if (artboard is RuntimeArtboard) {
        (nestedArtboard as RuntimeNestedArtboard).sourceArtboard = artboard;
      }
    }
    return super.resolve();
  }
}

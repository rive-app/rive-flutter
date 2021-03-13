import 'dart:async';

import 'package:rive/src/rive_core/artboard.dart';

/// An abstract class for classes used to load [Artboard]s.
abstract class ArtboardProvider {
  /// Loads an [Artboard] with the given [artboardName].
  ///
  /// If the [artboardName] is `null` or omitted, loads the main animation
  /// [Artboard].
  FutureOr<Artboard> load({
    String artboardName,
  });
}

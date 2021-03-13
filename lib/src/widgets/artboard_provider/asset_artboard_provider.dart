import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:rive/rive.dart';
import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/widgets/artboard_provider/artboard_provider.dart';

/// An [ArtboardProvider] that allows loading [Artboard]s from [AssetBundle]s.
class AssetArtboardProvider implements ArtboardProvider {
  /// A name of the animation asset to load.
  final String assetName;

  /// A collection of the assets to load the animation from.
  ///
  /// By default, equals to [rootBundle].
  final AssetBundle bundle;

  /// Creates a new instance of the [AssetArtboardProvider] with the given [key]
  /// and [bundle].
  ///
  /// The [key] must not be `null`.
  ///
  /// Throws an [AssertionError] if the given [key] is `null`.
  AssetArtboardProvider({
    @required this.assetName,
    AssetBundle bundle,
  })  : assert(assetName != null),
        bundle = bundle ?? rootBundle;

  @override
  FutureOr<Artboard> load({
    String artboardName,
  }) async {
    final assetBytes = await bundle.load(assetName);

    final riveFile = RiveFile();
    riveFile.import(assetBytes);

    if (artboardName == null) return riveFile.mainArtboard;

    return riveFile.artboardByName(artboardName);
  }
}

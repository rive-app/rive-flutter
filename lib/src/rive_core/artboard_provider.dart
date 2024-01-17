import 'package:rive/src/rive_core/artboard.dart';

abstract class ArtboardProvider<T extends RiveCoreContext>
    extends ArtboardProviderBase<T> {
  Artboard? get artboard;
}

import 'package:rive/src/generated/audio_event_base.dart';
import 'package:rive/src/rive_core/artboard.dart';

export 'package:rive/src/generated/audio_event_base.dart';

class AudioEvent extends AudioEventBase {
  @override
  void changeArtboard(Artboard? value) {
    artboard?.internalRemoveEvent(this);
    super.changeArtboard(value);
    artboard?.internalAddEvent(this);
  }

  @override
  void assetIdChanged(int from, int to) {}
}

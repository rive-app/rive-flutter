import 'package:rive/src/generated/event_base.dart';
import 'package:rive/src/rive_core/artboard.dart';

export 'package:rive/src/generated/event_base.dart';

class Event extends EventBase {
  @override
  void typeChanged(String from, String to) {}

  @override
  void update(int dirt) {}

  @override
  void changeArtboard(Artboard? value) {
    artboard?.internalRemoveEvent(this);
    super.changeArtboard(value);
    artboard?.internalAddEvent(this);
  }
}

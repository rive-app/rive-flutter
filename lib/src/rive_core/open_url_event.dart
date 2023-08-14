import 'package:rive/src/generated/open_url_event_base.dart';
import 'package:rive/src/rive_core/artboard.dart';

export 'package:rive/src/generated/open_url_event_base.dart';

enum OpenUrlTarget { blank, parent, self, top }

class OpenUrlEvent extends OpenUrlEventBase {
  @override
  void update(int dirt) {}

  @override
  void changeArtboard(Artboard? value) {
    artboard?.internalRemoveEvent(this);
    super.changeArtboard(value);
    artboard?.internalAddEvent(this);
  }

  @override
  void targetValueChanged(int from, int to) {}

  @override
  void urlChanged(String from, String to) {}

  OpenUrlTarget get target => OpenUrlTarget.values[targetValue];
  set target(OpenUrlTarget value) => targetValue = value.index;
}

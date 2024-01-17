import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/text/text_value_run_base.dart';
import 'package:rive/src/rive_core/container_component.dart';
import 'package:rive/src/rive_core/text/text.dart';
import 'package:rive/src/rive_core/text/text_style.dart';

export 'package:rive/src/generated/text/text_value_run_base.dart';

class TextValueRun extends TextValueRunBase {
  Text? get textComponent => parent as Text?;

  TextStyle? _style;
  TextStyle? get style => _style;
  set style(TextStyle? value) {
    if (_style == value) {
      return;
    }

    _style?.deref(this);
    _style = value;
    styleId = value?.id ?? Core.missingId;
    _style?.ref(this);
  }

  /// Returns the offset of this run within the text.
  int get offset {
    var text = textComponent;
    if (text == null) {
      return 0;
    }
    int value = 0;
    for (final run in text.runs) {
      if (run == this) {
        break;
      }
      value += run.text.length;
    }
    return value;
  }

  void markShapeDirty() => textComponent?.markShapeDirty();

  @override
  void onAdded() {}

  @override
  void styleIdChanged(int from, int to) {
    style = context.resolve(to);
  }

  @override
  void onRemoved() {
    super.onRemoved();
    _style?.deref(this);
  }

  @override
  void onAddedDirty() {
    super.onAddedDirty();
    style = context.resolve(styleId);
  }

  @override
  void update(int dirt) {}

  @override
  void textChanged(String from, String to) => textComponent?.markShapeDirty();
}

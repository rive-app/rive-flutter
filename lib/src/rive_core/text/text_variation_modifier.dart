import 'dart:collection';

import 'package:rive/src/generated/text/text_variation_modifier_base.dart';
import 'package:rive/src/rive_core/text/text.dart';
import 'package:rive_common/rive_text.dart';

export 'package:rive/src/generated/text/text_variation_modifier_base.dart';

class TextVariationModifier extends TextVariationModifierBase {
  String get tagName => FontTag.tagToName(axisTag);

  @override
  void axisTagChanged(int from, int to) =>
      modifierGroup?.textComponent?.markShapeDirty();

  @override
  void axisValueChanged(double from, double to) =>
      modifierGroup?.textComponent?.markShapeDirty();

  @override
  void update(int dirt) {}

  @override
  double modify(Text text, Font font, HashMap<int, double> variations,
      double fontSize, double strength) {
    var fromValue = variations[axisTag] ?? font.axisValue(axisTag);
    variations[axisTag] = fromValue * (1 - strength) + axisValue * strength;

    return fontSize;
  }
}

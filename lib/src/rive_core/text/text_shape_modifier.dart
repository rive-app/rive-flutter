import 'dart:collection';

import 'package:rive/src/generated/text/text_shape_modifier_base.dart';
import 'package:rive/src/rive_core/text/text.dart';
import 'package:rive_common/rive_text.dart';

export 'package:rive/src/generated/text/text_shape_modifier_base.dart';

abstract class TextShapeModifier extends TextShapeModifierBase {
  double modify(Text text, Font font, HashMap<int, double> variations,
      double fontSize, double strength);
}

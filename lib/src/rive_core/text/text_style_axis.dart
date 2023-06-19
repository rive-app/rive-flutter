import 'package:rive/src/generated/text/text_style_axis_base.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/text/text_style.dart';
import 'package:rive_common/rive_text.dart';

export 'package:rive/src/generated/text/text_style_axis_base.dart';

class TextStyleAxis extends TextStyleAxisBase {
  @override
  bool validate() => super.validate() && parent is TextStyle;

  String get tagName => FontAxis.tagToName(tag);

  @override
  void update(int dirt) {}

  @override
  void axisValueChanged(double from, double to) {
    parent?.addDirt(ComponentDirt.textShape);
  }

  @override
  void tagChanged(int from, int to) => parent?.addDirt(ComponentDirt.textShape);
}

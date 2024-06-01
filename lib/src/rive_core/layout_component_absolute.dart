import 'package:rive/src/generated/layout_component_absolute_base.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/layout_component.dart';

export 'package:rive/src/generated/layout_component_absolute_base.dart';

enum ConstraintType {
  left,
  top,
  right,
  bottom,
  leftRight,
  topBottom,
  scale;

  static const hoirzontalOptions = [left, right, leftRight, scale];
  static const verticalOptions = [top, bottom, topBottom, scale];

  bool get containsLeft =>
      [ConstraintType.left, ConstraintType.leftRight].contains(this);

  bool get containsRight =>
      [ConstraintType.right, ConstraintType.leftRight].contains(this);

  bool get containsTop =>
      [ConstraintType.top, ConstraintType.topBottom].contains(this);

  bool get containsBottom =>
      [ConstraintType.bottom, ConstraintType.topBottom].contains(this);

  String get label {
    switch (this) {
      case leftRight:
        return 'Left + Right';
      case topBottom:
        return 'Top + Bottom';
      default:
        return name[0].toUpperCase() + name.substring(1);
    }
  }
}

class AbsoluteLayoutComponent extends AbsoluteLayoutComponentBase {
  LayoutComponent get defaultCell =>
      children.whereType<LayoutComponent>().first;

  @override
  bool isValidParent(Component parent) =>
      parent is LayoutComponent && parent is! AbsoluteLayoutComponent;
}

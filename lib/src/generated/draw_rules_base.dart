// Core automatically generated lib/src/generated/draw_rules_base.dart.
// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/rive_core/container_component.dart';

const _coreTypes = {
  DrawRulesBase.typeKey,
  ContainerComponentBase.typeKey,
  ComponentBase.typeKey
};

abstract class DrawRulesBase extends ContainerComponent {
  static const int typeKey = 49;
  @override
  int get coreType => DrawRulesBase.typeKey;
  @override
  Set<int> get coreTypes => _coreTypes;

  /// --------------------------------------------------------------------------
  /// DrawTargetId field with key 121.
  static const int drawTargetIdPropertyKey = 121;
  static const int drawTargetIdInitialValue = -1;

  @nonVirtual
  int drawTargetId_ = drawTargetIdInitialValue;

  /// Id of the DrawTarget that is currently active for this set of rules.
  @nonVirtual
  int get drawTargetId => drawTargetId_;

  /// Change the [drawTargetId_] field value.
  /// [drawTargetIdChanged] will be invoked only if the field's value has
  /// changed.
  set drawTargetId(int value) {
    if (drawTargetId_ == value) {
      return;
    }
    int from = drawTargetId_;
    drawTargetId_ = value;
    if (hasValidated) {
      drawTargetIdChanged(from, value);
    }
  }

  void drawTargetIdChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is DrawRulesBase) {
      drawTargetId_ = source.drawTargetId_;
    }
  }
}

/// Core automatically generated lib/src/generated/draw_rules_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/rive_core/container_component.dart';

abstract class DrawRulesBase extends ContainerComponent {
  static const int typeKey = 49;
  @override
  int get coreType => DrawRulesBase.typeKey;
  @override
  Set<int> get coreTypes => {
        DrawRulesBase.typeKey,
        ContainerComponentBase.typeKey,
        ComponentBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// DrawTargetId field with key 121.
  static const int drawTargetIdInitialValue = -1;
  int _drawTargetId = drawTargetIdInitialValue;
  static const int drawTargetIdPropertyKey = 121;

  /// Id of the DrawTarget that is currently active for this set of rules.
  int get drawTargetId => _drawTargetId;

  /// Change the [_drawTargetId] field value.
  /// [drawTargetIdChanged] will be invoked only if the field's value has
  /// changed.
  set drawTargetId(int value) {
    if (_drawTargetId == value) {
      return;
    }
    int from = _drawTargetId;
    _drawTargetId = value;
    if (hasValidated) {
      drawTargetIdChanged(from, value);
    }
  }

  void drawTargetIdChanged(int from, int to);

  @override
  void copy(covariant DrawRulesBase source) {
    super.copy(source);
    _drawTargetId = source._drawTargetId;
  }
}

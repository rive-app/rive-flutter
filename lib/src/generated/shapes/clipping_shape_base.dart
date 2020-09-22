/// Core automatically generated
/// lib/src/generated/shapes/clipping_shape_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/rive_core/component.dart';

abstract class ClippingShapeBase extends Component {
  static const int typeKey = 42;
  @override
  int get coreType => ClippingShapeBase.typeKey;
  @override
  Set<int> get coreTypes => {ClippingShapeBase.typeKey, ComponentBase.typeKey};

  /// --------------------------------------------------------------------------
  /// SourceId field with key 92.
  int _sourceId;
  static const int sourceIdPropertyKey = 92;

  /// Identifier used to track the node to use as a clipping source.
  int get sourceId => _sourceId;

  /// Change the [_sourceId] field value.
  /// [sourceIdChanged] will be invoked only if the field's value has changed.
  set sourceId(int value) {
    if (_sourceId == value) {
      return;
    }
    int from = _sourceId;
    _sourceId = value;
    sourceIdChanged(from, value);
  }

  void sourceIdChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// FillRule field with key 93.
  int _fillRule = 0;
  static const int fillRulePropertyKey = 93;

  /// Backing enum value for the clipping fill rule (nonZero or evenOdd).
  int get fillRule => _fillRule;

  /// Change the [_fillRule] field value.
  /// [fillRuleChanged] will be invoked only if the field's value has changed.
  set fillRule(int value) {
    if (_fillRule == value) {
      return;
    }
    int from = _fillRule;
    _fillRule = value;
    fillRuleChanged(from, value);
  }

  void fillRuleChanged(int from, int to);

  /// --------------------------------------------------------------------------
  /// IsVisible field with key 94.
  bool _isVisible = true;
  static const int isVisiblePropertyKey = 94;
  bool get isVisible => _isVisible;

  /// Change the [_isVisible] field value.
  /// [isVisibleChanged] will be invoked only if the field's value has changed.
  set isVisible(bool value) {
    if (_isVisible == value) {
      return;
    }
    bool from = _isVisible;
    _isVisible = value;
    isVisibleChanged(from, value);
  }

  void isVisibleChanged(bool from, bool to);
}

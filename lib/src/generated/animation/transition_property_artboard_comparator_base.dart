// Core automatically generated
// nullnull
// t.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/transition_comparator_base.dart';
import 'package:rive/src/rive_core/animation/transition_property_comparator.dart';

abstract class TransitionPropertyArtboardComparatorBase
    extends TransitionPropertyComparator {
  static const int typeKey = 496;
  @override
  int get coreType => TransitionPropertyArtboardComparatorBase.typeKey;
  @override
  Set<int> get coreTypes => {
        TransitionPropertyArtboardComparatorBase.typeKey,
        TransitionPropertyComparatorBase.typeKey,
        TransitionComparatorBase.typeKey
      };

  /// --------------------------------------------------------------------------
  /// PropertyType field with key 677.
  static const int propertyTypePropertyKey = 677;
  static const int propertyTypeInitialValue = 0;
  int _propertyType = propertyTypeInitialValue;

  /// Integer representation of the artboard's property used for condition
  int get propertyType => _propertyType;

  /// Change the [_propertyType] field value.
  /// [propertyTypeChanged] will be invoked only if the field's value has
  /// changed.
  set propertyType(int value) {
    if (_propertyType == value) {
      return;
    }
    int from = _propertyType;
    _propertyType = value;
    if (hasValidated) {
      propertyTypeChanged(from, value);
    }
  }

  void propertyTypeChanged(int from, int to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is TransitionPropertyArtboardComparatorBase) {
      _propertyType = source._propertyType;
    }
  }
}

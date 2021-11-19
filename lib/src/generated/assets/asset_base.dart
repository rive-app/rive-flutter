/// Core automatically generated lib/src/generated/assets/asset_base.dart.
/// Do not modify manually.

import 'package:rive/src/core/core.dart';

abstract class AssetBase<T extends CoreContext> extends Core<T> {
  static const int typeKey = 99;
  @override
  int get coreType => AssetBase.typeKey;
  @override
  Set<int> get coreTypes => {AssetBase.typeKey};

  /// --------------------------------------------------------------------------
  /// Name field with key 203.
  static const String nameInitialValue = '';
  String _name = nameInitialValue;
  static const int namePropertyKey = 203;

  /// Name of the asset
  String get name => _name;

  /// Change the [_name] field value.
  /// [nameChanged] will be invoked only if the field's value has changed.
  set name(String value) {
    if (_name == value) {
      return;
    }
    String from = _name;
    _name = value;
    if (hasValidated) {
      nameChanged(from, value);
    }
  }

  void nameChanged(String from, String to);

  @override
  void copy(covariant AssetBase source) {
    _name = source._name;
  }
}

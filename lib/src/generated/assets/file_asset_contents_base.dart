/// Core automatically generated
/// lib/src/generated/assets/file_asset_contents_base.dart.
/// Do not modify manually.

import 'package:rive/src/core/core.dart';

abstract class FileAssetContentsBase<T extends CoreContext> extends Core<T> {
  static const int typeKey = 106;
  @override
  int get coreType => FileAssetContentsBase.typeKey;
  @override
  Set<int> get coreTypes => {FileAssetContentsBase.typeKey};

  /// --------------------------------------------------------------------------
  /// Bytes field with key 212.
  static const List<int> bytesInitialValue = [];
  List<int> _bytes = bytesInitialValue;
  static const int bytesPropertyKey = 212;

  /// Byte data of the file.
  List<int> get bytes => _bytes;

  /// Change the [_bytes] field value.
  /// [bytesChanged] will be invoked only if the field's value has changed.
  set bytes(List<int> value) {
    if (_bytes == value) {
      return;
    }
    List<int> from = _bytes;
    _bytes = value;
    if (hasValidated) {
      bytesChanged(from, value);
    }
  }

  void bytesChanged(List<int> from, List<int> to);

  @override
  void copy(covariant FileAssetContentsBase source) {
    _bytes = source._bytes;
  }
}

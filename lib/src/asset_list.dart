import 'dart:collection';

import 'package:rive/src/rive_core/assets/asset.dart';

// List of assets used by the backboard.
class AssetList extends ListBase<Asset> {
  final List<Asset?> _values = [];
  List<Asset> get values => _values.cast<Asset>();

  @override
  int get length => _values.length;

  @override
  set length(int value) => _values.length = value;

  @override
  Asset operator [](int index) => _values[index]!;

  @override
  void operator []=(int index, Asset value) => _values[index] = value;
}

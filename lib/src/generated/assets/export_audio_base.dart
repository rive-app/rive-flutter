// Core automatically generated
// lib/src/generated/assets/export_audio_base.dart.
// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/assets/asset_base.dart';
import 'package:rive/src/rive_core/assets/file_asset.dart';

abstract class ExportAudioBase extends FileAsset {
  static const int typeKey = 422;
  @override
  int get coreType => ExportAudioBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {ExportAudioBase.typeKey, FileAssetBase.typeKey, AssetBase.typeKey};

  /// --------------------------------------------------------------------------
  /// Volume field with key 530.
  static const int volumePropertyKey = 530;
  static const double volumeInitialValue = 1;
  double _volume = volumeInitialValue;

  /// Volume applied to all instances of this audio asset.
  double get volume => _volume;

  /// Change the [_volume] field value.
  /// [volumeChanged] will be invoked only if the field's value has changed.
  set volume(double value) {
    if (_volume == value) {
      return;
    }
    double from = _volume;
    _volume = value;
    if (hasValidated) {
      volumeChanged(from, value);
    }
  }

  void volumeChanged(double from, double to);

  @override
  void copy(Core source) {
    super.copy(source);
    if (source is ExportAudioBase) {
      _volume = source._volume;
    }
  }
}

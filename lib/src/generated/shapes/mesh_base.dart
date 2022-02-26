/// Core automatically generated lib/src/generated/shapes/mesh_base.dart.
/// Do not modify manually.

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/rive_core/container_component.dart';

abstract class MeshBase extends ContainerComponent {
  static const int typeKey = 109;
  @override
  int get coreType => MeshBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {MeshBase.typeKey, ContainerComponentBase.typeKey, ComponentBase.typeKey};

  /// --------------------------------------------------------------------------
  /// TriangleIndexBytes field with key 223.
  static final Uint8List triangleIndexBytesInitialValue = Uint8List(0);
  Uint8List _triangleIndexBytes = triangleIndexBytesInitialValue;
  static const int triangleIndexBytesPropertyKey = 223;

  /// Byte data for the triangle indices.
  Uint8List get triangleIndexBytes => _triangleIndexBytes;

  /// Change the [_triangleIndexBytes] field value.
  /// [triangleIndexBytesChanged] will be invoked only if the field's value has
  /// changed.
  set triangleIndexBytes(Uint8List value) {
    if (listEquals(_triangleIndexBytes, value)) {
      return;
    }
    Uint8List from = _triangleIndexBytes;
    _triangleIndexBytes = value;
    if (hasValidated) {
      triangleIndexBytesChanged(from, value);
    }
  }

  void triangleIndexBytesChanged(Uint8List from, Uint8List to);

  @override
  void copy(covariant MeshBase source) {
    super.copy(source);
    _triangleIndexBytes = source._triangleIndexBytes;
  }
}

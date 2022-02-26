import 'package:rive/src/generated/shapes/mesh_vertex_base.dart';
import 'package:rive/src/rive_core/node.dart';
import 'package:rive/src/rive_core/shapes/mesh.dart';
import 'package:rive/src/rive_core/transform_component.dart';

export 'package:rive/src/generated/shapes/mesh_vertex_base.dart';

class MeshVertex extends MeshVertexBase {
  Mesh? get mesh => parent as Mesh?;

  @override
  TransformComponent get transformComponent =>
      mesh?.transformComponent ?? Node();

  @override
  bool validate() => super.validate() && parent is Mesh;

  @override
  void markGeometryDirty() => mesh?.markDrawableDirty();

  @override
  void uChanged(double from, double to) {}

  @override
  void vChanged(double from, double to) {}
}

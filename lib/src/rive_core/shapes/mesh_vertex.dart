import 'package:rive/src/generated/shapes/mesh_vertex_base.dart';
import 'package:rive/src/rive_core/shapes/mesh.dart';

export 'package:rive/src/generated/shapes/mesh_vertex_base.dart';

class MeshVertex extends MeshVertexBase {
  Mesh? get mesh => parent as Mesh?;

  @override
  bool validate() => super.validate() && parent is Mesh;

  @override
  void markGeometryDirty() => mesh?.markDrawableDirty();

  @override
  void uChanged(double from, double to) {}

  @override
  void vChanged(double from, double to) {}
}

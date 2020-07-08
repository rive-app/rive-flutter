import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/shapes/path_vertex.dart';
import 'package:rive/src/generated/shapes/points_path_base.dart';
export 'package:rive/src/generated/shapes/points_path_base.dart';

enum PointsPathEditMode { off, creating, editing }

class PointsPath extends PointsPathBase {
  final List<PathVertex> _vertices = [];
  PointsPath() {
    isClosed = false;
  }
  @override
  Mat2D get pathTransform => worldTransform;
  @override
  Mat2D get inversePathTransform => inverseWorldTransform;
  @override
  List<PathVertex> get vertices => _vertices;
  @override
  void childAdded(Component child) {
    super.childAdded(child);
    if (child is PathVertex && !_vertices.contains(child)) {
      _vertices.add(child);
      markPathDirty();
      addDirt(ComponentDirt.vertices);
    }
  }

  @override
  void childRemoved(Component child) {
    super.childRemoved(child);
    if (child is PathVertex && _vertices.remove(child)) {
      markPathDirty();
    }
  }

  @override
  void isClosedChanged(bool from, bool to) {
    markPathDirty();
  }
}

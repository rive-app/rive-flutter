import 'package:rive/src/generated/shapes/points_path_base.dart';
import 'package:rive/src/rive_core/bones/skinnable.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/shapes/path_vertex.dart';

export 'package:rive/src/generated/shapes/points_path_base.dart';

class PointsPath extends PointsPathBase with Skinnable<PathVertex> {
  final List<PathVertex> _vertices = [];

  PointsPath() {
    isClosed = false;
  }

  // When bound to bones pathTransform should be the identity as it'll already
  // be in world space.
  @override
  Mat2D get pathTransform => skin != null ? Mat2D.identity : worldTransform;

  // When bound to bones inversePathTransform should be the identity.
  @override
  Mat2D get inversePathTransform =>
      skin != null ? Mat2D() : inverseWorldTransform;

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

  @override
  void buildDependencies() {
    super.buildDependencies();

    // Depend on the skin, if we have it. This works because the skin is not a
    // node so we have no dependency on our parent yet (which would cause a
    // dependency cycle).
    skin?.addDependent(this);
  }

  @override
  void markPathDirty() {
    // Make sure the skin gets marked dirty too.
    skin?.addDirt(ComponentDirt.path);
    super.markPathDirty();
  }

  @override
  void markSkinDirty() => super.markPathDirty();

  @override
  void update(int dirt) {
    if (dirt & ComponentDirt.path != 0) {
      // Before calling super (which will build the path) make sure to deform
      // things if necessary. We depend on the skin which assures us that the
      // boneTransforms are up to date.
      skin?.deform(_vertices);
    }
    // Finally call super.update so the path commands can actually be rebuilt
    // (when ComponentDirt.path is set).
    super.update(dirt);
  }
}

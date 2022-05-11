import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:rive/src/generated/shapes/mesh_base.dart';
import 'package:rive/src/rive_core/bones/skinnable.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/drawable.dart';
import 'package:rive/src/rive_core/math/aabb.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/shapes/contour_mesh_vertex.dart';
import 'package:rive/src/rive_core/shapes/image.dart';
import 'package:rive/src/rive_core/shapes/mesh_vertex.dart';
import 'package:rive/src/rive_core/transform_component.dart';
import 'package:rive/src/utilities/binary_buffer/binary_reader.dart';

export 'package:rive/src/generated/shapes/mesh_base.dart';

class Mesh extends MeshBase with Skinnable<MeshVertex> {
  // When bound to bones pathTransform should be the identity as it'll already
  // be in world space.

  final List<MeshVertex> _vertices = [];

  List<MeshVertex> get vertices => _vertices;

  ui.Vertices? _uiVertices;
  Uint16List _triangleIndices = Uint16List(0);
  Uint16List get triangleIndices => _triangleIndices;

  int get contourVertexCount {
    int i = 0;
    while (i < _vertices.length && _vertices[i] is ContourMeshVertex) {
      i++;
    }
    return i;
  }

  bool get isValid => _uiVertices != null;

  bool get draws {
    return isValid;
  }

  TransformComponent get transformComponent => parent as Image;
  Drawable get drawable => parent as Drawable;

  @override
  bool validate() =>
      super.validate() &&
      parent is TransformComponent &&
      _areTriangleIndicesValid();

  bool _areTriangleIndicesValid() {
    var maxIndex = vertices.length;
    if (triangleIndices.length % 3 != 0) {
      return false;
    }
    for (final index in triangleIndices) {
      if (index >= maxIndex) {
        return false;
      }
    }

    return true;
  }

  @override
  void childAdded(Component child) {
    super.childAdded(child);
    if (child is MeshVertex && !_vertices.contains(child)) {
      _vertices.add(child);
    }
  }

  void markDrawableDirty() => addDirt(ComponentDirt.vertices);

  @override
  void childRemoved(Component child) {
    super.childRemoved(child);
    if (child is MeshVertex) {
      _vertices.remove(child);
    }
  }

  @override
  void buildDependencies() {
    super.buildDependencies();
    parent?.addDependent(this);
    skin?.addDependent(this);
  }

  AABB bounds = AABB.empty();

  @override
  void update(int dirt) {
    if (dirt & ComponentDirt.vertices != 0) {
      skin?.deform(_vertices);

      bounds = AABB.empty();
      var vertices = <ui.Offset>[];
      var uv = <ui.Offset>[];
      for (final vertex in _vertices) {
        var point = vertex.renderTranslation;

        vertices.add(ui.Offset(point.x, point.y));
        bounds.expandToPoint(point);
        uv.add(ui.Offset(vertex.u, vertex.v));
      }
      if (_triangleIndices.isEmpty) {
        _uiVertices = null;
      } else {
        _uiVertices = ui.Vertices(
          ui.VertexMode.triangles,
          vertices,
          textureCoordinates: uv,
          indices: _triangleIndices,
        );
      }
    }
  }

  void draw(ui.Canvas canvas, ui.Paint paint) {
    assert(_uiVertices != null);
    canvas.drawVertices(_uiVertices!, ui.BlendMode.srcOver, paint);
  }

  void _deserializeTriangleIndices() {
    var reader = BinaryReader.fromList(triangleIndexBytes);
    List<int> triangles = [];
    while (!reader.isEOF) {
      triangles.add(reader.readVarUint());
    }
    _triangleIndices = Uint16List.fromList(triangles);

    markDrawableDirty();
  }

  @override
  void onAddedDirty() {
    super.onAddedDirty();

    _deserializeTriangleIndices();
  }

  @override
  void markSkinDirty() => addDirt(ComponentDirt.vertices);

  Mat2D get worldTransform =>
      skin != null ? Mat2D.identity : transformComponent.worldTransform;

  @override
  void triangleIndexBytesChanged(List<int> from, List<int> to) =>
      _deserializeTriangleIndices();
}

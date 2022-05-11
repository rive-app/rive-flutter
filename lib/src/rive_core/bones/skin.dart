import 'dart:typed_data';

import 'package:rive/src/generated/bones/skin_base.dart';
import 'package:rive/src/rive_core/bones/bone.dart';
import 'package:rive/src/rive_core/bones/skinnable.dart';
import 'package:rive/src/rive_core/bones/tendon.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/shapes/vertex.dart';

export 'package:rive/src/generated/bones/skin_base.dart';

/// Represents a skin deformation of either a Path or an Image Mesh connected to
/// a set of bones.
class Skin extends SkinBase {
  final List<Tendon> _tendons = [];
  List<Tendon> get tendons => _tendons;
  Float32List _boneTransforms = Float32List(0);
  final Mat2D _worldTransform = Mat2D();

  @override
  void onDirty(int mask) {
    // When the skin is dirty the deformed skinnable will need to regenerate its
    // drawing commands.
    if (parent is Skinnable) {
      (parent as Skinnable).markSkinDirty();
    }
  }

  @override
  void update(int dirt) {
    // Any dirt here indicates that the transforms needs to be rebuilt. This
    // should only be worldTransform from the bones (recursively passed down) or
    // ComponentDirt.path from the PointsPath (set explicitly).
    var size = (_tendons.length + 1) * 6;

    if (_boneTransforms.length != size) {
      _boneTransforms = Float32List(size);
      _boneTransforms[0] = 1;
      _boneTransforms[1] = 0;
      _boneTransforms[2] = 0;
      _boneTransforms[3] = 1;
      _boneTransforms[4] = 0;
      _boneTransforms[5] = 0;
    }

    var temp = Mat2D();
    var bidx = 6;
    for (final tendon in _tendons) {
      if (tendon.bone == null) {
        continue;
      }
      var boneWorld = tendon.bone!.worldTransform;
      var wt = Mat2D.multiply(temp, boneWorld, tendon.inverseBind);
      _boneTransforms[bidx++] = wt[0];
      _boneTransforms[bidx++] = wt[1];
      _boneTransforms[bidx++] = wt[2];
      _boneTransforms[bidx++] = wt[3];
      _boneTransforms[bidx++] = wt[4];
      _boneTransforms[bidx++] = wt[5];
    }
  }

  void deform(List<Vertex> vertices) {
    for (final vertex in vertices) {
      vertex.deform(_worldTransform, _boneTransforms);
    }
  }

  @override
  void onAddedDirty() {
    super.onAddedDirty();
    if (parent is Skinnable) {
      (parent as Skinnable).addSkin(this);
      parent!.markRebuildDependencies();
    }
    _worldTransform[0] = xx;
    _worldTransform[1] = xy;
    _worldTransform[2] = yx;
    _worldTransform[3] = yy;
    _worldTransform[4] = tx;
    _worldTransform[5] = ty;
  }

  @override
  void onRemoved() {
    if (parent is Skinnable) {
      (parent as Skinnable).removeSkin(this);
      parent!.markRebuildDependencies();
    }
    super.onRemoved();
  }

  @override
  void buildDependencies() {
    super.buildDependencies();
    // A skin depends on all its bones. N.B. that we don't depend on the parent
    // skinnable. The skinnable depends on us.
    for (final tendon in _tendons) {
      var bone = tendon.bone;
      if (bone == null) {
        continue;
      }
      bone.addDependent(this);
      if (bone is Bone) {
        for (final childConstraint in bone.peerConstraints) {
          childConstraint.constrainedComponent?.addDependent(this);
        }
      }
    }
  }

  @override
  void childAdded(Component child) {
    super.childAdded(child);
    switch (child.coreType) {
      case TendonBase.typeKey:
        _tendons.add(child as Tendon);
        // Add dirt to recompute stored _boneTransforms
        addDirt(ComponentDirt.worldTransform);
        markRebuildDependencies();
        if (parent is Skinnable) {
          parent!.markRebuildDependencies();
        }
        break;
    }
  }

  @override
  void childRemoved(Component child) {
    super.childRemoved(child);
    switch (child.coreType) {
      case TendonBase.typeKey:
        _tendons.remove(child as Tendon);
        if (_tendons.isEmpty) {
          remove();
        } else {
          // Add dirt to recompute stored _boneTransforms
          addDirt(ComponentDirt.worldTransform);
          markRebuildDependencies();
        }
        parent?.markRebuildDependencies();

        break;
    }
  }

  @override
  void txChanged(double from, double to) {
    _worldTransform[4] = to;
  }

  @override
  void tyChanged(double from, double to) {
    _worldTransform[5] = to;
  }

  @override
  void xxChanged(double from, double to) {
    _worldTransform[0] = to;
  }

  @override
  void xyChanged(double from, double to) {
    _worldTransform[1] = to;
  }

  @override
  void yxChanged(double from, double to) {
    _worldTransform[2] = to;
  }

  @override
  void yyChanged(double from, double to) {
    _worldTransform[3] = to;
  }
}

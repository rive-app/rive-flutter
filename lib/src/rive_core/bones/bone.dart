import 'package:rive/src/generated/bones/bone_base.dart';
import 'package:rive/src/rive_core/constraints/constraint.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';

export 'package:rive/src/generated/bones/bone_base.dart';

typedef bool BoneCallback(Bone bone);

class Bone extends BoneBase {
  /// Child constraints applied to some child of this bone which also affect
  /// this bone.
  final Set<Constraint> _peerConstraints = {};
  Iterable<Constraint> get peerConstraints => _peerConstraints;

  bool addPeerConstraint(Constraint child) => _peerConstraints.add(child);
  bool removePeerConstraint(Constraint child) => _peerConstraints.remove(child);

  @override
  void lengthChanged(double from, double to) {
    for (final child in children) {
      if (child.coreType == BoneBase.typeKey) {
        (child as Bone).markTransformDirty();
      }
    }
  }

  Bone? get firstChildBone {
    for (final child in children) {
      if (child.coreType == BoneBase.typeKey) {
        return child as Bone;
      }
    }
    return null;
  }

  /// Iterate through the child bones. [BoneCallback] returns false if iteration
  /// can stop. Returns false if iteration stopped, true if it made it through
  /// the whole list.
  bool forEachBone(BoneCallback callback) {
    for (final child in children) {
      if (child.coreType == BoneBase.typeKey) {
        if (!callback(child as Bone)) {
          return false;
        }
      }
    }
    return true;
  }

  @override
  double get x => (parent as Bone).length;

  @override
  set x(double value) {
    throw UnsupportedError('not expected to set x on a bone.');
  }

  @override
  double get y => 0;

  @override
  set y(double value) {
    throw UnsupportedError('not expected to set y on a bone.');
  }

  @override
  bool validate() {
    // Bones are only valid if they're parented to other bones. RootBones are a
    // special case, but they inherit from bone so we check the concrete type
    // here to make sure we evalute this check only for non-root bones.
    return super.validate() && (coreType != BoneBase.typeKey || parent is Bone);
  }

  Vec2D get tipWorldTranslation => getTipWorldTranslation(worldTransform);

  Vec2D getTipWorldTranslation(Mat2D worldTransform) {
    return worldTransform.mapXY(length, 0);
  }
}

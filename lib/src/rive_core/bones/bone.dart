import 'package:rive/src/generated/bones/bone_base.dart';
export 'package:rive/src/generated/bones/bone_base.dart';

typedef bool BoneCallback(Bone bone);

class Bone extends BoneBase {
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
}

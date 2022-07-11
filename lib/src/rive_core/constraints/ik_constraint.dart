import 'dart:math';

import 'package:rive/src/generated/constraints/ik_constraint_base.dart';
import 'package:rive/src/rive_core/bones/bone.dart';
import 'package:rive/src/rive_core/constraints/constraint.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/math/transform_components.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';
import 'package:rive/src/rive_core/transform_component.dart';

export 'package:rive/src/generated/constraints/ik_constraint_base.dart';

/// A constraint which rotates its constrained bone and the parentBoneCount
/// bones above it in order to move the tip of the constrained bone towards the
/// target.
class IKConstraint extends IKConstraintBase {
  @override
  void invertDirectionChanged(bool from, bool to) => markConstraintDirty();

  @override
  void parentBoneCountChanged(int from, int to) {}

  @override
  void markConstraintDirty() {
    super.markConstraintDirty();

    // We automatically propagate dirt to the parent constrained bone, but we
    // also need to make sure the other bones we influence above it rebuild
    // their transforms.
    for (int i = 0; i < _fkChain.length - 1; i++) {
      _fkChain[i].bone.markTransformDirty();
    }
  }

  /// The list of bones in FK order.
  final List<_BoneChainLink> _fkChain = [];
  Iterable<_BoneChainLink> get fkChain => _fkChain;

  @override
  void onAdded() {
    super.onAdded();
    _buildFKChain();
  }

  @override
  void onRemoved() {
    _clearFKChain();

    super.onRemoved();
  }

  void _clearFKChain() {
    for (final link in _fkChain) {
      link.bone.markRebuildDependencies();
      link.bone.removePeerConstraint(this);
    }
    _fkChain.clear();
  }

  bool _buildFKChain() {
    var nextFKChain = <_BoneChainLink>[];
    var boneCount = parentBoneCount;
    var bone = parent as Bone;
    var bones = <Bone>[bone];
    // Get the reverse FK chain of bones (from tip up).
    while (bone.parent is Bone && boneCount > 0) {
      boneCount--;
      bone = bone.parent as Bone;
      bones.add(bone);
    }
    // Now put them in FK order (top to bottom).
    for (final bone in bones.reversed) {
      nextFKChain.add(_BoneChainLink(
        index: nextFKChain.length,
        bone: bone,
      ));
    }

    _clearFKChain();

    _fkChain.addAll(nextFKChain);
    for (final link in _fkChain) {
      link.bone.markRebuildDependencies();
      link.bone.addPeerConstraint(this);
    }
    markRebuildDependencies();
    return true;
  }

  @override
  void buildDependencies() {
    super.buildDependencies();

    // Make sure all of the first level children of each bone depend on the
    // tip (constrainedComponent).
    var tip = parent as Bone;

    var bones = _fkChain.reversed.map((link) => link.bone).toSet();
    for (final bone in bones.skip(1)) {
      for (final child in bone.children) {
        if (child is TransformComponent && !bones.contains(child)) {
          tip.addDependent(child, via: this);
        }
      }
    }
  }

  @override
  bool validate() => super.validate() && parent is Bone;

  @override
  void constrain(TransformComponent component) {
    if (target == null) {
      return;
    }

    var worldTargetTranslation = target!.worldTranslation;
    // Decompose the chain.
    for (final item in _fkChain) {
      var bone = item.bone;
      Mat2D parentWorldTransform = parentWorld(bone);

      Mat2D.invert(item.parentWorldInverse, parentWorldTransform);

      var boneTransform = bone.transform;
      Mat2D.multiply(
          boneTransform, item.parentWorldInverse, bone.worldTransform);
      Mat2D.decompose(boneTransform, item.transformComponents);
    }

    switch (_fkChain.length) {
      case 1:
        solve1(_fkChain.first, worldTargetTranslation);
        break;
      case 2:
        solve2(_fkChain[0], _fkChain[1], worldTargetTranslation);
        break;
      default:
        {
          var last = _fkChain.length - 1;
          var tip = _fkChain[last];
          for (int i = 0; i < last; i++) {
            var item = _fkChain[i];
            solve2(item, tip, worldTargetTranslation);
            for (int j = item.index + 1, end = _fkChain.length - 1;
                j < end;
                j++) {
              var fk = _fkChain[j];
              Mat2D.invert(fk.parentWorldInverse, parentWorld(fk.bone));
            }
          }
          break;
        }
    }

    // At the end, mix the FK angle with the IK angle by strength
    if (strength != 1.0) {
      for (final fk in _fkChain) {
        var fromAngle = fk.transformComponents.rotation % (pi * 2);
        var toAngle = fk.angle % (pi * 2);
        var diff = toAngle - fromAngle;
        if (diff > pi) {
          diff -= pi * 2;
        } else if (diff < -pi) {
          diff += pi * 2;
        }
        var angle = fromAngle + diff * strength;
        _constrainRotation(fk, angle);
      }
    }
  }

  void solve1(_BoneChainLink fk1, Vec2D worldTargetTranslation) {
    Mat2D iworld = fk1.parentWorldInverse;
    var pA = fk1.bone.worldTranslation;
    var pBT = Vec2D.clone(worldTargetTranslation);

    // To target in worldspace
    var toTarget = pBT - pA;

    // Note this is directional, hence not transformMat2d
    Vec2D toTargetLocal = Vec2D.transformMat2(Vec2D(), toTarget, iworld);
    var r = toTargetLocal.atan2();

    _constrainRotation(fk1, r);
    fk1.angle = r;
  }

  void solve2(
      _BoneChainLink fk1, _BoneChainLink fk2, Vec2D worldTargetTranslation) {
    Bone b1 = fk1.bone;
    Bone b2 = fk2.bone;
    var firstChild = _fkChain[fk1.index + 1];

    var iworld = fk1.parentWorldInverse;

    var pA = b1.worldTranslation;
    var pC = firstChild.bone.worldTranslation;
    var pB = b2.tipWorldTranslation;
    var pBT = Vec2D.clone(worldTargetTranslation);

    pA.apply(iworld);
    pC.apply(iworld);
    pB.apply(iworld);
    pBT.apply(iworld);

    // http://mathworld.wolfram.com/LawofCosines.html

    var av = pB - pC;
    var a = av.length();

    var bv = pC - pA;
    var b = bv.length();

    var cv = pBT - pA;
    var c = cv.length();
    if (b == 0 || c == 0) {
      // Cannot solve, would cause divide by zero. Usually means one of the two
      // bones has a 0/0 scale.
      return;
    }
    var A = acos(max(-1, min(1, (-a * a + b * b + c * c) / (2 * b * c))));
    var C = acos(max(-1, min(1, (a * a + b * b - c * c) / (2 * a * b))));
    final cvAngle = cv.atan2();

    double r1, r2;
    if (b2.parent != b1) {
      var secondChild = _fkChain[fk1.index + 2];

      var secondChildWorldInverse = secondChild.parentWorldInverse;

      pC = firstChild.bone.worldTranslation;
      pB = b2.tipWorldTranslation;

      var avec = pB - pC;

      var avLocal = Vec2D.transformMat2(Vec2D(), avec, secondChildWorldInverse);
      var angleCorrection = -avLocal.atan2();

      if (invertDirection) {
        r1 = cvAngle - A;
        r2 = -C + pi + angleCorrection;
      } else {
        r1 = A + cvAngle;
        r2 = C - pi + angleCorrection;
      }
    } else if (invertDirection) {
      r1 = cvAngle - A;
      r2 = -C + pi;
    } else {
      r1 = A + cvAngle;
      r2 = C - pi;
    }
    _constrainRotation(fk1, r1);
    _constrainRotation(firstChild, r2);
    if (firstChild != fk2) {
      var bone = fk2.bone;
      Mat2D.multiply(bone.worldTransform, parentWorld(bone), bone.transform);
    }

    // Simple storage, need this for interpolation.
    fk1.angle = r1;
    firstChild.angle = r2;
  }
}

class _BoneChainLink {
  final int index;
  final Bone bone;
  double angle = 0;
  TransformComponents transformComponents = TransformComponents();
  Mat2D parentWorldInverse = Mat2D();

  _BoneChainLink({
    required this.index,
    required this.bone,
  });
}

void _constrainRotation(_BoneChainLink link, double rotation) {
  var bone = link.bone;
  Mat2D parentWorldTransform = parentWorld(bone);
  var boneTransform = bone.transform;
  if (rotation == 0) {
    Mat2D.setIdentity(boneTransform);
  } else {
    Mat2D.fromRotation(boneTransform, rotation);
  }
  var c = link.transformComponents;
  boneTransform[4] = c.x;
  boneTransform[5] = c.y;
  var scaleX = c.scaleX;
  var scaleY = c.scaleY;
  boneTransform[0] *= scaleX;
  boneTransform[1] *= scaleX;
  boneTransform[2] *= scaleY;
  boneTransform[3] *= scaleY;

  var skew = c.skew;
  if (skew != 0) {
    boneTransform[2] = boneTransform[0] * skew + boneTransform[2];
    boneTransform[3] = boneTransform[1] * skew + boneTransform[3];
  }
  Mat2D.multiply(bone.worldTransform, parentWorldTransform, boneTransform);
}

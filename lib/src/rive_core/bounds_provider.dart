import 'dart:ui';

import 'package:rive_common/math.dart';

// ignore: one_member_abstracts
abstract class BoundsProvider {
  AABB computeBounds(Mat2D toParent);
}

mixin Sizable {
  Size computeIntrinsicSize(Size min, Size max);
  void controlSize(Size size);
}

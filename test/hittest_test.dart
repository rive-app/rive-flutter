import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:rive/src/rive_core/math/aabb.dart';
import 'package:rive/src/rive_core/math/hit_test.dart' as HT;
import 'package:rive/src/rive_core/math/vec2d.dart';

// We compare the output of HitTester against analytic predicates.
// When we near an edge, we don't always get precisely what we expect
// (and *on* an edge, its not clear if we should "hit" it.
// To handle this in test, we allow the 'expected' value to return
// kEdgeCase, which means we will accept either result from the HitTester.
enum Fuzzy {
  kTrue,
  kFalse,
  kEdgeCase,
}

Fuzzy fromBool(bool b) {
  return b ? Fuzzy.kTrue : Fuzzy.kFalse;
}

void addRect(HT.HitTester ht, AABB rect) {
  ht.moveTo(rect.left, rect.top);
  ht.lineTo(rect.right, rect.top);
  ht.lineTo(rect.right, rect.bottom);
  ht.lineTo(rect.left, rect.bottom);
  ht.close();
}

// Circle of radius 64 centered at origin. This is pasted from our
// analytic circle logic.
void addCubicCircle(HT.HitTester ht) {
  ht.moveTo(0.0, -64.0);
  ht.cubicTo(35.346223989184, -64.0, 64.0, -35.346223989184, 64.0, 0.0);
  ht.cubicTo(64.0, 35.346223989184, 35.346223989184, 64.0, 0.0, 64.0);
  ht.cubicTo(-35.346223989184, 64.0, -64.0, 35.346223989184, -64.0, 0.0);
  ht.cubicTo(-64.0, -35.346223989184, -35.346223989184, -64.0, 0.0, -64.0);
}

typedef HitTestBuilder = void Function(HT.HitTester);
typedef HitTestChecker = Fuzzy Function(double x, double);

// Tests all of the pixel-centers inside 'domain' with optional margin
// (to make it easy to also test pixels outside the bounds). Takes
// two lambdas:
//     builder : to rebuild the hittester for each test
//     checker : to return the expected value for a given x,y
//
void doTest(AABB domain, HitTestBuilder builder, HitTestChecker checker,
    {int margin = 4}) {
  final y0 = domain.top.floor() - margin;
  final y1 = domain.bottom.ceil() - margin;
  final x0 = domain.left.floor() + margin;
  final x1 = domain.right.ceil() + margin;
  for (int y = y0; y < y1; ++y) {
    for (int x = x0; x < x1; ++x) {
      final area = IAABB(x, y, x + 1, y + 1);
      final ht = HT.HitTester(area);
      builder(ht);
      bool result = ht.test();
      final expected = checker(x + 0.5, y + 0.5);
      if (expected != Fuzzy.kEdgeCase) {
        expect(result, expected == Fuzzy.kTrue);
      }
    }
  }
}

void main() {
  test('rect', () {
    final rect = AABB.fromValues(-5, -5, 5, 5);

    doTest(rect, (ht) => addRect(ht, rect),
        (x, y) => fromBool(rect.contains(Vec2D.fromValues(x, y))));
  });

  test('cubic_circle', () {
    final rect = AABB.fromValues(-64, -64, 64, 64);

    doTest(rect, addCubicCircle, (x, y) {
      final radius = math.sqrt(x * x + y * y);
      if (radius <= 63) {
        return Fuzzy.kTrue;
      }
      if (radius >= 65) {
        return Fuzzy.kFalse;
      }
      return Fuzzy.kEdgeCase;
    });
  });
}

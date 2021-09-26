import 'package:rive/src/generated/bones/tendon_base.dart';
import 'package:rive/src/rive_core/bones/skeletal_component.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';

export 'package:rive/src/generated/bones/tendon_base.dart';

class Tendon extends TendonBase {
  final Mat2D _bind = Mat2D();
  Mat2D? _inverseBind;
  SkeletalComponent? _bone;
  SkeletalComponent? get bone => _bone;

  Mat2D get inverseBind {
    if (_inverseBind == null) {
      _inverseBind = Mat2D();
      Mat2D.invert(_inverseBind!, _bind);
    }
    return _inverseBind!;
  }

  @override
  void boneIdChanged(int from, int to) {
    // This never happens, or at least it should only happen prior to an
    // onAddedDirty call.
  }

  @override
  void onAddedDirty() {
    super.onAddedDirty();
    _bone = context.resolve(boneId);

    _bind[0] = xx;
    _bind[1] = xy;
    _bind[2] = yx;
    _bind[3] = yy;
    _bind[4] = tx;
    _bind[5] = ty;
  }

  @override
  void update(int dirt) {}

  @override
  void txChanged(double from, double to) {
    _bind[4] = to;
    _inverseBind = null;
  }

  @override
  void tyChanged(double from, double to) {
    _bind[5] = to;
    _inverseBind = null;
  }

  @override
  void xxChanged(double from, double to) {
    _bind[0] = to;
    _inverseBind = null;
  }

  @override
  void xyChanged(double from, double to) {
    _bind[1] = to;
    _inverseBind = null;
  }

  @override
  void yxChanged(double from, double to) {
    _bind[2] = to;
    _inverseBind = null;
  }

  @override
  void yyChanged(double from, double to) {
    _bind[3] = to;
    _inverseBind = null;
  }
}

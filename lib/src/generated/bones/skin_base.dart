/// Core automatically generated lib/src/generated/bones/skin_base.dart.
/// Do not modify manually.

import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/container_component_base.dart';
import 'package:rive/src/rive_core/container_component.dart';

abstract class SkinBase extends ContainerComponent {
  static const int typeKey = 43;
  @override
  int get coreType => SkinBase.typeKey;
  @override
  Set<int> get coreTypes =>
      {SkinBase.typeKey, ContainerComponentBase.typeKey, ComponentBase.typeKey};

  /// --------------------------------------------------------------------------
  /// Xx field with key 104.
  static const double xxInitialValue = 1;
  double _xx = xxInitialValue;
  static const int xxPropertyKey = 104;

  /// x component of x unit vector in the bind transform
  double get xx => _xx;

  /// Change the [_xx] field value.
  /// [xxChanged] will be invoked only if the field's value has changed.
  set xx(double value) {
    if (_xx == value) {
      return;
    }
    double from = _xx;
    _xx = value;
    if (hasValidated) {
      xxChanged(from, value);
    }
  }

  void xxChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// Yx field with key 105.
  static const double yxInitialValue = 0;
  double _yx = yxInitialValue;
  static const int yxPropertyKey = 105;

  /// y component of x unit vector in the bind transform
  double get yx => _yx;

  /// Change the [_yx] field value.
  /// [yxChanged] will be invoked only if the field's value has changed.
  set yx(double value) {
    if (_yx == value) {
      return;
    }
    double from = _yx;
    _yx = value;
    if (hasValidated) {
      yxChanged(from, value);
    }
  }

  void yxChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// Xy field with key 106.
  static const double xyInitialValue = 0;
  double _xy = xyInitialValue;
  static const int xyPropertyKey = 106;

  /// x component of y unit vector in the bind transform
  double get xy => _xy;

  /// Change the [_xy] field value.
  /// [xyChanged] will be invoked only if the field's value has changed.
  set xy(double value) {
    if (_xy == value) {
      return;
    }
    double from = _xy;
    _xy = value;
    if (hasValidated) {
      xyChanged(from, value);
    }
  }

  void xyChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// Yy field with key 107.
  static const double yyInitialValue = 1;
  double _yy = yyInitialValue;
  static const int yyPropertyKey = 107;

  /// y component of y unit vector in the bind transform
  double get yy => _yy;

  /// Change the [_yy] field value.
  /// [yyChanged] will be invoked only if the field's value has changed.
  set yy(double value) {
    if (_yy == value) {
      return;
    }
    double from = _yy;
    _yy = value;
    if (hasValidated) {
      yyChanged(from, value);
    }
  }

  void yyChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// Tx field with key 108.
  static const double txInitialValue = 0;
  double _tx = txInitialValue;
  static const int txPropertyKey = 108;

  /// x position component of the bind transform
  double get tx => _tx;

  /// Change the [_tx] field value.
  /// [txChanged] will be invoked only if the field's value has changed.
  set tx(double value) {
    if (_tx == value) {
      return;
    }
    double from = _tx;
    _tx = value;
    if (hasValidated) {
      txChanged(from, value);
    }
  }

  void txChanged(double from, double to);

  /// --------------------------------------------------------------------------
  /// Ty field with key 109.
  static const double tyInitialValue = 0;
  double _ty = tyInitialValue;
  static const int tyPropertyKey = 109;

  /// y position component of the bind transform
  double get ty => _ty;

  /// Change the [_ty] field value.
  /// [tyChanged] will be invoked only if the field's value has changed.
  set ty(double value) {
    if (_ty == value) {
      return;
    }
    double from = _ty;
    _ty = value;
    if (hasValidated) {
      tyChanged(from, value);
    }
  }

  void tyChanged(double from, double to);

  @override
  void copy(covariant SkinBase source) {
    super.copy(source);
    _xx = source._xx;
    _yx = source._yx;
    _xy = source._xy;
    _yy = source._yy;
    _tx = source._tx;
    _ty = source._ty;
  }
}

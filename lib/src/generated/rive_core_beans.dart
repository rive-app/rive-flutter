import 'package:collection/collection.dart';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/animation/interpolating_keyframe_base.dart';
import 'package:rive/src/generated/animation/keyframe_base.dart';
import 'package:rive/src/generated/animation/transition_input_condition_base.dart';
import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/shapes/vertex_base.dart';
import 'package:rive/src/generated/transform_component_base.dart';
import 'package:rive/src/generated/world_transform_component_base.dart';
import 'package:rive/src/rive_core/animation/keyed_object.dart';
import 'package:rive/src/rive_core/animation/keyed_property.dart';
import 'package:rive/src/rive_core/animation/keyframe_double.dart';
import 'package:rive/src/rive_core/constraints/distance_constraint.dart';
import 'package:rive/src/rive_core/draw_rules.dart';
import 'package:rive/src/rive_core/node.dart';
import 'package:rive/src/rive_core/shapes/cubic_asymmetric_vertex.dart';
import 'package:rive/src/rive_core/shapes/cubic_detached_vertex.dart';
import 'package:rive/src/rive_core/shapes/cubic_mirrored_vertex.dart';
import 'package:rive/src/rive_core/shapes/paint/gradient_stop.dart';
import 'package:rive/src/rive_core/shapes/paint/solid_color.dart';
import 'package:rive/src/rive_core/shapes/paint/stroke.dart';
import 'package:rive/src/rive_core/shapes/straight_vertex.dart';
import 'package:rive/src/rive_core/solo.dart';
import 'package:stokanal/logging.dart';

import '../core/field_types/core_field_type.dart';

class PropertyBean<T extends Core> {
  final int propertyKey;
  PropertyBean._(this.propertyKey);

  bool getBool(T o) => throw Exception();
  void setBool(T o, bool v) => throw Exception();

  double getDouble(T o) => throw Exception();
  void setDouble(T o, double v) => throw Exception();

  void transformDouble(T o, double Function(double) function) {
    setDouble(o, function(getDouble(o)));
  }

  void applyDouble(T o, double multiplier, double sum) {
    setDouble(o, getDouble(o) * multiplier + sum);
  }

  int getColor(T o) => throw Exception();
  void setColor(T o, int v) => throw Exception();

  int getUint(T o) => throw Exception();
  void setUint(T o, int v) => throw Exception();

  String getString(T o) => throw Exception();
  void setString(T o, String v) => throw Exception();

  void setObjectProperty(Core o, Object v) => throw Exception();

  CoreFieldType? get coreType => throw Exception();

  void setCallback(T o, CallbackData v) => throw Exception();
}

class _DoublePropertyBean<T extends Core> extends PropertyBean<T> {
  _DoublePropertyBean._(super.propertyKey): super._();

  @override
  @nonVirtual
  CoreFieldType? get coreType => RiveCoreContext.doubleType;

  @override
  void setObjectProperty(Core o, Object v) => o is T && v is double ? setDouble(o, v) : {};
}

// class DoublePropertyBean<T extends Core> extends _DoublePropertyBean<T> {
//
//   final double Function(T) getter;
//   final void Function(T, double) setter;
//   DoublePropertyBean._(super.propertyKey, this.getter, this.setter): super._();
//
//   @override
//   double getDouble(T o) => getter(o);
//
//   @override
//   void setDouble(T o, double v) => setter(o, v);
//
//   @override
//   void transformDouble(T o, double Function(double) function) =>
//     setter(o, function(getter(o)));
//
//   @override
//   void applyDouble(T o, double multiplier, double sum) =>
//       setter(o, getter(o) * multiplier + sum);
//
//   @override
//   void setObjectProperty(Core o, Object v) => o is T && v is double ? setter(o, v) : {};
// }

class _UintPropertyBean<T extends Core> extends PropertyBean<T> {
  _UintPropertyBean._(super.propertyKey): super._();

  @override
  @nonVirtual
  CoreFieldType? get coreType => RiveCoreContext.uintType;

  @override
  void setObjectProperty(Core o, Object v) => o is T && v is int ? setUint(o, v) : {};
}

class UintPropertyBean<T extends Core> extends _UintPropertyBean<T> {

  final int Function(T) getter;
  final void Function(T, int) setter;
  UintPropertyBean._(super.propertyKey, this.getter, this.setter): super._();

  @override
  int getUint(T o) => getter(o);

  @override
  void setUint(T o, int v) => setter(o, v);

  @override
  void setObjectProperty(Core o, Object v) => o is T && v is int ? setter(o, v) : {};

  // @override
  // CoreFieldType? get coreType => RiveCoreContext.uintType;
}

class ColorPropertyBean<T extends Core> extends PropertyBean<T> {

  final int Function(T) getter;
  final void Function(T, int) setter;
  ColorPropertyBean._(super.propertyKey, this.getter, this.setter): super._();

  @override
  int getColor(T o) => getter(o);

  @override
  void setColor(T o, int v) => setter(o, v);

  @override
  void setObjectProperty(Core o, Object v) => o is T && v is int ? setter(o, v) : {};

  @override
  CoreFieldType? get coreType => RiveCoreContext.colorType;
}

class StringPropertyBean<T extends Core> extends PropertyBean<T> {

  final String Function(T) getter;
  final void Function(T, String) setter;
  StringPropertyBean._(super.propertyKey, this.getter, this.setter): super._();

  @override
  String getString(T o) => getter(o);

  @override
  void setString(T o, String v) => setter(o, v);

  @override
  void setObjectProperty(Core o, Object v) => o is T && v is String ? setter(o, v) : {};

  @override
  CoreFieldType? get coreType => RiveCoreContext.stringType;
}

class FallbackBean extends PropertyBean {

  FallbackBean._(super.propertyKey):
    super._();

  // ignore: prefer_final_fields
  int _hits = 0;

  // uncomment me to dump stats
  // bool dumped = false;
  // int get hits => _hits;
  // set hits(int hits) {
  //   _hits = hits;
  //   if (_hits >= 1000 && !dumped) {
  //     dumped = true;
  //     PropertyBeans._dumpFallbacks();
  //   }
  // }

  @override
  bool getBool(Core o) {
    // hits++;
    return RiveCoreContext.getBool(o, propertyKey);
  }
  @override
  void setBool(Core o, bool v) {
    // hits++;
    RiveCoreContext.setBool(o, propertyKey, v);
  }

  @override
  double getDouble(Core o) {
    // hits++;
    return RiveCoreContext.getDouble(o, propertyKey);
  }
  @override
  void setDouble(Core o, double v) {
    // hits++;
    RiveCoreContext.setDouble(o, propertyKey, v);
  }

  @override
  int getColor(Core o) {
    // hits++;
    return RiveCoreContext.getColor(o, propertyKey);
  }
  @override
  void setColor(Core o, int v) {
    // hits++;
    RiveCoreContext.setColor(o, propertyKey, v);
  }

  @override
  int getUint(Core o) {
    // hits++;
    return RiveCoreContext.getUint(o, propertyKey);
  }
  @override
  void setUint(Core o, int v) {
    // hits++;
    RiveCoreContext.setUint(o, propertyKey, v);
  }

  @override
  String getString(Core o) {
    // hits++;
    return RiveCoreContext.getString(o, propertyKey);
  }
  @override
  void setString(Core o, String v) {
    // hits++;
    RiveCoreContext.setString(o, propertyKey, v);
  }

  @override
  void setObjectProperty(Core o, Object v) {
    // hits++;
    RiveCoreContext.setObjectProperty(o, propertyKey, v);
  }

  @override
  CoreFieldType? get coreType {
    // hits++;
    return RiveCoreContext.coreType(propertyKey);
  }

  @override
  void setCallback(Core o, CallbackData v) {
    // hits++;
    RiveCoreContext.setCallback(o, propertyKey, v);
  }

  @override
  String toString() => 'FallbackBean[$propertyKey, $_hits]';
}

// final _map = <int, PropertyBean>{};
final _list = List<PropertyBean?>.filled(1000, null); // use a list to map from property keys
final _invalid = PropertyBean._(CoreContext.invalidPropertyKey);
var _first = true;
final _implements = <PropertyBean>[
  _invalid,
  XBean._(),
  YBean._(),
  VertexBaseXBean._(),
  VertexBaseYBean._(),

  OutRotationBean._(),
  OutDistanceBean._(),
  InRotationBean._(),
  InDistanceBean._(),
  CubicAsymmetricVertexInDistanceBean._(),
  RotationBean._(),
  ScaleXBean._(),
  ScaleYBean._(),
  TransformComponentRotationBean._(),
  ValueBean._(),
  OpacityBean._(),

  CubicMirroredVertexBaseRotationBean._(),
  CubicAsymmetricVertexBaseOutDistanceBean._(),
  StraightVertexBaseRadiusBean._(),
  StrokeBaseThicknessBean._(),
  DistanceConstraintBaseDistanceBean._(),
  CubicMirroredVertexBaseDistanceBean._(),
  GradientStopBasePositionBean._(),

  UintPropertyBean<InterpolatingKeyFrameBase>._(InterpolatingKeyFrameBase.interpolatorIdPropertyKey, (o) => o.interpolatorId, (o, v) => o.interpolatorId = v),
  UintPropertyBean<KeyedPropertyBase>._(KeyedPropertyBase.propertyKeyPropertyKey, (o) => o.propertyKey, (o, v) => o.propertyKey = v),
  UintPropertyBean<KeyFrameBase>._(KeyFrameBase.framePropertyKey, (o) => o.frame, (o, v) => o.frame = v),
  UintPropertyBean<InterpolatingKeyFrameBase>._(InterpolatingKeyFrameBase.interpolationTypePropertyKey, (o) => o.interpolationType, (o, v) => o.interpolationType = v),
  UintPropertyBean<SoloBase>._(SoloBase.activeComponentIdPropertyKey, (o) => o.activeComponentId, (o, v) => o.activeComponentId = v),
  UintPropertyBean<KeyedObjectBase>._(KeyedObjectBase.objectIdPropertyKey, (o) => o.objectId, (o, v) => o.objectId = v),
  UintPropertyBean<DrawRulesBase>._(DrawRulesBase.drawTargetIdPropertyKey, (o) => o.drawTargetId, (o, v) => o.drawTargetId = v),
  UintPropertyBean<ComponentBase>._(ComponentBase.parentIdPropertyKey, (o) => o.parentId, (o, v) => o.parentId = v),
  UintPropertyBean<TransitionInputConditionBase>._(TransitionInputConditionBase.inputIdPropertyKey, (o) => o.inputId, (o, v) => o.inputId = v),

  StringPropertyBean<ComponentBase>._(ComponentBase.namePropertyKey, (o) => o.name, (o, v) => o.name = v),

  ColorPropertyBean<SolidColorBase>._(SolidColorBase.colorValuePropertyKey, (o) => o.colorValue, (o, v) => o.colorValue = v),
  ColorPropertyBean<GradientStopBase>._(GradientStopBase.colorValuePropertyKey, (o) => o.colorValue, (o, v) => o.colorValue = v),

];

// ignore: avoid_classes_with_only_static_members
abstract class PropertyBeans {

  static PropertyBean get invalid => _invalid;

  static PropertyBean get(int propertyKey) {

    if (_first) {
      _first = false;
      // _implements.forEach((bean) => _map[bean.propertyKey] = bean);
      _implements.forEach((bean) => _list[bean.propertyKey] = bean);
    }

    // return _map.putIfAbsent(propertyKey, () => FallbackBean._(propertyKey));
    return _list[propertyKey] ?? (_list[propertyKey] = FallbackBean._(propertyKey));
  }

  // ignore: unused_element
  static void _dumpFallbacks() {
    info('\n${
        // _map.values
        _list.whereNotNull()
        .whereType<FallbackBean>().sorted((b1, b2) => b2._hits.compareTo(b1._hits)).map((b) => '$b').join('\n')}');
  }
}

/// See EntityMeta.java for the auto generator

class XBean extends _DoublePropertyBean<NodeBase> {
  XBean._(): super._(NodeBase.xPropertyKey);
  @override
  double getDouble(NodeBase o) => o.x_;
  @override
  void setDouble(NodeBase o, double v) => o.x = v;
  @override
  void transformDouble(NodeBase o, double Function(double) function) => o.x = function(o.x_);
  @override
  void applyDouble(NodeBase o, double multiplier, double sum) => o.x = o.x_ * multiplier + sum;
  @override
  void setObjectProperty(Core o, Object v) => o is NodeBase && v is double ? o.x = v : {};
}
class YBean extends _DoublePropertyBean<NodeBase> {
  YBean._(): super._(NodeBase.yPropertyKey);
  @override
  double getDouble(NodeBase o) => o.y_;
  @override
  void setDouble(NodeBase o, double v) => o.y = v;
  @override
  void transformDouble(NodeBase o, double Function(double) function) => o.y = function(o.y_);
  @override
  void applyDouble(NodeBase o, double multiplier, double sum) => o.y = o.y_ * multiplier + sum;
  @override
  void setObjectProperty(Core o, Object v) => o is NodeBase && v is double ? o.y = v : {};
}
class VertexBaseXBean extends _DoublePropertyBean<VertexBase> {
  VertexBaseXBean._(): super._(VertexBase.xPropertyKey);
  @override
  double getDouble(VertexBase o) => o.x_;
  @override
  void setDouble(VertexBase o, double v) => o.x = v;
  @override
  void transformDouble(VertexBase o, double Function(double) function) => o.x = function(o.x_);
  @override
  void applyDouble(VertexBase o, double multiplier, double sum) => o.x = o.x_ * multiplier + sum;
  @override
  void setObjectProperty(Core o, Object v) => o is VertexBase && v is double ? o.x = v : {};
}
class VertexBaseYBean extends _DoublePropertyBean<VertexBase> {
  VertexBaseYBean._(): super._(VertexBase.yPropertyKey);
  @override
  double getDouble(VertexBase o) => o.y_;
  @override
  void setDouble(VertexBase o, double v) => o.y = v;
  @override
  void transformDouble(VertexBase o, double Function(double) function) => o.y = function(o.y_);
  @override
  void applyDouble(VertexBase o, double multiplier, double sum) => o.y = o.y_ * multiplier + sum;
  @override
  void setObjectProperty(Core o, Object v) => o is VertexBase && v is double ? o.y = v : {};
}

// DoublePropertyBean<CubicDetachedVertexBase>._(CubicDetachedVertexBase.outRotationPropertyKey, (o) => o.outRotation_, (o, v) => o.outRotation = v),
class OutRotationBean extends _DoublePropertyBean<CubicDetachedVertexBase> {
  OutRotationBean._(): super._(CubicDetachedVertexBase.outRotationPropertyKey);
  @override
  double getDouble(CubicDetachedVertexBase o) => o.outRotation_;
  @override
  void setDouble(CubicDetachedVertexBase o, double v) => o.outRotation = v;
  @override
  void transformDouble(CubicDetachedVertexBase o, double Function(double) function) => o.outRotation = function(o.outRotation_);
  @override
  void applyDouble(CubicDetachedVertexBase o, double multiplier, double sum) => o.outRotation = o.outRotation_ * multiplier + sum;
  @override
  void setObjectProperty(Core o, Object v) => o is CubicDetachedVertexBase && v is double ? o.outRotation = v : {};
}

// DoublePropertyBean<CubicDetachedVertexBase>._(CubicDetachedVertexBase.outDistancePropertyKey, (o) => o.outDistance_, (o, v) => o.outDistance = v),
class OutDistanceBean extends _DoublePropertyBean<CubicDetachedVertexBase> {
  OutDistanceBean._(): super._(CubicDetachedVertexBase.outDistancePropertyKey);
  @override
  double getDouble(CubicDetachedVertexBase o) => o.outDistance_;
  @override
  void setDouble(CubicDetachedVertexBase o, double v) => o.outDistance = v;
  @override
  void transformDouble(CubicDetachedVertexBase o, double Function(double) function) => o.outDistance = function(o.outDistance_);
  @override
  void applyDouble(CubicDetachedVertexBase o, double multiplier, double sum) => o.outDistance = o.outDistance_ * multiplier + sum;
  @override
  void setObjectProperty(Core o, Object v) => o is CubicDetachedVertexBase && v is double ? o.outDistance = v : {};
}

// DoublePropertyBean<CubicDetachedVertexBase>._(CubicDetachedVertexBase.inRotationPropertyKey, (o) => o.inRotation_, (o, v) => o.inRotation = v),
class InRotationBean extends _DoublePropertyBean<CubicDetachedVertexBase> {
  InRotationBean._(): super._(CubicDetachedVertexBase.inRotationPropertyKey);
  @override
  double getDouble(CubicDetachedVertexBase o) => o.inRotation_;
  @override
  void setDouble(CubicDetachedVertexBase o, double v) => o.inRotation = v;
  @override
  void transformDouble(CubicDetachedVertexBase o, double Function(double) function) => o.inRotation = function(o.inRotation_);
  @override
  void applyDouble(CubicDetachedVertexBase o, double multiplier, double sum) => o.inRotation = o.inRotation_ * multiplier + sum;
  @override
  void setObjectProperty(Core o, Object v) => o is CubicDetachedVertexBase && v is double ? o.inRotation = v : {};
}

// DoublePropertyBean<CubicDetachedVertexBase>._(CubicDetachedVertexBase.inDistancePropertyKey, (o) => o.inDistance_, (o, v) => o.inDistance = v),
class InDistanceBean extends _DoublePropertyBean<CubicDetachedVertexBase> {
  InDistanceBean._(): super._(CubicDetachedVertexBase.inDistancePropertyKey);
  @override
  double getDouble(CubicDetachedVertexBase o) => o.inDistance_;
  @override
  void setDouble(CubicDetachedVertexBase o, double v) => o.inDistance = v;
  @override
  void transformDouble(CubicDetachedVertexBase o, double Function(double) function) => o.inDistance = function(o.inDistance_);
  @override
  void applyDouble(CubicDetachedVertexBase o, double multiplier, double sum) => o.inDistance = o.inDistance_ * multiplier + sum;
  @override
  void setObjectProperty(Core o, Object v) => o is CubicDetachedVertexBase && v is double ? o.inDistance = v : {};
}

// DoublePropertyBean<CubicAsymmetricVertexBase>._(CubicAsymmetricVertexBase.inDistancePropertyKey, (o) => o.inDistance_, (o, v) => o.inDistance = v),
class CubicAsymmetricVertexInDistanceBean extends _DoublePropertyBean<CubicAsymmetricVertexBase> {
  CubicAsymmetricVertexInDistanceBean._(): super._(CubicAsymmetricVertexBase.inDistancePropertyKey);
  @override
  double getDouble(CubicAsymmetricVertexBase o) => o.inDistance_;
  @override
  void setDouble(CubicAsymmetricVertexBase o, double v) => o.inDistance = v;
  @override
  void transformDouble(CubicAsymmetricVertexBase o, double Function(double) function) => o.inDistance = function(o.inDistance_);
  @override
  void applyDouble(CubicAsymmetricVertexBase o, double multiplier, double sum) => o.inDistance = o.inDistance_ * multiplier + sum;
  @override
  void setObjectProperty(Core o, Object v) => o is CubicAsymmetricVertexBase && v is double ? o.inDistance = v : {};
}

// DoublePropertyBean<CubicAsymmetricVertexBase>._(CubicAsymmetricVertexBase.rotationPropertyKey, (o) => o.rotation_, (o, v) => o.rotation = v),
class RotationBean extends _DoublePropertyBean<CubicAsymmetricVertexBase> {
  RotationBean._(): super._(CubicAsymmetricVertexBase.rotationPropertyKey);
  @override
  double getDouble(CubicAsymmetricVertexBase o) => o.rotation_;
  @override
  void setDouble(CubicAsymmetricVertexBase o, double v) => o.rotation = v;
  @override
  void transformDouble(CubicAsymmetricVertexBase o, double Function(double) function) => o.rotation = function(o.rotation_);
  @override
  void applyDouble(CubicAsymmetricVertexBase o, double multiplier, double sum) => o.rotation = o.rotation_ * multiplier + sum;
  @override
  void setObjectProperty(Core o, Object v) => o is CubicAsymmetricVertexBase && v is double ? o.rotation = v : {};
}

// DoublePropertyBean<TransformComponentBase>._(TransformComponentBase.scaleXPropertyKey, (o) => o.scaleX_, (o, v) => o.scaleX = v),
class ScaleXBean extends _DoublePropertyBean<TransformComponentBase> {
  ScaleXBean._(): super._(TransformComponentBase.scaleXPropertyKey);
  @override
  double getDouble(TransformComponentBase o) => o.scaleX_;
  @override
  void setDouble(TransformComponentBase o, double v) => o.scaleX = v;
  @override
  void transformDouble(TransformComponentBase o, double Function(double) function) => o.scaleX = function(o.scaleX_);
  @override
  void applyDouble(TransformComponentBase o, double multiplier, double sum) => o.scaleX = o.scaleX_ * multiplier + sum;
  @override
  void setObjectProperty(Core o, Object v) => o is TransformComponentBase && v is double ? o.scaleX = v : {};
}

// DoublePropertyBean<TransformComponentBase>._(TransformComponentBase.scaleYPropertyKey, (o) => o.scaleY_, (o, v) => o.scaleY = v),
class ScaleYBean extends _DoublePropertyBean<TransformComponentBase> {
  ScaleYBean._(): super._(TransformComponentBase.scaleYPropertyKey);
  @override
  double getDouble(TransformComponentBase o) => o.scaleY_;
  @override
  void setDouble(TransformComponentBase o, double v) => o.scaleY = v;
  @override
  void transformDouble(TransformComponentBase o, double Function(double) function) => o.scaleY = function(o.scaleY_);
  @override
  void applyDouble(TransformComponentBase o, double multiplier, double sum) => o.scaleY = o.scaleY_ * multiplier + sum;
  @override
  void setObjectProperty(Core o, Object v) => o is TransformComponentBase && v is double ? o.scaleY = v : {};
}

// DoublePropertyBean<TransformComponentBase>._(TransformComponentBase.rotationPropertyKey, (o) => o.rotation_, (o, v) => o.rotation = v),
class TransformComponentRotationBean extends _DoublePropertyBean<TransformComponentBase> {
  TransformComponentRotationBean._(): super._(TransformComponentBase.rotationPropertyKey);
  @override
  double getDouble(TransformComponentBase o) => o.rotation_;
  @override
  void setDouble(TransformComponentBase o, double v) => o.rotation = v;
  @override
  void transformDouble(TransformComponentBase o, double Function(double) function) => o.rotation = function(o.rotation_);
  @override
  void applyDouble(TransformComponentBase o, double multiplier, double sum) => o.rotation = o.rotation_ * multiplier + sum;
  @override
  void setObjectProperty(Core o, Object v) => o is TransformComponentBase && v is double ? o.rotation = v : {};
}

// DoublePropertyBean<KeyFrameDoubleBase>._(KeyFrameDoubleBase.valuePropertyKey, (o) => o.value, (o, v) => o.value = v),
class ValueBean extends _DoublePropertyBean<KeyFrameDoubleBase> {
  ValueBean._(): super._(KeyFrameDoubleBase.valuePropertyKey);
  @override
  double getDouble(KeyFrameDoubleBase o) => o.value;
  @override
  void setDouble(KeyFrameDoubleBase o, double v) => o.value = v;
  @override
  void transformDouble(KeyFrameDoubleBase o, double Function(double) function) => o.value = function(o.value);
  @override
  void applyDouble(KeyFrameDoubleBase o, double multiplier, double sum) => o.value = o.value * multiplier + sum;
  @override
  void setObjectProperty(Core o, Object v) => o is KeyFrameDoubleBase && v is double ? o.value = v : {};
}

// DoublePropertyBean<WorldTransformComponentBase>._(WorldTransformComponentBase.opacityPropertyKey, (o) => o.opacity_, (o, v) => o.opacity = v),
class OpacityBean extends _DoublePropertyBean<WorldTransformComponentBase> {
  OpacityBean._(): super._(WorldTransformComponentBase.opacityPropertyKey);
  @override
  double getDouble(WorldTransformComponentBase o) => o.opacity_;
  @override
  void setDouble(WorldTransformComponentBase o, double v) => o.opacity = v;
  @override
  void transformDouble(WorldTransformComponentBase o, double Function(double) function) => o.opacity = function(o.opacity_);
  @override
  void applyDouble(WorldTransformComponentBase o, double multiplier, double sum) => o.opacity = o.opacity_ * multiplier + sum;
  @override
  void setObjectProperty(Core o, Object v) => o is WorldTransformComponentBase && v is double ? o.opacity = v : {};
}

// DoublePropertyBean<CubicMirroredVertexBase>._(CubicMirroredVertexBase.rotationPropertyKey, (o) => o.rotation, (o, v) => o.rotation = v),
class CubicMirroredVertexBaseRotationBean extends _DoublePropertyBean<CubicMirroredVertexBase> {
  CubicMirroredVertexBaseRotationBean._(): super._(CubicMirroredVertexBase.rotationPropertyKey);
  @override
  double getDouble(CubicMirroredVertexBase o) => o.rotation_;
  @override
  void setDouble(CubicMirroredVertexBase o, double v) => o.rotation = v;
  @override
  void transformDouble(CubicMirroredVertexBase o, double Function(double) function) => o.rotation = function(o.rotation_);
  @override
  void applyDouble(CubicMirroredVertexBase o, double multiplier, double sum) => o.rotation = o.rotation_ * multiplier + sum;
  @override
  void setObjectProperty(Core o, Object v) => o is CubicMirroredVertexBase && v is double ? o.rotation = v : {};
}

// DoublePropertyBean<CubicAsymmetricVertexBase>._(CubicAsymmetricVertexBase.outDistancePropertyKey, (o) => o.outDistance, (o, v) => o.outDistance = v),
class CubicAsymmetricVertexBaseOutDistanceBean extends _DoublePropertyBean<CubicAsymmetricVertexBase> {
  CubicAsymmetricVertexBaseOutDistanceBean._(): super._(CubicAsymmetricVertexBase.outDistancePropertyKey);
  @override
  double getDouble(CubicAsymmetricVertexBase o) => o.outDistance_;
  @override
  void setDouble(CubicAsymmetricVertexBase o, double v) => o.outDistance = v;
  @override
  void transformDouble(CubicAsymmetricVertexBase o, double Function(double) function) => o.outDistance = function(o.outDistance_);
  @override
  void applyDouble(CubicAsymmetricVertexBase o, double multiplier, double sum) => o.outDistance = o.outDistance_ * multiplier + sum;
  @override
  void setObjectProperty(Core o, Object v) => o is CubicAsymmetricVertexBase && v is double ? o.outDistance = v : {};
}

// DoublePropertyBean<StraightVertexBase>._(StraightVertexBase.radiusPropertyKey, (o) => o.radius, (o, v) => o.radius = v),
class StraightVertexBaseRadiusBean extends _DoublePropertyBean<StraightVertexBase> {
  StraightVertexBaseRadiusBean._(): super._(StraightVertexBase.radiusPropertyKey);
  @override
  double getDouble(StraightVertexBase o) => o.radius_;
  @override
  void setDouble(StraightVertexBase o, double v) => o.radius = v;
  @override
  void transformDouble(StraightVertexBase o, double Function(double) function) => o.radius = function(o.radius_);
  @override
  void applyDouble(StraightVertexBase o, double multiplier, double sum) => o.radius = o.radius_ * multiplier + sum;
  @override
  void setObjectProperty(Core o, Object v) => o is StraightVertexBase && v is double ? o.radius = v : {};
}

// DoublePropertyBean<StrokeBase>._(StrokeBase.thicknessPropertyKey, (o) => o.thickness, (o, v) => o.thickness = v),
class StrokeBaseThicknessBean extends _DoublePropertyBean<StrokeBase> {
  StrokeBaseThicknessBean._(): super._(StrokeBase.thicknessPropertyKey);
  @override
  double getDouble(StrokeBase o) => o.thickness_;
  @override
  void setDouble(StrokeBase o, double v) => o.thickness = v;
  @override
  void transformDouble(StrokeBase o, double Function(double) function) => o.thickness = function(o.thickness_);
  @override
  void applyDouble(StrokeBase o, double multiplier, double sum) => o.thickness = o.thickness_ * multiplier + sum;
  @override
  void setObjectProperty(Core o, Object v) => o is StrokeBase && v is double ? o.thickness = v : {};
}

// DoublePropertyBean<DistanceConstraintBase>._(DistanceConstraintBase.distancePropertyKey, (o) => o.distance, (o, v) => o.distance = v),
class DistanceConstraintBaseDistanceBean extends _DoublePropertyBean<DistanceConstraintBase> {
  DistanceConstraintBaseDistanceBean._(): super._(DistanceConstraintBase.distancePropertyKey);
  @override
  double getDouble(DistanceConstraintBase o) => o.distance_;
  @override
  void setDouble(DistanceConstraintBase o, double v) => o.distance = v;
  @override
  void transformDouble(DistanceConstraintBase o, double Function(double) function) => o.distance = function(o.distance_);
  @override
  void applyDouble(DistanceConstraintBase o, double multiplier, double sum) => o.distance = o.distance_ * multiplier + sum;
  @override
  void setObjectProperty(Core o, Object v) => o is DistanceConstraintBase && v is double ? o.distance = v : {};
}

// DoublePropertyBean<CubicMirroredVertexBase>._(CubicMirroredVertexBase.distancePropertyKey, (o) => o.distance, (o, v) => o.distance = v),
class CubicMirroredVertexBaseDistanceBean extends _DoublePropertyBean<CubicMirroredVertexBase> {
  CubicMirroredVertexBaseDistanceBean._(): super._(CubicMirroredVertexBase.distancePropertyKey);
  @override
  double getDouble(CubicMirroredVertexBase o) => o.distance_;
  @override
  void setDouble(CubicMirroredVertexBase o, double v) => o.distance = v;
  @override
  void transformDouble(CubicMirroredVertexBase o, double Function(double) function) => o.distance = function(o.distance_);
  @override
  void applyDouble(CubicMirroredVertexBase o, double multiplier, double sum) => o.distance = o.distance_ * multiplier + sum;
  @override
  void setObjectProperty(Core o, Object v) => o is CubicMirroredVertexBase && v is double ? o.distance = v : {};
}

// DoublePropertyBean<GradientStopBase>._(GradientStopBase.positionPropertyKey, (o) => o.position, (o, v) => o.position = v),
class GradientStopBasePositionBean extends _DoublePropertyBean<GradientStopBase> {
  GradientStopBasePositionBean._(): super._(GradientStopBase.positionPropertyKey);
  @override
  double getDouble(GradientStopBase o) => o.position_;
  @override
  void setDouble(GradientStopBase o, double v) => o.position = v;
  @override
  void transformDouble(GradientStopBase o, double Function(double) function) => o.position = function(o.position_);
  @override
  void applyDouble(GradientStopBase o, double multiplier, double sum) => o.position = o.position_ * multiplier + sum;
  @override
  void setObjectProperty(Core o, Object v) => o is GradientStopBase && v is double ? o.position = v : {};
}


// TODO review accessors from here

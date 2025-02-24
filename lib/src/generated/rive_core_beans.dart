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
  void transformDouble(T o, double Function(double) function) =>
      setDouble(o, function(getDouble(o)));

  @override
  void setObjectProperty(Core o, Object v) => o is T && v is double ? setDouble(o, v) : {};
}

class DoublePropertyBean<T extends Core> extends _DoublePropertyBean<T> {

  final double Function(T) getter;
  final void Function(T, double) setter;
  DoublePropertyBean._(super.propertyKey, this.getter, this.setter): super._();

  @override
  double getDouble(T o) => getter(o);

  @override
  void setDouble(T o, double v) => setter(o, v);

  @override
  void transformDouble(T o, double Function(double) function) =>
    setter(o, function(getter(o)));

  @override
  void setObjectProperty(Core o, Object v) => o is T && v is double ? setter(o, v) : {};
}

class UintPropertyBean<T extends Core> extends PropertyBean<T> {

  final int Function(T) getter;
  final void Function(T, int) setter;
  UintPropertyBean._(super.propertyKey, this.getter, this.setter): super._();

  @override
  int getUint(T o) => getter(o);

  @override
  void setUint(T o, int v) => setter(o, v);

  @override
  void setObjectProperty(Core o, Object v) => o is T && v is int ? setter(o, v) : {};

  @override
  CoreFieldType? get coreType => RiveCoreContext.uintType;
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

final _map = <int, PropertyBean>{};
final _invalid = PropertyBean._(CoreContext.invalidPropertyKey);
var _first = true;
final _implements = <PropertyBean>[
  _invalid,
  XPropertyBean._(),
  YPropertyBean._(),
  VertexBaseXPropertyBean._(),
  VertexBaseYPropertyBean._(),
  // DoublePropertyBean<NodeBase>._(NodeBase.xPropertyKey, (o) => o.x_, (o, v) => o.x = v),
  // DoublePropertyBean<NodeBase>._(NodeBase.yPropertyKey, (o) => o.y_, (o, v) => o.y = v),
  // DoublePropertyBean<VertexBase>._(VertexBase.xPropertyKey, (o) => o.x_, (o, v) => o.x = v),
  // DoublePropertyBean<VertexBase>._(VertexBase.yPropertyKey, (o) => o.y_, (o, v) => o.y = v),
  DoublePropertyBean<CubicDetachedVertexBase>._(CubicDetachedVertexBase.outRotationPropertyKey, (o) => o.outRotation_, (o, v) => o.outRotation = v),
  DoublePropertyBean<CubicDetachedVertexBase>._(CubicDetachedVertexBase.outDistancePropertyKey, (o) => o.outDistance_, (o, v) => o.outDistance = v),
  DoublePropertyBean<CubicDetachedVertexBase>._(CubicDetachedVertexBase.inRotationPropertyKey, (o) => o.inRotation_, (o, v) => o.inRotation = v),
  DoublePropertyBean<CubicDetachedVertexBase>._(CubicDetachedVertexBase.inDistancePropertyKey, (o) => o.inDistance_, (o, v) => o.inDistance = v),
  DoublePropertyBean<CubicAsymmetricVertexBase>._(CubicAsymmetricVertexBase.inDistancePropertyKey, (o) => o.inDistance_, (o, v) => o.inDistance = v),
  DoublePropertyBean<CubicAsymmetricVertexBase>._(CubicAsymmetricVertexBase.rotationPropertyKey, (o) => o.rotation_, (o, v) => o.rotation = v),
  DoublePropertyBean<TransformComponentBase>._(TransformComponentBase.scaleXPropertyKey, (o) => o.scaleX, (o, v) => o.scaleX = v),
  DoublePropertyBean<TransformComponentBase>._(TransformComponentBase.scaleYPropertyKey, (o) => o.scaleY, (o, v) => o.scaleY = v),
  DoublePropertyBean<TransformComponentBase>._(TransformComponentBase.rotationPropertyKey, (o) => o.rotation, (o, v) => o.rotation = v),
  DoublePropertyBean<KeyFrameDoubleBase>._(KeyFrameDoubleBase.valuePropertyKey, (o) => o.value, (o, v) => o.value = v),
  DoublePropertyBean<WorldTransformComponentBase>._(WorldTransformComponentBase.opacityPropertyKey, (o) => o.opacity, (o, v) => o.opacity = v),
  UintPropertyBean<InterpolatingKeyFrameBase>._(InterpolatingKeyFrameBase.interpolatorIdPropertyKey, (o) => o.interpolatorId, (o, v) => o.interpolatorId = v),
  UintPropertyBean<KeyedPropertyBase>._(KeyedPropertyBase.propertyKeyPropertyKey, (o) => o.propertyKey, (o, v) => o.propertyKey = v),
  UintPropertyBean<KeyFrameBase>._(KeyFrameBase.framePropertyKey, (o) => o.frame, (o, v) => o.frame = v),
  DoublePropertyBean<CubicMirroredVertexBase>._(CubicMirroredVertexBase.rotationPropertyKey, (o) => o.rotation, (o, v) => o.rotation = v),
  UintPropertyBean<InterpolatingKeyFrameBase>._(InterpolatingKeyFrameBase.interpolationTypePropertyKey, (o) => o.interpolationType, (o, v) => o.interpolationType = v),
  UintPropertyBean<SoloBase>._(SoloBase.activeComponentIdPropertyKey, (o) => o.activeComponentId, (o, v) => o.activeComponentId = v),
  DoublePropertyBean<CubicAsymmetricVertexBase>._(CubicAsymmetricVertexBase.outDistancePropertyKey, (o) => o.outDistance, (o, v) => o.outDistance = v),
  UintPropertyBean<KeyedObjectBase>._(KeyedObjectBase.objectIdPropertyKey, (o) => o.objectId, (o, v) => o.objectId = v),
  DoublePropertyBean<StraightVertexBase>._(StraightVertexBase.radiusPropertyKey, (o) => o.radius, (o, v) => o.radius = v),
  UintPropertyBean<DrawRulesBase>._(DrawRulesBase.drawTargetIdPropertyKey, (o) => o.drawTargetId, (o, v) => o.drawTargetId = v),
  UintPropertyBean<ComponentBase>._(ComponentBase.parentIdPropertyKey, (o) => o.parentId, (o, v) => o.parentId = v),
  ColorPropertyBean<SolidColorBase>._(SolidColorBase.colorValuePropertyKey, (o) => o.colorValue, (o, v) => o.colorValue = v),
  StringPropertyBean<ComponentBase>._(ComponentBase.namePropertyKey, (o) => o.name, (o, v) => o.name = v),
  DoublePropertyBean<StrokeBase>._(StrokeBase.thicknessPropertyKey, (o) => o.thickness, (o, v) => o.thickness = v),
  DoublePropertyBean<DistanceConstraintBase>._(DistanceConstraintBase.distancePropertyKey, (o) => o.distance, (o, v) => o.distance = v),
  DoublePropertyBean<CubicMirroredVertexBase>._(CubicMirroredVertexBase.distancePropertyKey, (o) => o.distance, (o, v) => o.distance = v),
  DoublePropertyBean<GradientStopBase>._(GradientStopBase.positionPropertyKey, (o) => o.position, (o, v) => o.position = v),
  ColorPropertyBean<GradientStopBase>._(GradientStopBase.colorValuePropertyKey, (o) => o.colorValue, (o, v) => o.colorValue = v),
  UintPropertyBean<TransitionInputConditionBase>._(TransitionInputConditionBase.inputIdPropertyKey, (o) => o.inputId, (o, v) => o.inputId = v),
];

// ignore: avoid_classes_with_only_static_members
abstract class PropertyBeans {

  static PropertyBean get invalid => _invalid;

  static PropertyBean get(int propertyKey) {

    if (_first) {
      _first = false;
      _implements.forEach((bean) => _map[bean.propertyKey] = bean);
    }

    return _map.putIfAbsent(propertyKey, () => FallbackBean._(propertyKey));
  }

  // ignore: unused_element
  static void _dumpFallbacks() {
    info('\n${_map.values.whereType<FallbackBean>().sorted((b1, b2) => b2._hits.compareTo(b1._hits)).map((b) => '$b').join('\n')}');
  }
}

class XPropertyBean extends _DoublePropertyBean<NodeBase> {
  XPropertyBean._(): super._(NodeBase.xPropertyKey);
  @override
  double getDouble(NodeBase o) => o.x_;
  @override
  void setDouble(NodeBase o, double v) => o.x = v;
}
class YPropertyBean extends _DoublePropertyBean<NodeBase> {
  YPropertyBean._(): super._(NodeBase.yPropertyKey);
  @override
  double getDouble(NodeBase o) => o.y_;
  @override
  void setDouble(NodeBase o, double v) => o.y = v;
}

class VertexBaseXPropertyBean extends _DoublePropertyBean<VertexBase> {
  VertexBaseXPropertyBean._(): super._(VertexBase.xPropertyKey);
  @override
  double getDouble(VertexBase o) => o.x_;
  @override
  void setDouble(VertexBase o, double v) => o.x = v;
}
class VertexBaseYPropertyBean extends _DoublePropertyBean<VertexBase> {
  VertexBaseYPropertyBean._(): super._(VertexBase.yPropertyKey);
  @override
  double getDouble(VertexBase o) => o.y_;
  @override
  void setDouble(VertexBase o, double v) => o.y = v;
}

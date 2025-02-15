import 'package:collection/collection.dart';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/core/field_types/core_string_type.dart';
import 'package:rive/src/core/field_types/core_uint_type.dart';
import 'package:rive/src/generated/animation/advanceable_state_base.dart';
import 'package:rive/src/generated/animation/blend_animation_base.dart';
import 'package:rive/src/generated/animation/cubic_ease_interpolator_base.dart';
import 'package:rive/src/generated/animation/cubic_interpolator_base.dart';
import 'package:rive/src/generated/animation/interpolating_keyframe_base.dart';
import 'package:rive/src/generated/animation/keyframe_base.dart';
import 'package:rive/src/generated/animation/keyframe_string_base.dart';
import 'package:rive/src/generated/animation/layer_state_base.dart';
import 'package:rive/src/generated/animation/listener_input_change_base.dart';
import 'package:rive/src/generated/animation/nested_input_base.dart';
import 'package:rive/src/generated/animation/nested_linear_animation_base.dart';
import 'package:rive/src/generated/animation/state_machine_component_base.dart';
import 'package:rive/src/generated/animation/transition_input_condition_base.dart';
import 'package:rive/src/generated/animation/transition_value_condition_base.dart';
import 'package:rive/src/generated/assets/asset_base.dart';
import 'package:rive/src/generated/assets/drawable_asset_base.dart';
import 'package:rive/src/generated/assets/export_audio_base.dart';
import 'package:rive/src/generated/assets/file_asset_base.dart';
import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/constraints/constraint_base.dart';
import 'package:rive/src/generated/constraints/targeted_constraint_base.dart';
import 'package:rive/src/generated/constraints/transform_component_constraint_base.dart';
import 'package:rive/src/generated/constraints/transform_component_constraint_y_base.dart';
import 'package:rive/src/generated/constraints/transform_space_constraint_base.dart';
import 'package:rive/src/generated/data_bind/converters/data_converter_base.dart';
import 'package:rive/src/generated/drawable_base.dart';
import 'package:rive/src/generated/nested_animation_base.dart';
import 'package:rive/src/generated/shapes/paint/shape_paint_base.dart';
import 'package:rive/src/generated/shapes/parametric_path_base.dart';
import 'package:rive/src/generated/shapes/path_base.dart';
import 'package:rive/src/generated/shapes/vertex_base.dart';
import 'package:rive/src/generated/transform_component_base.dart';
import 'package:rive/src/generated/viewmodel/viewmodel_instance_value_base.dart';
import 'package:rive/src/generated/world_transform_component_base.dart';
import 'package:rive/src/rive_core/animation/animation.dart';
import 'package:rive/src/rive_core/animation/animation_state.dart';
import 'package:rive/src/rive_core/animation/any_state.dart';
import 'package:rive/src/rive_core/animation/blend_animation_1d.dart';
import 'package:rive/src/rive_core/animation/blend_animation_direct.dart';
import 'package:rive/src/rive_core/animation/blend_state_1d.dart';
import 'package:rive/src/rive_core/animation/blend_state_direct.dart';
import 'package:rive/src/rive_core/animation/blend_state_transition.dart';
import 'package:rive/src/rive_core/animation/cubic_ease_interpolator.dart';
import 'package:rive/src/rive_core/animation/cubic_interpolator_component.dart';
import 'package:rive/src/rive_core/animation/cubic_value_interpolator.dart';
import 'package:rive/src/rive_core/animation/elastic_interpolator.dart';
import 'package:rive/src/rive_core/animation/entry_state.dart';
import 'package:rive/src/rive_core/animation/exit_state.dart';
import 'package:rive/src/rive_core/animation/keyed_object.dart';
import 'package:rive/src/rive_core/animation/keyed_property.dart';
import 'package:rive/src/rive_core/animation/keyframe_bool.dart';
import 'package:rive/src/rive_core/animation/keyframe_callback.dart';
import 'package:rive/src/rive_core/animation/keyframe_color.dart';
import 'package:rive/src/rive_core/animation/keyframe_double.dart';
import 'package:rive/src/rive_core/animation/keyframe_id.dart';
import 'package:rive/src/rive_core/animation/keyframe_string.dart';
import 'package:rive/src/rive_core/animation/keyframe_uint.dart';
import 'package:rive/src/rive_core/animation/linear_animation.dart';
import 'package:rive/src/rive_core/animation/listener_align_target.dart';
import 'package:rive/src/rive_core/animation/listener_bool_change.dart';
import 'package:rive/src/rive_core/animation/listener_fire_event.dart';
import 'package:rive/src/rive_core/animation/listener_number_change.dart';
import 'package:rive/src/rive_core/animation/listener_trigger_change.dart';
import 'package:rive/src/rive_core/animation/listener_viewmodel_change.dart';
import 'package:rive/src/rive_core/animation/nested_bool.dart';
import 'package:rive/src/rive_core/animation/nested_number.dart';
import 'package:rive/src/rive_core/animation/nested_remap_animation.dart';
import 'package:rive/src/rive_core/animation/nested_simple_animation.dart';
import 'package:rive/src/rive_core/animation/nested_state_machine.dart';
import 'package:rive/src/rive_core/animation/nested_trigger.dart';
import 'package:rive/src/rive_core/animation/state_machine.dart';
import 'package:rive/src/rive_core/animation/state_machine_bool.dart';
import 'package:rive/src/rive_core/animation/state_machine_fire_event.dart';
import 'package:rive/src/rive_core/animation/state_machine_layer.dart';
import 'package:rive/src/rive_core/animation/state_machine_listener.dart';
import 'package:rive/src/rive_core/animation/state_machine_number.dart';
import 'package:rive/src/rive_core/animation/state_machine_trigger.dart';
import 'package:rive/src/rive_core/animation/state_transition.dart';
import 'package:rive/src/rive_core/animation/transition_bool_condition.dart';
import 'package:rive/src/rive_core/animation/transition_number_condition.dart';
import 'package:rive/src/rive_core/animation/transition_property_viewmodel_comparator.dart';
import 'package:rive/src/rive_core/animation/transition_trigger_condition.dart';
import 'package:rive/src/rive_core/animation/transition_value_boolean_comparator.dart';
import 'package:rive/src/rive_core/animation/transition_value_color_comparator.dart';
import 'package:rive/src/rive_core/animation/transition_value_enum_comparator.dart';
import 'package:rive/src/rive_core/animation/transition_value_number_comparator.dart';
import 'package:rive/src/rive_core/animation/transition_value_string_comparator.dart';
import 'package:rive/src/rive_core/animation/transition_viewmodel_condition.dart';
import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/rive_core/assets/audio_asset.dart';
import 'package:rive/src/rive_core/assets/file_asset_contents.dart';
import 'package:rive/src/rive_core/assets/folder.dart';
import 'package:rive/src/rive_core/assets/font_asset.dart';
import 'package:rive/src/rive_core/assets/image_asset.dart';
import 'package:rive/src/rive_core/audio_event.dart';
import 'package:rive/src/rive_core/backboard.dart';
import 'package:rive/src/rive_core/bones/bone.dart';
import 'package:rive/src/rive_core/bones/cubic_weight.dart';
import 'package:rive/src/rive_core/bones/root_bone.dart';
import 'package:rive/src/rive_core/bones/skin.dart';
import 'package:rive/src/rive_core/bones/tendon.dart';
import 'package:rive/src/rive_core/bones/weight.dart';
import 'package:rive/src/rive_core/constraints/distance_constraint.dart';
import 'package:rive/src/rive_core/constraints/follow_path_constraint.dart';
import 'package:rive/src/rive_core/constraints/ik_constraint.dart';
import 'package:rive/src/rive_core/constraints/rotation_constraint.dart';
import 'package:rive/src/rive_core/constraints/scale_constraint.dart';
import 'package:rive/src/rive_core/constraints/transform_constraint.dart';
import 'package:rive/src/rive_core/constraints/translation_constraint.dart';
import 'package:rive/src/rive_core/custom_property_boolean.dart';
import 'package:rive/src/rive_core/custom_property_number.dart';
import 'package:rive/src/rive_core/custom_property_string.dart';
import 'package:rive/src/rive_core/data_bind/bindable_property_boolean.dart';
import 'package:rive/src/rive_core/data_bind/bindable_property_color.dart';
import 'package:rive/src/rive_core/data_bind/bindable_property_enum.dart';
import 'package:rive/src/rive_core/data_bind/bindable_property_number.dart';
import 'package:rive/src/rive_core/data_bind/bindable_property_string.dart';
import 'package:rive/src/rive_core/data_bind/data_bind.dart';
import 'package:rive/src/rive_core/data_bind/data_bind_context.dart';
import 'package:rive/src/rive_core/draw_rules.dart';
import 'package:rive/src/rive_core/draw_target.dart';
import 'package:rive/src/rive_core/event.dart';
import 'package:rive/src/rive_core/joystick.dart';
import 'package:rive/src/rive_core/layout/layout_component_style.dart';
import 'package:rive/src/rive_core/layout_component.dart';
import 'package:rive/src/rive_core/nested_artboard.dart';
import 'package:rive/src/rive_core/node.dart';
import 'package:rive/src/rive_core/open_url_event.dart';
import 'package:rive/src/rive_core/shapes/clipping_shape.dart';
import 'package:rive/src/rive_core/shapes/contour_mesh_vertex.dart';
import 'package:rive/src/rive_core/shapes/cubic_asymmetric_vertex.dart';
import 'package:rive/src/rive_core/shapes/cubic_detached_vertex.dart';
import 'package:rive/src/rive_core/shapes/cubic_mirrored_vertex.dart';
import 'package:rive/src/rive_core/shapes/ellipse.dart';
import 'package:rive/src/rive_core/shapes/image.dart';
import 'package:rive/src/rive_core/shapes/mesh.dart';
import 'package:rive/src/rive_core/shapes/mesh_vertex.dart';
import 'package:rive/src/rive_core/shapes/paint/fill.dart';
import 'package:rive/src/rive_core/shapes/paint/gradient_stop.dart';
import 'package:rive/src/rive_core/shapes/paint/linear_gradient.dart';
import 'package:rive/src/rive_core/shapes/paint/radial_gradient.dart';
import 'package:rive/src/rive_core/shapes/paint/solid_color.dart';
import 'package:rive/src/rive_core/shapes/paint/stroke.dart';
import 'package:rive/src/rive_core/shapes/paint/trim_path.dart';
import 'package:rive/src/rive_core/shapes/points_path.dart';
import 'package:rive/src/rive_core/shapes/polygon.dart';
import 'package:rive/src/rive_core/shapes/rectangle.dart';
import 'package:rive/src/rive_core/shapes/shape.dart';
import 'package:rive/src/rive_core/shapes/star.dart';
import 'package:rive/src/rive_core/shapes/straight_vertex.dart';
import 'package:rive/src/rive_core/shapes/triangle.dart';
import 'package:rive/src/rive_core/solo.dart';
import 'package:rive/src/rive_core/text/text.dart';
import 'package:rive/src/rive_core/text/text_modifier_group.dart';
import 'package:rive/src/rive_core/text/text_modifier_range.dart';
import 'package:rive/src/rive_core/text/text_style.dart';
import 'package:rive/src/rive_core/text/text_style_axis.dart';
import 'package:rive/src/rive_core/text/text_style_feature.dart';
import 'package:rive/src/rive_core/text/text_value_run.dart';
import 'package:rive/src/rive_core/text/text_variation_modifier.dart';
import 'package:rive/src/rive_core/viewmodel/data_enum.dart';
import 'package:rive/src/rive_core/viewmodel/data_enum_value.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_component.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_boolean.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_color.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_enum.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_list.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_list_item.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_number.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_string.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance_viewmodel.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_property.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_property_boolean.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_property_color.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_property_enum.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_property_list.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_property_number.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_property_string.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_property_viewmodel.dart';
import 'package:stokanal/logging.dart';
import '../core/field_types/core_field_type.dart';

class PropertyBean {
  final int propertyKey;
  PropertyBean._(this.propertyKey);

  bool getBool(Core o) => throw Exception();
  void setBool(Core o, bool v) => throw Exception();

  double getDouble(Core o) => throw Exception();
  void setDouble(Core o, double v) => throw Exception();

  @nonVirtual
  void transformDouble(Core o, double Function(double) function) {
    setDouble(o, function(getDouble(o)));
  }

  int getColor(Core o) => throw Exception();
  void setColor(Core o, int v) => throw Exception();

  int getUint(Core o) => throw Exception();
  void setUint(Core o, int v) => throw Exception();

  String getString(Core o) => throw Exception();
  void setString(Core o, String v) => throw Exception();

  void setObjectProperty(Core o, Object v) => throw Exception();

  CoreFieldType? get coreType => throw Exception();

  void setCallback(Core o, CallbackData v) => throw Exception();
}

class DoublePropertyBean<T extends Core> extends PropertyBean {

  final double Function(T) getter;
  final void Function(T, double) setter;
  DoublePropertyBean._(super.propertyKey, this.getter, this.setter): super._();

  @override
  double getDouble(Core o) => getter(o as T);

  @override
  void setDouble(Core o, double v) => setter(o as T, v);

  @override
  void setObjectProperty(Core o, Object v) => o is T && v is double ? setDouble(o, v) : {};

  @override
  CoreFieldType? get coreType => RiveCoreContext.doubleType;
}

class UintPropertyBean<T extends Core> extends PropertyBean {

  final int Function(T) getter;
  final void Function(T, int) setter;
  UintPropertyBean._(super.propertyKey, this.getter, this.setter): super._();

  @override
  int getUint(Core o) => getter(o as T);

  @override
  void setUint(Core o, int v) => setter(o as T, v);

  @override
  void setObjectProperty(Core o, Object v) => o is T && v is int ? setUint(o, v) : {};

  @override
  CoreFieldType? get coreType => RiveCoreContext.uintType;
}

class ColorPropertyBean<T extends Core> extends PropertyBean {

  final int Function(T) getter;
  final void Function(T, int) setter;
  ColorPropertyBean._(super.propertyKey, this.getter, this.setter): super._();

  @override
  int getColor(Core o) => getter(o as T);

  @override
  void setColor(Core o, int v) => setter(o as T, v);

  @override
  void setObjectProperty(Core o, Object v) => o is T && v is int ? setColor(o, v) : {};

  @override
  CoreFieldType? get coreType => RiveCoreContext.colorType;
}

class StringPropertyBean<T extends Core> extends PropertyBean {

  final String Function(T) getter;
  final void Function(T, String) setter;
  StringPropertyBean._(super.propertyKey, this.getter, this.setter): super._();

  @override
  String getString(Core o) => getter(o as T);

  @override
  void setString(Core o, String v) => setter(o as T, v);

  @override
  void setObjectProperty(Core o, Object v) => o is T && v is String ? setString(o, v) : {};

  @override
  CoreFieldType? get coreType => RiveCoreContext.stringType;
}

class FallbackBean extends PropertyBean {

  FallbackBean._(super.propertyKey):
    super._();

  int hits = 0;
  bool dumped = false;

  @override
  bool getBool(Core o) {
    hits++;
    return RiveCoreContext.getBool(o, propertyKey);
  }
  @override
  void setBool(Core o, bool v) {
    hits++;
    RiveCoreContext.setBool(o, propertyKey, v);
  }

  @override
  double getDouble(Core o) {
    hits++;
    return RiveCoreContext.getDouble(o, propertyKey);
  }
  @override
  void setDouble(Core o, double v) {
    hits++;
    RiveCoreContext.setDouble(o, propertyKey, v);

    if (hits >= 10000 && !dumped) {
      dumped = true;
      PropertyBeans._dumpFallbacks();
    }
  }

  @override
  int getColor(Core o) {
    hits++;
    return RiveCoreContext.getColor(o, propertyKey);
  }
  @override
  void setColor(Core o, int v) {
    hits++;
    RiveCoreContext.setColor(o, propertyKey, v);
  }

  @override
  int getUint(Core o) {
    hits++;
    return RiveCoreContext.getUint(o, propertyKey);
  }
  @override
  void setUint(Core o, int v) {
    hits++;
    RiveCoreContext.setUint(o, propertyKey, v);
  }

  @override
  String getString(Core o) {
    hits++;
    return RiveCoreContext.getString(o, propertyKey);
  }
  @override
  void setString(Core o, String v) {
    hits++;
    RiveCoreContext.setString(o, propertyKey, v);
  }

  @override
  void setObjectProperty(Core o, Object v) {
    hits++;
    RiveCoreContext.setObjectProperty(o, propertyKey, v);
  }

  @override
  CoreFieldType? get coreType {
    hits++;
    return RiveCoreContext.coreType(propertyKey);
  }

  @override
  void setCallback(Core o, CallbackData v) {
    hits++;
    RiveCoreContext.setCallback(o, propertyKey, v);
  }

  @override
  String toString() => 'FallbackBean[$propertyKey, $hits]';
}

final _map = <int, PropertyBean>{};
final _invalid = PropertyBean._(CoreContext.invalidPropertyKey);
var _first = true;
final _implements = <PropertyBean>[
  _invalid,
  DoublePropertyBean<NodeBase>._(NodeBase.xPropertyKey, (o) => o.x, (o, v) => o.x = v),
  DoublePropertyBean<NodeBase>._(NodeBase.yPropertyKey, (o) => o.y, (o, v) => o.y = v),
  DoublePropertyBean<VertexBase>._(VertexBase.xPropertyKey, (o) => o.x, (o, v) => o.x = v),
  DoublePropertyBean<VertexBase>._(VertexBase.yPropertyKey, (o) => o.y, (o, v) => o.y = v),
  DoublePropertyBean<CubicDetachedVertexBase>._(CubicDetachedVertexBase.outRotationPropertyKey, (o) => o.outRotation, (o, v) => o.outRotation = v),
  DoublePropertyBean<CubicDetachedVertexBase>._(CubicDetachedVertexBase.outDistancePropertyKey, (o) => o.outDistance, (o, v) => o.outDistance = v),
  DoublePropertyBean<CubicDetachedVertexBase>._(CubicDetachedVertexBase.inRotationPropertyKey, (o) => o.inRotation, (o, v) => o.inRotation = v),
  DoublePropertyBean<CubicDetachedVertexBase>._(CubicDetachedVertexBase.inDistancePropertyKey, (o) => o.inDistance, (o, v) => o.inDistance = v),
  DoublePropertyBean<CubicAsymmetricVertexBase>._(CubicAsymmetricVertexBase.inDistancePropertyKey, (o) => o.inDistance, (o, v) => o.inDistance = v),
  DoublePropertyBean<CubicAsymmetricVertexBase>._(CubicAsymmetricVertexBase.rotationPropertyKey, (o) => o.rotation, (o, v) => o.rotation = v),
  DoublePropertyBean<TransformComponentBase>._(TransformComponentBase.scaleXPropertyKey, (o) => o.scaleX, (o, v) => o.scaleX = v),
  DoublePropertyBean<TransformComponentBase>._(TransformComponentBase.scaleYPropertyKey, (o) => o.scaleY, (o, v) => o.scaleY = v),
  DoublePropertyBean<TransformComponentBase>._(TransformComponentBase.rotationPropertyKey, (o) => o.rotation, (o, v) => o.rotation = v),
  DoublePropertyBean<KeyFrameDoubleBase>._(KeyFrameDoubleBase.valuePropertyKey, (o) => o.value_, (o, v) => o.value_ = v),
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

  static void _dumpFallbacks() {
    info(_map.values.whereType<FallbackBean>().sorted((b1, b2) => b2.hits.compareTo(b1.hits)).map((b) => '$b').join('\n'));
  }
}
import 'package:rive/src/core/core.dart';
import 'package:rive/src/core/field_types/core_bool_type.dart';
import 'package:rive/src/core/field_types/core_color_type.dart';
import 'package:rive/src/core/field_types/core_double_type.dart';
import 'package:rive/src/core/field_types/core_field_type.dart';
import 'package:rive/src/core/field_types/core_string_type.dart';
import 'package:rive/src/core/field_types/core_uint_type.dart';
import 'package:rive/src/generated/animation/animation_base.dart';
import 'package:rive/src/generated/animation/animation_state_base.dart';
import 'package:rive/src/generated/animation/any_state_base.dart';
import 'package:rive/src/generated/animation/cubic_interpolator_base.dart';
import 'package:rive/src/generated/animation/entry_state_base.dart';
import 'package:rive/src/generated/animation/exit_state_base.dart';
import 'package:rive/src/generated/animation/keyed_object_base.dart';
import 'package:rive/src/generated/animation/keyed_property_base.dart';
import 'package:rive/src/generated/animation/keyframe_base.dart';
import 'package:rive/src/generated/animation/keyframe_color_base.dart';
import 'package:rive/src/generated/animation/keyframe_double_base.dart';
import 'package:rive/src/generated/animation/keyframe_id_base.dart';
import 'package:rive/src/generated/animation/linear_animation_base.dart';
import 'package:rive/src/generated/animation/state_machine_base.dart';
import 'package:rive/src/generated/animation/state_machine_bool_base.dart';
import 'package:rive/src/generated/animation/state_machine_component_base.dart';
import 'package:rive/src/generated/animation/state_machine_double_base.dart';
import 'package:rive/src/generated/animation/state_machine_layer_base.dart';
import 'package:rive/src/generated/animation/state_machine_trigger_base.dart';
import 'package:rive/src/generated/animation/state_transition_base.dart';
import 'package:rive/src/generated/animation/transition_bool_condition_base.dart';
import 'package:rive/src/generated/animation/transition_condition_base.dart';
import 'package:rive/src/generated/animation/transition_double_condition_base.dart';
import 'package:rive/src/generated/animation/transition_trigger_condition_base.dart';
import 'package:rive/src/generated/animation/transition_value_condition_base.dart';
import 'package:rive/src/generated/artboard_base.dart';
import 'package:rive/src/generated/backboard_base.dart';
import 'package:rive/src/generated/bones/bone_base.dart';
import 'package:rive/src/generated/bones/cubic_weight_base.dart';
import 'package:rive/src/generated/bones/root_bone_base.dart';
import 'package:rive/src/generated/bones/skin_base.dart';
import 'package:rive/src/generated/bones/tendon_base.dart';
import 'package:rive/src/generated/bones/weight_base.dart';
import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/draw_rules_base.dart';
import 'package:rive/src/generated/draw_target_base.dart';
import 'package:rive/src/generated/drawable_base.dart';
import 'package:rive/src/generated/node_base.dart';
import 'package:rive/src/generated/shapes/clipping_shape_base.dart';
import 'package:rive/src/generated/shapes/cubic_asymmetric_vertex_base.dart';
import 'package:rive/src/generated/shapes/cubic_detached_vertex_base.dart';
import 'package:rive/src/generated/shapes/cubic_mirrored_vertex_base.dart';
import 'package:rive/src/generated/shapes/ellipse_base.dart';
import 'package:rive/src/generated/shapes/paint/fill_base.dart';
import 'package:rive/src/generated/shapes/paint/gradient_stop_base.dart';
import 'package:rive/src/generated/shapes/paint/linear_gradient_base.dart';
import 'package:rive/src/generated/shapes/paint/radial_gradient_base.dart';
import 'package:rive/src/generated/shapes/paint/shape_paint_base.dart';
import 'package:rive/src/generated/shapes/paint/solid_color_base.dart';
import 'package:rive/src/generated/shapes/paint/stroke_base.dart';
import 'package:rive/src/generated/shapes/paint/trim_path_base.dart';
import 'package:rive/src/generated/shapes/parametric_path_base.dart';
import 'package:rive/src/generated/shapes/path_base.dart';
import 'package:rive/src/generated/shapes/path_composer_base.dart';
import 'package:rive/src/generated/shapes/path_vertex_base.dart';
import 'package:rive/src/generated/shapes/points_path_base.dart';
import 'package:rive/src/generated/shapes/polygon_base.dart';
import 'package:rive/src/generated/shapes/rectangle_base.dart';
import 'package:rive/src/generated/shapes/shape_base.dart';
import 'package:rive/src/generated/shapes/star_base.dart';
import 'package:rive/src/generated/shapes/straight_vertex_base.dart';
import 'package:rive/src/generated/shapes/triangle_base.dart';
import 'package:rive/src/generated/transform_component_base.dart';
import 'package:rive/src/rive_core/animation/animation.dart';
import 'package:rive/src/rive_core/animation/animation_state.dart';
import 'package:rive/src/rive_core/animation/any_state.dart';
import 'package:rive/src/rive_core/animation/cubic_interpolator.dart';
import 'package:rive/src/rive_core/animation/entry_state.dart';
import 'package:rive/src/rive_core/animation/exit_state.dart';
import 'package:rive/src/rive_core/animation/keyed_object.dart';
import 'package:rive/src/rive_core/animation/keyed_property.dart';
import 'package:rive/src/rive_core/animation/keyframe_color.dart';
import 'package:rive/src/rive_core/animation/keyframe_double.dart';
import 'package:rive/src/rive_core/animation/keyframe_id.dart';
import 'package:rive/src/rive_core/animation/linear_animation.dart';
import 'package:rive/src/rive_core/animation/state_machine.dart';
import 'package:rive/src/rive_core/animation/state_machine_bool.dart';
import 'package:rive/src/rive_core/animation/state_machine_double.dart';
import 'package:rive/src/rive_core/animation/state_machine_layer.dart';
import 'package:rive/src/rive_core/animation/state_machine_trigger.dart';
import 'package:rive/src/rive_core/animation/state_transition.dart';
import 'package:rive/src/rive_core/animation/transition_bool_condition.dart';
import 'package:rive/src/rive_core/animation/transition_double_condition.dart';
import 'package:rive/src/rive_core/animation/transition_trigger_condition.dart';
import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/rive_core/backboard.dart';
import 'package:rive/src/rive_core/bones/bone.dart';
import 'package:rive/src/rive_core/bones/cubic_weight.dart';
import 'package:rive/src/rive_core/bones/root_bone.dart';
import 'package:rive/src/rive_core/bones/skin.dart';
import 'package:rive/src/rive_core/bones/tendon.dart';
import 'package:rive/src/rive_core/bones/weight.dart';
import 'package:rive/src/rive_core/draw_rules.dart';
import 'package:rive/src/rive_core/draw_target.dart';
import 'package:rive/src/rive_core/node.dart';
import 'package:rive/src/rive_core/shapes/clipping_shape.dart';
import 'package:rive/src/rive_core/shapes/cubic_asymmetric_vertex.dart';
import 'package:rive/src/rive_core/shapes/cubic_detached_vertex.dart';
import 'package:rive/src/rive_core/shapes/cubic_mirrored_vertex.dart';
import 'package:rive/src/rive_core/shapes/ellipse.dart';
import 'package:rive/src/rive_core/shapes/paint/fill.dart';
import 'package:rive/src/rive_core/shapes/paint/gradient_stop.dart';
import 'package:rive/src/rive_core/shapes/paint/linear_gradient.dart';
import 'package:rive/src/rive_core/shapes/paint/radial_gradient.dart';
import 'package:rive/src/rive_core/shapes/paint/solid_color.dart';
import 'package:rive/src/rive_core/shapes/paint/stroke.dart';
import 'package:rive/src/rive_core/shapes/paint/trim_path.dart';
import 'package:rive/src/rive_core/shapes/path_composer.dart';
import 'package:rive/src/rive_core/shapes/points_path.dart';
import 'package:rive/src/rive_core/shapes/polygon.dart';
import 'package:rive/src/rive_core/shapes/rectangle.dart';
import 'package:rive/src/rive_core/shapes/shape.dart';
import 'package:rive/src/rive_core/shapes/star.dart';
import 'package:rive/src/rive_core/shapes/straight_vertex.dart';
import 'package:rive/src/rive_core/shapes/triangle.dart';

// ignore: avoid_classes_with_only_static_members
class RiveCoreContext {
  static Core? makeCoreInstance(int typeKey) {
    switch (typeKey) {
      case DrawTargetBase.typeKey:
        return DrawTarget();
      case AnimationStateBase.typeKey:
        return AnimationState();
      case KeyedObjectBase.typeKey:
        return KeyedObject();
      case TransitionTriggerConditionBase.typeKey:
        return TransitionTriggerCondition();
      case KeyedPropertyBase.typeKey:
        return KeyedProperty();
      case StateMachineDoubleBase.typeKey:
        return StateMachineDouble();
      case KeyFrameIdBase.typeKey:
        return KeyFrameId();
      case AnyStateBase.typeKey:
        return AnyState();
      case StateMachineLayerBase.typeKey:
        return StateMachineLayer();
      case AnimationBase.typeKey:
        return Animation();
      case CubicInterpolatorBase.typeKey:
        return CubicInterpolator();
      case TransitionDoubleConditionBase.typeKey:
        return TransitionDoubleCondition();
      case StateTransitionBase.typeKey:
        return StateTransition();
      case KeyFrameDoubleBase.typeKey:
        return KeyFrameDouble();
      case KeyFrameColorBase.typeKey:
        return KeyFrameColor();
      case StateMachineBase.typeKey:
        return StateMachine();
      case EntryStateBase.typeKey:
        return EntryState();
      case LinearAnimationBase.typeKey:
        return LinearAnimation();
      case StateMachineTriggerBase.typeKey:
        return StateMachineTrigger();
      case ExitStateBase.typeKey:
        return ExitState();
      case TransitionBoolConditionBase.typeKey:
        return TransitionBoolCondition();
      case StateMachineBoolBase.typeKey:
        return StateMachineBool();
      case LinearGradientBase.typeKey:
        return LinearGradient();
      case RadialGradientBase.typeKey:
        return RadialGradient();
      case StrokeBase.typeKey:
        return Stroke();
      case SolidColorBase.typeKey:
        return SolidColor();
      case GradientStopBase.typeKey:
        return GradientStop();
      case TrimPathBase.typeKey:
        return TrimPath();
      case FillBase.typeKey:
        return Fill();
      case NodeBase.typeKey:
        return Node();
      case ShapeBase.typeKey:
        return Shape();
      case WeightBase.typeKey:
        return Weight();
      case StraightVertexBase.typeKey:
        return StraightVertex();
      case CubicWeightBase.typeKey:
        return CubicWeight();
      case CubicAsymmetricVertexBase.typeKey:
        return CubicAsymmetricVertex();
      case PointsPathBase.typeKey:
        return PointsPath();
      case RectangleBase.typeKey:
        return Rectangle();
      case CubicMirroredVertexBase.typeKey:
        return CubicMirroredVertex();
      case TriangleBase.typeKey:
        return Triangle();
      case EllipseBase.typeKey:
        return Ellipse();
      case ClippingShapeBase.typeKey:
        return ClippingShape();
      case PolygonBase.typeKey:
        return Polygon();
      case StarBase.typeKey:
        return Star();
      case PathComposerBase.typeKey:
        return PathComposer();
      case CubicDetachedVertexBase.typeKey:
        return CubicDetachedVertex();
      case DrawRulesBase.typeKey:
        return DrawRules();
      case ArtboardBase.typeKey:
        return Artboard();
      case BackboardBase.typeKey:
        return Backboard();
      case BoneBase.typeKey:
        return Bone();
      case RootBoneBase.typeKey:
        return RootBone();
      case SkinBase.typeKey:
        return Skin();
      case TendonBase.typeKey:
        return Tendon();
      default:
        return null;
    }
  }

  static void setObjectProperty(Core object, int propertyKey, Object value) {
    switch (propertyKey) {
      case ComponentBase.namePropertyKey:
        if (object is ComponentBase && value is String) {
          object.name = value;
        }
        break;
      case ComponentBase.parentIdPropertyKey:
        if (object is ComponentBase && value is int) {
          object.parentId = value;
        }
        break;
      case DrawTargetBase.drawableIdPropertyKey:
        if (object is DrawTargetBase && value is int) {
          object.drawableId = value;
        }
        break;
      case DrawTargetBase.placementValuePropertyKey:
        if (object is DrawTargetBase && value is int) {
          object.placementValue = value;
        }
        break;
      case AnimationStateBase.animationIdPropertyKey:
        if (object is AnimationStateBase && value is int) {
          object.animationId = value;
        }
        break;
      case KeyedObjectBase.objectIdPropertyKey:
        if (object is KeyedObjectBase && value is int) {
          object.objectId = value;
        }
        break;
      case TransitionConditionBase.inputIdPropertyKey:
        if (object is TransitionConditionBase && value is int) {
          object.inputId = value;
        }
        break;
      case StateMachineComponentBase.namePropertyKey:
        if (object is StateMachineComponentBase && value is String) {
          object.name = value;
        }
        break;
      case KeyedPropertyBase.propertyKeyPropertyKey:
        if (object is KeyedPropertyBase && value is int) {
          object.propertyKey = value;
        }
        break;
      case StateMachineDoubleBase.valuePropertyKey:
        if (object is StateMachineDoubleBase && value is double) {
          object.value = value;
        }
        break;
      case KeyFrameBase.framePropertyKey:
        if (object is KeyFrameBase && value is int) {
          object.frame = value;
        }
        break;
      case KeyFrameBase.interpolationTypePropertyKey:
        if (object is KeyFrameBase && value is int) {
          object.interpolationType = value;
        }
        break;
      case KeyFrameBase.interpolatorIdPropertyKey:
        if (object is KeyFrameBase && value is int) {
          object.interpolatorId = value;
        }
        break;
      case KeyFrameIdBase.valuePropertyKey:
        if (object is KeyFrameIdBase && value is int) {
          object.value = value;
        }
        break;
      case AnimationBase.namePropertyKey:
        if (object is AnimationBase && value is String) {
          object.name = value;
        }
        break;
      case CubicInterpolatorBase.x1PropertyKey:
        if (object is CubicInterpolatorBase && value is double) {
          object.x1 = value;
        }
        break;
      case CubicInterpolatorBase.y1PropertyKey:
        if (object is CubicInterpolatorBase && value is double) {
          object.y1 = value;
        }
        break;
      case CubicInterpolatorBase.x2PropertyKey:
        if (object is CubicInterpolatorBase && value is double) {
          object.x2 = value;
        }
        break;
      case CubicInterpolatorBase.y2PropertyKey:
        if (object is CubicInterpolatorBase && value is double) {
          object.y2 = value;
        }
        break;
      case TransitionValueConditionBase.opValuePropertyKey:
        if (object is TransitionValueConditionBase && value is int) {
          object.opValue = value;
        }
        break;
      case TransitionDoubleConditionBase.valuePropertyKey:
        if (object is TransitionDoubleConditionBase && value is double) {
          object.value = value;
        }
        break;
      case StateTransitionBase.stateToIdPropertyKey:
        if (object is StateTransitionBase && value is int) {
          object.stateToId = value;
        }
        break;
      case StateTransitionBase.flagsPropertyKey:
        if (object is StateTransitionBase && value is int) {
          object.flags = value;
        }
        break;
      case StateTransitionBase.durationPropertyKey:
        if (object is StateTransitionBase && value is int) {
          object.duration = value;
        }
        break;
      case KeyFrameDoubleBase.valuePropertyKey:
        if (object is KeyFrameDoubleBase && value is double) {
          object.value = value;
        }
        break;
      case KeyFrameColorBase.valuePropertyKey:
        if (object is KeyFrameColorBase && value is int) {
          object.value = value;
        }
        break;
      case LinearAnimationBase.fpsPropertyKey:
        if (object is LinearAnimationBase && value is int) {
          object.fps = value;
        }
        break;
      case LinearAnimationBase.durationPropertyKey:
        if (object is LinearAnimationBase && value is int) {
          object.duration = value;
        }
        break;
      case LinearAnimationBase.speedPropertyKey:
        if (object is LinearAnimationBase && value is double) {
          object.speed = value;
        }
        break;
      case LinearAnimationBase.loopValuePropertyKey:
        if (object is LinearAnimationBase && value is int) {
          object.loopValue = value;
        }
        break;
      case LinearAnimationBase.workStartPropertyKey:
        if (object is LinearAnimationBase && value is int) {
          object.workStart = value;
        }
        break;
      case LinearAnimationBase.workEndPropertyKey:
        if (object is LinearAnimationBase && value is int) {
          object.workEnd = value;
        }
        break;
      case LinearAnimationBase.enableWorkAreaPropertyKey:
        if (object is LinearAnimationBase && value is bool) {
          object.enableWorkArea = value;
        }
        break;
      case StateMachineBoolBase.valuePropertyKey:
        if (object is StateMachineBoolBase && value is bool) {
          object.value = value;
        }
        break;
      case ShapePaintBase.isVisiblePropertyKey:
        if (object is ShapePaintBase && value is bool) {
          object.isVisible = value;
        }
        break;
      case LinearGradientBase.startXPropertyKey:
        if (object is LinearGradientBase && value is double) {
          object.startX = value;
        }
        break;
      case LinearGradientBase.startYPropertyKey:
        if (object is LinearGradientBase && value is double) {
          object.startY = value;
        }
        break;
      case LinearGradientBase.endXPropertyKey:
        if (object is LinearGradientBase && value is double) {
          object.endX = value;
        }
        break;
      case LinearGradientBase.endYPropertyKey:
        if (object is LinearGradientBase && value is double) {
          object.endY = value;
        }
        break;
      case LinearGradientBase.opacityPropertyKey:
        if (object is LinearGradientBase && value is double) {
          object.opacity = value;
        }
        break;
      case StrokeBase.thicknessPropertyKey:
        if (object is StrokeBase && value is double) {
          object.thickness = value;
        }
        break;
      case StrokeBase.capPropertyKey:
        if (object is StrokeBase && value is int) {
          object.cap = value;
        }
        break;
      case StrokeBase.joinPropertyKey:
        if (object is StrokeBase && value is int) {
          object.join = value;
        }
        break;
      case StrokeBase.transformAffectsStrokePropertyKey:
        if (object is StrokeBase && value is bool) {
          object.transformAffectsStroke = value;
        }
        break;
      case SolidColorBase.colorValuePropertyKey:
        if (object is SolidColorBase && value is int) {
          object.colorValue = value;
        }
        break;
      case GradientStopBase.colorValuePropertyKey:
        if (object is GradientStopBase && value is int) {
          object.colorValue = value;
        }
        break;
      case GradientStopBase.positionPropertyKey:
        if (object is GradientStopBase && value is double) {
          object.position = value;
        }
        break;
      case TrimPathBase.startPropertyKey:
        if (object is TrimPathBase && value is double) {
          object.start = value;
        }
        break;
      case TrimPathBase.endPropertyKey:
        if (object is TrimPathBase && value is double) {
          object.end = value;
        }
        break;
      case TrimPathBase.offsetPropertyKey:
        if (object is TrimPathBase && value is double) {
          object.offset = value;
        }
        break;
      case TrimPathBase.modeValuePropertyKey:
        if (object is TrimPathBase && value is int) {
          object.modeValue = value;
        }
        break;
      case FillBase.fillRulePropertyKey:
        if (object is FillBase && value is int) {
          object.fillRule = value;
        }
        break;
      case TransformComponentBase.rotationPropertyKey:
        if (object is TransformComponentBase && value is double) {
          object.rotation = value;
        }
        break;
      case TransformComponentBase.scaleXPropertyKey:
        if (object is TransformComponentBase && value is double) {
          object.scaleX = value;
        }
        break;
      case TransformComponentBase.scaleYPropertyKey:
        if (object is TransformComponentBase && value is double) {
          object.scaleY = value;
        }
        break;
      case TransformComponentBase.opacityPropertyKey:
        if (object is TransformComponentBase && value is double) {
          object.opacity = value;
        }
        break;
      case NodeBase.xPropertyKey:
        if (object is NodeBase && value is double) {
          object.x = value;
        }
        break;
      case NodeBase.yPropertyKey:
        if (object is NodeBase && value is double) {
          object.y = value;
        }
        break;
      case PathBase.pathFlagsPropertyKey:
        if (object is PathBase && value is int) {
          object.pathFlags = value;
        }
        break;
      case DrawableBase.blendModeValuePropertyKey:
        if (object is DrawableBase && value is int) {
          object.blendModeValue = value;
        }
        break;
      case DrawableBase.drawableFlagsPropertyKey:
        if (object is DrawableBase && value is int) {
          object.drawableFlags = value;
        }
        break;
      case PathVertexBase.xPropertyKey:
        if (object is PathVertexBase && value is double) {
          object.x = value;
        }
        break;
      case PathVertexBase.yPropertyKey:
        if (object is PathVertexBase && value is double) {
          object.y = value;
        }
        break;
      case WeightBase.valuesPropertyKey:
        if (object is WeightBase && value is int) {
          object.values = value;
        }
        break;
      case WeightBase.indicesPropertyKey:
        if (object is WeightBase && value is int) {
          object.indices = value;
        }
        break;
      case StraightVertexBase.radiusPropertyKey:
        if (object is StraightVertexBase && value is double) {
          object.radius = value;
        }
        break;
      case CubicWeightBase.inValuesPropertyKey:
        if (object is CubicWeightBase && value is int) {
          object.inValues = value;
        }
        break;
      case CubicWeightBase.inIndicesPropertyKey:
        if (object is CubicWeightBase && value is int) {
          object.inIndices = value;
        }
        break;
      case CubicWeightBase.outValuesPropertyKey:
        if (object is CubicWeightBase && value is int) {
          object.outValues = value;
        }
        break;
      case CubicWeightBase.outIndicesPropertyKey:
        if (object is CubicWeightBase && value is int) {
          object.outIndices = value;
        }
        break;
      case CubicAsymmetricVertexBase.rotationPropertyKey:
        if (object is CubicAsymmetricVertexBase && value is double) {
          object.rotation = value;
        }
        break;
      case CubicAsymmetricVertexBase.inDistancePropertyKey:
        if (object is CubicAsymmetricVertexBase && value is double) {
          object.inDistance = value;
        }
        break;
      case CubicAsymmetricVertexBase.outDistancePropertyKey:
        if (object is CubicAsymmetricVertexBase && value is double) {
          object.outDistance = value;
        }
        break;
      case PointsPathBase.isClosedPropertyKey:
        if (object is PointsPathBase && value is bool) {
          object.isClosed = value;
        }
        break;
      case ParametricPathBase.widthPropertyKey:
        if (object is ParametricPathBase && value is double) {
          object.width = value;
        }
        break;
      case ParametricPathBase.heightPropertyKey:
        if (object is ParametricPathBase && value is double) {
          object.height = value;
        }
        break;
      case ParametricPathBase.originXPropertyKey:
        if (object is ParametricPathBase && value is double) {
          object.originX = value;
        }
        break;
      case ParametricPathBase.originYPropertyKey:
        if (object is ParametricPathBase && value is double) {
          object.originY = value;
        }
        break;
      case RectangleBase.cornerRadiusPropertyKey:
        if (object is RectangleBase && value is double) {
          object.cornerRadius = value;
        }
        break;
      case CubicMirroredVertexBase.rotationPropertyKey:
        if (object is CubicMirroredVertexBase && value is double) {
          object.rotation = value;
        }
        break;
      case CubicMirroredVertexBase.distancePropertyKey:
        if (object is CubicMirroredVertexBase && value is double) {
          object.distance = value;
        }
        break;
      case ClippingShapeBase.sourceIdPropertyKey:
        if (object is ClippingShapeBase && value is int) {
          object.sourceId = value;
        }
        break;
      case ClippingShapeBase.fillRulePropertyKey:
        if (object is ClippingShapeBase && value is int) {
          object.fillRule = value;
        }
        break;
      case ClippingShapeBase.isVisiblePropertyKey:
        if (object is ClippingShapeBase && value is bool) {
          object.isVisible = value;
        }
        break;
      case PolygonBase.pointsPropertyKey:
        if (object is PolygonBase && value is int) {
          object.points = value;
        }
        break;
      case PolygonBase.cornerRadiusPropertyKey:
        if (object is PolygonBase && value is double) {
          object.cornerRadius = value;
        }
        break;
      case StarBase.innerRadiusPropertyKey:
        if (object is StarBase && value is double) {
          object.innerRadius = value;
        }
        break;
      case CubicDetachedVertexBase.inRotationPropertyKey:
        if (object is CubicDetachedVertexBase && value is double) {
          object.inRotation = value;
        }
        break;
      case CubicDetachedVertexBase.inDistancePropertyKey:
        if (object is CubicDetachedVertexBase && value is double) {
          object.inDistance = value;
        }
        break;
      case CubicDetachedVertexBase.outRotationPropertyKey:
        if (object is CubicDetachedVertexBase && value is double) {
          object.outRotation = value;
        }
        break;
      case CubicDetachedVertexBase.outDistancePropertyKey:
        if (object is CubicDetachedVertexBase && value is double) {
          object.outDistance = value;
        }
        break;
      case DrawRulesBase.drawTargetIdPropertyKey:
        if (object is DrawRulesBase && value is int) {
          object.drawTargetId = value;
        }
        break;
      case ArtboardBase.widthPropertyKey:
        if (object is ArtboardBase && value is double) {
          object.width = value;
        }
        break;
      case ArtboardBase.heightPropertyKey:
        if (object is ArtboardBase && value is double) {
          object.height = value;
        }
        break;
      case ArtboardBase.xPropertyKey:
        if (object is ArtboardBase && value is double) {
          object.x = value;
        }
        break;
      case ArtboardBase.yPropertyKey:
        if (object is ArtboardBase && value is double) {
          object.y = value;
        }
        break;
      case ArtboardBase.originXPropertyKey:
        if (object is ArtboardBase && value is double) {
          object.originX = value;
        }
        break;
      case ArtboardBase.originYPropertyKey:
        if (object is ArtboardBase && value is double) {
          object.originY = value;
        }
        break;
      case BoneBase.lengthPropertyKey:
        if (object is BoneBase && value is double) {
          object.length = value;
        }
        break;
      case RootBoneBase.xPropertyKey:
        if (object is RootBoneBase && value is double) {
          object.x = value;
        }
        break;
      case RootBoneBase.yPropertyKey:
        if (object is RootBoneBase && value is double) {
          object.y = value;
        }
        break;
      case SkinBase.xxPropertyKey:
        if (object is SkinBase && value is double) {
          object.xx = value;
        }
        break;
      case SkinBase.yxPropertyKey:
        if (object is SkinBase && value is double) {
          object.yx = value;
        }
        break;
      case SkinBase.xyPropertyKey:
        if (object is SkinBase && value is double) {
          object.xy = value;
        }
        break;
      case SkinBase.yyPropertyKey:
        if (object is SkinBase && value is double) {
          object.yy = value;
        }
        break;
      case SkinBase.txPropertyKey:
        if (object is SkinBase && value is double) {
          object.tx = value;
        }
        break;
      case SkinBase.tyPropertyKey:
        if (object is SkinBase && value is double) {
          object.ty = value;
        }
        break;
      case TendonBase.boneIdPropertyKey:
        if (object is TendonBase && value is int) {
          object.boneId = value;
        }
        break;
      case TendonBase.xxPropertyKey:
        if (object is TendonBase && value is double) {
          object.xx = value;
        }
        break;
      case TendonBase.yxPropertyKey:
        if (object is TendonBase && value is double) {
          object.yx = value;
        }
        break;
      case TendonBase.xyPropertyKey:
        if (object is TendonBase && value is double) {
          object.xy = value;
        }
        break;
      case TendonBase.yyPropertyKey:
        if (object is TendonBase && value is double) {
          object.yy = value;
        }
        break;
      case TendonBase.txPropertyKey:
        if (object is TendonBase && value is double) {
          object.tx = value;
        }
        break;
      case TendonBase.tyPropertyKey:
        if (object is TendonBase && value is double) {
          object.ty = value;
        }
        break;
    }
  }

  static CoreFieldType stringType = CoreStringType();
  static CoreFieldType uintType = CoreUintType();
  static CoreFieldType doubleType = CoreDoubleType();
  static CoreFieldType colorType = CoreColorType();
  static CoreFieldType boolType = CoreBoolType();
  static CoreFieldType? coreType(int propertyKey) {
    switch (propertyKey) {
      case ComponentBase.namePropertyKey:
      case StateMachineComponentBase.namePropertyKey:
      case AnimationBase.namePropertyKey:
        return stringType;
      case ComponentBase.parentIdPropertyKey:
      case DrawTargetBase.drawableIdPropertyKey:
      case DrawTargetBase.placementValuePropertyKey:
      case AnimationStateBase.animationIdPropertyKey:
      case KeyedObjectBase.objectIdPropertyKey:
      case TransitionConditionBase.inputIdPropertyKey:
      case KeyedPropertyBase.propertyKeyPropertyKey:
      case KeyFrameBase.framePropertyKey:
      case KeyFrameBase.interpolationTypePropertyKey:
      case KeyFrameBase.interpolatorIdPropertyKey:
      case KeyFrameIdBase.valuePropertyKey:
      case TransitionValueConditionBase.opValuePropertyKey:
      case StateTransitionBase.stateToIdPropertyKey:
      case StateTransitionBase.flagsPropertyKey:
      case StateTransitionBase.durationPropertyKey:
      case LinearAnimationBase.fpsPropertyKey:
      case LinearAnimationBase.durationPropertyKey:
      case LinearAnimationBase.loopValuePropertyKey:
      case LinearAnimationBase.workStartPropertyKey:
      case LinearAnimationBase.workEndPropertyKey:
      case StrokeBase.capPropertyKey:
      case StrokeBase.joinPropertyKey:
      case TrimPathBase.modeValuePropertyKey:
      case FillBase.fillRulePropertyKey:
      case PathBase.pathFlagsPropertyKey:
      case DrawableBase.blendModeValuePropertyKey:
      case DrawableBase.drawableFlagsPropertyKey:
      case WeightBase.valuesPropertyKey:
      case WeightBase.indicesPropertyKey:
      case CubicWeightBase.inValuesPropertyKey:
      case CubicWeightBase.inIndicesPropertyKey:
      case CubicWeightBase.outValuesPropertyKey:
      case CubicWeightBase.outIndicesPropertyKey:
      case ClippingShapeBase.sourceIdPropertyKey:
      case ClippingShapeBase.fillRulePropertyKey:
      case PolygonBase.pointsPropertyKey:
      case DrawRulesBase.drawTargetIdPropertyKey:
      case TendonBase.boneIdPropertyKey:
        return uintType;
      case StateMachineDoubleBase.valuePropertyKey:
      case CubicInterpolatorBase.x1PropertyKey:
      case CubicInterpolatorBase.y1PropertyKey:
      case CubicInterpolatorBase.x2PropertyKey:
      case CubicInterpolatorBase.y2PropertyKey:
      case TransitionDoubleConditionBase.valuePropertyKey:
      case KeyFrameDoubleBase.valuePropertyKey:
      case LinearAnimationBase.speedPropertyKey:
      case LinearGradientBase.startXPropertyKey:
      case LinearGradientBase.startYPropertyKey:
      case LinearGradientBase.endXPropertyKey:
      case LinearGradientBase.endYPropertyKey:
      case LinearGradientBase.opacityPropertyKey:
      case StrokeBase.thicknessPropertyKey:
      case GradientStopBase.positionPropertyKey:
      case TrimPathBase.startPropertyKey:
      case TrimPathBase.endPropertyKey:
      case TrimPathBase.offsetPropertyKey:
      case TransformComponentBase.rotationPropertyKey:
      case TransformComponentBase.scaleXPropertyKey:
      case TransformComponentBase.scaleYPropertyKey:
      case TransformComponentBase.opacityPropertyKey:
      case NodeBase.xPropertyKey:
      case NodeBase.yPropertyKey:
      case PathVertexBase.xPropertyKey:
      case PathVertexBase.yPropertyKey:
      case StraightVertexBase.radiusPropertyKey:
      case CubicAsymmetricVertexBase.rotationPropertyKey:
      case CubicAsymmetricVertexBase.inDistancePropertyKey:
      case CubicAsymmetricVertexBase.outDistancePropertyKey:
      case ParametricPathBase.widthPropertyKey:
      case ParametricPathBase.heightPropertyKey:
      case ParametricPathBase.originXPropertyKey:
      case ParametricPathBase.originYPropertyKey:
      case RectangleBase.cornerRadiusPropertyKey:
      case CubicMirroredVertexBase.rotationPropertyKey:
      case CubicMirroredVertexBase.distancePropertyKey:
      case PolygonBase.cornerRadiusPropertyKey:
      case StarBase.innerRadiusPropertyKey:
      case CubicDetachedVertexBase.inRotationPropertyKey:
      case CubicDetachedVertexBase.inDistancePropertyKey:
      case CubicDetachedVertexBase.outRotationPropertyKey:
      case CubicDetachedVertexBase.outDistancePropertyKey:
      case ArtboardBase.widthPropertyKey:
      case ArtboardBase.heightPropertyKey:
      case ArtboardBase.xPropertyKey:
      case ArtboardBase.yPropertyKey:
      case ArtboardBase.originXPropertyKey:
      case ArtboardBase.originYPropertyKey:
      case BoneBase.lengthPropertyKey:
      case RootBoneBase.xPropertyKey:
      case RootBoneBase.yPropertyKey:
      case SkinBase.xxPropertyKey:
      case SkinBase.yxPropertyKey:
      case SkinBase.xyPropertyKey:
      case SkinBase.yyPropertyKey:
      case SkinBase.txPropertyKey:
      case SkinBase.tyPropertyKey:
      case TendonBase.xxPropertyKey:
      case TendonBase.yxPropertyKey:
      case TendonBase.xyPropertyKey:
      case TendonBase.yyPropertyKey:
      case TendonBase.txPropertyKey:
      case TendonBase.tyPropertyKey:
        return doubleType;
      case KeyFrameColorBase.valuePropertyKey:
      case SolidColorBase.colorValuePropertyKey:
      case GradientStopBase.colorValuePropertyKey:
        return colorType;
      case LinearAnimationBase.enableWorkAreaPropertyKey:
      case StateMachineBoolBase.valuePropertyKey:
      case ShapePaintBase.isVisiblePropertyKey:
      case StrokeBase.transformAffectsStrokePropertyKey:
      case PointsPathBase.isClosedPropertyKey:
      case ClippingShapeBase.isVisiblePropertyKey:
        return boolType;
      default:
        return null;
    }
  }

  static String getString(Core object, int propertyKey) {
    switch (propertyKey) {
      case ComponentBase.namePropertyKey:
        return (object as ComponentBase).name;
      case StateMachineComponentBase.namePropertyKey:
        return (object as StateMachineComponentBase).name;
      case AnimationBase.namePropertyKey:
        return (object as AnimationBase).name;
    }
    return '';
  }

  static int getUint(Core object, int propertyKey) {
    switch (propertyKey) {
      case ComponentBase.parentIdPropertyKey:
        return (object as ComponentBase).parentId;
      case DrawTargetBase.drawableIdPropertyKey:
        return (object as DrawTargetBase).drawableId;
      case DrawTargetBase.placementValuePropertyKey:
        return (object as DrawTargetBase).placementValue;
      case AnimationStateBase.animationIdPropertyKey:
        return (object as AnimationStateBase).animationId;
      case KeyedObjectBase.objectIdPropertyKey:
        return (object as KeyedObjectBase).objectId;
      case TransitionConditionBase.inputIdPropertyKey:
        return (object as TransitionConditionBase).inputId;
      case KeyedPropertyBase.propertyKeyPropertyKey:
        return (object as KeyedPropertyBase).propertyKey;
      case KeyFrameBase.framePropertyKey:
        return (object as KeyFrameBase).frame;
      case KeyFrameBase.interpolationTypePropertyKey:
        return (object as KeyFrameBase).interpolationType;
      case KeyFrameBase.interpolatorIdPropertyKey:
        return (object as KeyFrameBase).interpolatorId;
      case KeyFrameIdBase.valuePropertyKey:
        return (object as KeyFrameIdBase).value;
      case TransitionValueConditionBase.opValuePropertyKey:
        return (object as TransitionValueConditionBase).opValue;
      case StateTransitionBase.stateToIdPropertyKey:
        return (object as StateTransitionBase).stateToId;
      case StateTransitionBase.flagsPropertyKey:
        return (object as StateTransitionBase).flags;
      case StateTransitionBase.durationPropertyKey:
        return (object as StateTransitionBase).duration;
      case LinearAnimationBase.fpsPropertyKey:
        return (object as LinearAnimationBase).fps;
      case LinearAnimationBase.durationPropertyKey:
        return (object as LinearAnimationBase).duration;
      case LinearAnimationBase.loopValuePropertyKey:
        return (object as LinearAnimationBase).loopValue;
      case LinearAnimationBase.workStartPropertyKey:
        return (object as LinearAnimationBase).workStart;
      case LinearAnimationBase.workEndPropertyKey:
        return (object as LinearAnimationBase).workEnd;
      case StrokeBase.capPropertyKey:
        return (object as StrokeBase).cap;
      case StrokeBase.joinPropertyKey:
        return (object as StrokeBase).join;
      case TrimPathBase.modeValuePropertyKey:
        return (object as TrimPathBase).modeValue;
      case FillBase.fillRulePropertyKey:
        return (object as FillBase).fillRule;
      case PathBase.pathFlagsPropertyKey:
        return (object as PathBase).pathFlags;
      case DrawableBase.blendModeValuePropertyKey:
        return (object as DrawableBase).blendModeValue;
      case DrawableBase.drawableFlagsPropertyKey:
        return (object as DrawableBase).drawableFlags;
      case WeightBase.valuesPropertyKey:
        return (object as WeightBase).values;
      case WeightBase.indicesPropertyKey:
        return (object as WeightBase).indices;
      case CubicWeightBase.inValuesPropertyKey:
        return (object as CubicWeightBase).inValues;
      case CubicWeightBase.inIndicesPropertyKey:
        return (object as CubicWeightBase).inIndices;
      case CubicWeightBase.outValuesPropertyKey:
        return (object as CubicWeightBase).outValues;
      case CubicWeightBase.outIndicesPropertyKey:
        return (object as CubicWeightBase).outIndices;
      case ClippingShapeBase.sourceIdPropertyKey:
        return (object as ClippingShapeBase).sourceId;
      case ClippingShapeBase.fillRulePropertyKey:
        return (object as ClippingShapeBase).fillRule;
      case PolygonBase.pointsPropertyKey:
        return (object as PolygonBase).points;
      case DrawRulesBase.drawTargetIdPropertyKey:
        return (object as DrawRulesBase).drawTargetId;
      case TendonBase.boneIdPropertyKey:
        return (object as TendonBase).boneId;
    }
    return 0;
  }

  static double getDouble(Core object, int propertyKey) {
    switch (propertyKey) {
      case StateMachineDoubleBase.valuePropertyKey:
        return (object as StateMachineDoubleBase).value;
      case CubicInterpolatorBase.x1PropertyKey:
        return (object as CubicInterpolatorBase).x1;
      case CubicInterpolatorBase.y1PropertyKey:
        return (object as CubicInterpolatorBase).y1;
      case CubicInterpolatorBase.x2PropertyKey:
        return (object as CubicInterpolatorBase).x2;
      case CubicInterpolatorBase.y2PropertyKey:
        return (object as CubicInterpolatorBase).y2;
      case TransitionDoubleConditionBase.valuePropertyKey:
        return (object as TransitionDoubleConditionBase).value;
      case KeyFrameDoubleBase.valuePropertyKey:
        return (object as KeyFrameDoubleBase).value;
      case LinearAnimationBase.speedPropertyKey:
        return (object as LinearAnimationBase).speed;
      case LinearGradientBase.startXPropertyKey:
        return (object as LinearGradientBase).startX;
      case LinearGradientBase.startYPropertyKey:
        return (object as LinearGradientBase).startY;
      case LinearGradientBase.endXPropertyKey:
        return (object as LinearGradientBase).endX;
      case LinearGradientBase.endYPropertyKey:
        return (object as LinearGradientBase).endY;
      case LinearGradientBase.opacityPropertyKey:
        return (object as LinearGradientBase).opacity;
      case StrokeBase.thicknessPropertyKey:
        return (object as StrokeBase).thickness;
      case GradientStopBase.positionPropertyKey:
        return (object as GradientStopBase).position;
      case TrimPathBase.startPropertyKey:
        return (object as TrimPathBase).start;
      case TrimPathBase.endPropertyKey:
        return (object as TrimPathBase).end;
      case TrimPathBase.offsetPropertyKey:
        return (object as TrimPathBase).offset;
      case TransformComponentBase.rotationPropertyKey:
        return (object as TransformComponentBase).rotation;
      case TransformComponentBase.scaleXPropertyKey:
        return (object as TransformComponentBase).scaleX;
      case TransformComponentBase.scaleYPropertyKey:
        return (object as TransformComponentBase).scaleY;
      case TransformComponentBase.opacityPropertyKey:
        return (object as TransformComponentBase).opacity;
      case NodeBase.xPropertyKey:
        return (object as NodeBase).x;
      case NodeBase.yPropertyKey:
        return (object as NodeBase).y;
      case PathVertexBase.xPropertyKey:
        return (object as PathVertexBase).x;
      case PathVertexBase.yPropertyKey:
        return (object as PathVertexBase).y;
      case StraightVertexBase.radiusPropertyKey:
        return (object as StraightVertexBase).radius;
      case CubicAsymmetricVertexBase.rotationPropertyKey:
        return (object as CubicAsymmetricVertexBase).rotation;
      case CubicAsymmetricVertexBase.inDistancePropertyKey:
        return (object as CubicAsymmetricVertexBase).inDistance;
      case CubicAsymmetricVertexBase.outDistancePropertyKey:
        return (object as CubicAsymmetricVertexBase).outDistance;
      case ParametricPathBase.widthPropertyKey:
        return (object as ParametricPathBase).width;
      case ParametricPathBase.heightPropertyKey:
        return (object as ParametricPathBase).height;
      case ParametricPathBase.originXPropertyKey:
        return (object as ParametricPathBase).originX;
      case ParametricPathBase.originYPropertyKey:
        return (object as ParametricPathBase).originY;
      case RectangleBase.cornerRadiusPropertyKey:
        return (object as RectangleBase).cornerRadius;
      case CubicMirroredVertexBase.rotationPropertyKey:
        return (object as CubicMirroredVertexBase).rotation;
      case CubicMirroredVertexBase.distancePropertyKey:
        return (object as CubicMirroredVertexBase).distance;
      case PolygonBase.cornerRadiusPropertyKey:
        return (object as PolygonBase).cornerRadius;
      case StarBase.innerRadiusPropertyKey:
        return (object as StarBase).innerRadius;
      case CubicDetachedVertexBase.inRotationPropertyKey:
        return (object as CubicDetachedVertexBase).inRotation;
      case CubicDetachedVertexBase.inDistancePropertyKey:
        return (object as CubicDetachedVertexBase).inDistance;
      case CubicDetachedVertexBase.outRotationPropertyKey:
        return (object as CubicDetachedVertexBase).outRotation;
      case CubicDetachedVertexBase.outDistancePropertyKey:
        return (object as CubicDetachedVertexBase).outDistance;
      case ArtboardBase.widthPropertyKey:
        return (object as ArtboardBase).width;
      case ArtboardBase.heightPropertyKey:
        return (object as ArtboardBase).height;
      case ArtboardBase.xPropertyKey:
        return (object as ArtboardBase).x;
      case ArtboardBase.yPropertyKey:
        return (object as ArtboardBase).y;
      case ArtboardBase.originXPropertyKey:
        return (object as ArtboardBase).originX;
      case ArtboardBase.originYPropertyKey:
        return (object as ArtboardBase).originY;
      case BoneBase.lengthPropertyKey:
        return (object as BoneBase).length;
      case RootBoneBase.xPropertyKey:
        return (object as RootBoneBase).x;
      case RootBoneBase.yPropertyKey:
        return (object as RootBoneBase).y;
      case SkinBase.xxPropertyKey:
        return (object as SkinBase).xx;
      case SkinBase.yxPropertyKey:
        return (object as SkinBase).yx;
      case SkinBase.xyPropertyKey:
        return (object as SkinBase).xy;
      case SkinBase.yyPropertyKey:
        return (object as SkinBase).yy;
      case SkinBase.txPropertyKey:
        return (object as SkinBase).tx;
      case SkinBase.tyPropertyKey:
        return (object as SkinBase).ty;
      case TendonBase.xxPropertyKey:
        return (object as TendonBase).xx;
      case TendonBase.yxPropertyKey:
        return (object as TendonBase).yx;
      case TendonBase.xyPropertyKey:
        return (object as TendonBase).xy;
      case TendonBase.yyPropertyKey:
        return (object as TendonBase).yy;
      case TendonBase.txPropertyKey:
        return (object as TendonBase).tx;
      case TendonBase.tyPropertyKey:
        return (object as TendonBase).ty;
    }
    return 0.0;
  }

  static int getColor(Core object, int propertyKey) {
    switch (propertyKey) {
      case KeyFrameColorBase.valuePropertyKey:
        return (object as KeyFrameColorBase).value;
      case SolidColorBase.colorValuePropertyKey:
        return (object as SolidColorBase).colorValue;
      case GradientStopBase.colorValuePropertyKey:
        return (object as GradientStopBase).colorValue;
    }
    return 0;
  }

  static bool getBool(Core object, int propertyKey) {
    switch (propertyKey) {
      case LinearAnimationBase.enableWorkAreaPropertyKey:
        return (object as LinearAnimationBase).enableWorkArea;
      case StateMachineBoolBase.valuePropertyKey:
        return (object as StateMachineBoolBase).value;
      case ShapePaintBase.isVisiblePropertyKey:
        return (object as ShapePaintBase).isVisible;
      case StrokeBase.transformAffectsStrokePropertyKey:
        return (object as StrokeBase).transformAffectsStroke;
      case PointsPathBase.isClosedPropertyKey:
        return (object as PointsPathBase).isClosed;
      case ClippingShapeBase.isVisiblePropertyKey:
        return (object as ClippingShapeBase).isVisible;
    }
    return false;
  }

  static void setString(Core object, int propertyKey, String value) {
    switch (propertyKey) {
      case ComponentBase.namePropertyKey:
        (object as ComponentBase).name = value;
        break;
      case StateMachineComponentBase.namePropertyKey:
        (object as StateMachineComponentBase).name = value;
        break;
      case AnimationBase.namePropertyKey:
        (object as AnimationBase).name = value;
        break;
    }
  }

  static void setUint(Core object, int propertyKey, int value) {
    switch (propertyKey) {
      case ComponentBase.parentIdPropertyKey:
        (object as ComponentBase).parentId = value;
        break;
      case DrawTargetBase.drawableIdPropertyKey:
        (object as DrawTargetBase).drawableId = value;
        break;
      case DrawTargetBase.placementValuePropertyKey:
        (object as DrawTargetBase).placementValue = value;
        break;
      case AnimationStateBase.animationIdPropertyKey:
        (object as AnimationStateBase).animationId = value;
        break;
      case KeyedObjectBase.objectIdPropertyKey:
        (object as KeyedObjectBase).objectId = value;
        break;
      case TransitionConditionBase.inputIdPropertyKey:
        (object as TransitionConditionBase).inputId = value;
        break;
      case KeyedPropertyBase.propertyKeyPropertyKey:
        (object as KeyedPropertyBase).propertyKey = value;
        break;
      case KeyFrameBase.framePropertyKey:
        (object as KeyFrameBase).frame = value;
        break;
      case KeyFrameBase.interpolationTypePropertyKey:
        (object as KeyFrameBase).interpolationType = value;
        break;
      case KeyFrameBase.interpolatorIdPropertyKey:
        (object as KeyFrameBase).interpolatorId = value;
        break;
      case KeyFrameIdBase.valuePropertyKey:
        (object as KeyFrameIdBase).value = value;
        break;
      case TransitionValueConditionBase.opValuePropertyKey:
        (object as TransitionValueConditionBase).opValue = value;
        break;
      case StateTransitionBase.stateToIdPropertyKey:
        (object as StateTransitionBase).stateToId = value;
        break;
      case StateTransitionBase.flagsPropertyKey:
        (object as StateTransitionBase).flags = value;
        break;
      case StateTransitionBase.durationPropertyKey:
        (object as StateTransitionBase).duration = value;
        break;
      case LinearAnimationBase.fpsPropertyKey:
        (object as LinearAnimationBase).fps = value;
        break;
      case LinearAnimationBase.durationPropertyKey:
        (object as LinearAnimationBase).duration = value;
        break;
      case LinearAnimationBase.loopValuePropertyKey:
        (object as LinearAnimationBase).loopValue = value;
        break;
      case LinearAnimationBase.workStartPropertyKey:
        (object as LinearAnimationBase).workStart = value;
        break;
      case LinearAnimationBase.workEndPropertyKey:
        (object as LinearAnimationBase).workEnd = value;
        break;
      case StrokeBase.capPropertyKey:
        (object as StrokeBase).cap = value;
        break;
      case StrokeBase.joinPropertyKey:
        (object as StrokeBase).join = value;
        break;
      case TrimPathBase.modeValuePropertyKey:
        (object as TrimPathBase).modeValue = value;
        break;
      case FillBase.fillRulePropertyKey:
        (object as FillBase).fillRule = value;
        break;
      case PathBase.pathFlagsPropertyKey:
        (object as PathBase).pathFlags = value;
        break;
      case DrawableBase.blendModeValuePropertyKey:
        (object as DrawableBase).blendModeValue = value;
        break;
      case DrawableBase.drawableFlagsPropertyKey:
        (object as DrawableBase).drawableFlags = value;
        break;
      case WeightBase.valuesPropertyKey:
        (object as WeightBase).values = value;
        break;
      case WeightBase.indicesPropertyKey:
        (object as WeightBase).indices = value;
        break;
      case CubicWeightBase.inValuesPropertyKey:
        (object as CubicWeightBase).inValues = value;
        break;
      case CubicWeightBase.inIndicesPropertyKey:
        (object as CubicWeightBase).inIndices = value;
        break;
      case CubicWeightBase.outValuesPropertyKey:
        (object as CubicWeightBase).outValues = value;
        break;
      case CubicWeightBase.outIndicesPropertyKey:
        (object as CubicWeightBase).outIndices = value;
        break;
      case ClippingShapeBase.sourceIdPropertyKey:
        (object as ClippingShapeBase).sourceId = value;
        break;
      case ClippingShapeBase.fillRulePropertyKey:
        (object as ClippingShapeBase).fillRule = value;
        break;
      case PolygonBase.pointsPropertyKey:
        (object as PolygonBase).points = value;
        break;
      case DrawRulesBase.drawTargetIdPropertyKey:
        (object as DrawRulesBase).drawTargetId = value;
        break;
      case TendonBase.boneIdPropertyKey:
        (object as TendonBase).boneId = value;
        break;
    }
  }

  static void setDouble(Core object, int propertyKey, double value) {
    switch (propertyKey) {
      case StateMachineDoubleBase.valuePropertyKey:
        (object as StateMachineDoubleBase).value = value;
        break;
      case CubicInterpolatorBase.x1PropertyKey:
        (object as CubicInterpolatorBase).x1 = value;
        break;
      case CubicInterpolatorBase.y1PropertyKey:
        (object as CubicInterpolatorBase).y1 = value;
        break;
      case CubicInterpolatorBase.x2PropertyKey:
        (object as CubicInterpolatorBase).x2 = value;
        break;
      case CubicInterpolatorBase.y2PropertyKey:
        (object as CubicInterpolatorBase).y2 = value;
        break;
      case TransitionDoubleConditionBase.valuePropertyKey:
        (object as TransitionDoubleConditionBase).value = value;
        break;
      case KeyFrameDoubleBase.valuePropertyKey:
        (object as KeyFrameDoubleBase).value = value;
        break;
      case LinearAnimationBase.speedPropertyKey:
        (object as LinearAnimationBase).speed = value;
        break;
      case LinearGradientBase.startXPropertyKey:
        (object as LinearGradientBase).startX = value;
        break;
      case LinearGradientBase.startYPropertyKey:
        (object as LinearGradientBase).startY = value;
        break;
      case LinearGradientBase.endXPropertyKey:
        (object as LinearGradientBase).endX = value;
        break;
      case LinearGradientBase.endYPropertyKey:
        (object as LinearGradientBase).endY = value;
        break;
      case LinearGradientBase.opacityPropertyKey:
        (object as LinearGradientBase).opacity = value;
        break;
      case StrokeBase.thicknessPropertyKey:
        (object as StrokeBase).thickness = value;
        break;
      case GradientStopBase.positionPropertyKey:
        (object as GradientStopBase).position = value;
        break;
      case TrimPathBase.startPropertyKey:
        (object as TrimPathBase).start = value;
        break;
      case TrimPathBase.endPropertyKey:
        (object as TrimPathBase).end = value;
        break;
      case TrimPathBase.offsetPropertyKey:
        (object as TrimPathBase).offset = value;
        break;
      case TransformComponentBase.rotationPropertyKey:
        (object as TransformComponentBase).rotation = value;
        break;
      case TransformComponentBase.scaleXPropertyKey:
        (object as TransformComponentBase).scaleX = value;
        break;
      case TransformComponentBase.scaleYPropertyKey:
        (object as TransformComponentBase).scaleY = value;
        break;
      case TransformComponentBase.opacityPropertyKey:
        (object as TransformComponentBase).opacity = value;
        break;
      case NodeBase.xPropertyKey:
        (object as NodeBase).x = value;
        break;
      case NodeBase.yPropertyKey:
        (object as NodeBase).y = value;
        break;
      case PathVertexBase.xPropertyKey:
        (object as PathVertexBase).x = value;
        break;
      case PathVertexBase.yPropertyKey:
        (object as PathVertexBase).y = value;
        break;
      case StraightVertexBase.radiusPropertyKey:
        (object as StraightVertexBase).radius = value;
        break;
      case CubicAsymmetricVertexBase.rotationPropertyKey:
        (object as CubicAsymmetricVertexBase).rotation = value;
        break;
      case CubicAsymmetricVertexBase.inDistancePropertyKey:
        (object as CubicAsymmetricVertexBase).inDistance = value;
        break;
      case CubicAsymmetricVertexBase.outDistancePropertyKey:
        (object as CubicAsymmetricVertexBase).outDistance = value;
        break;
      case ParametricPathBase.widthPropertyKey:
        (object as ParametricPathBase).width = value;
        break;
      case ParametricPathBase.heightPropertyKey:
        (object as ParametricPathBase).height = value;
        break;
      case ParametricPathBase.originXPropertyKey:
        (object as ParametricPathBase).originX = value;
        break;
      case ParametricPathBase.originYPropertyKey:
        (object as ParametricPathBase).originY = value;
        break;
      case RectangleBase.cornerRadiusPropertyKey:
        (object as RectangleBase).cornerRadius = value;
        break;
      case CubicMirroredVertexBase.rotationPropertyKey:
        (object as CubicMirroredVertexBase).rotation = value;
        break;
      case CubicMirroredVertexBase.distancePropertyKey:
        (object as CubicMirroredVertexBase).distance = value;
        break;
      case PolygonBase.cornerRadiusPropertyKey:
        (object as PolygonBase).cornerRadius = value;
        break;
      case StarBase.innerRadiusPropertyKey:
        (object as StarBase).innerRadius = value;
        break;
      case CubicDetachedVertexBase.inRotationPropertyKey:
        (object as CubicDetachedVertexBase).inRotation = value;
        break;
      case CubicDetachedVertexBase.inDistancePropertyKey:
        (object as CubicDetachedVertexBase).inDistance = value;
        break;
      case CubicDetachedVertexBase.outRotationPropertyKey:
        (object as CubicDetachedVertexBase).outRotation = value;
        break;
      case CubicDetachedVertexBase.outDistancePropertyKey:
        (object as CubicDetachedVertexBase).outDistance = value;
        break;
      case ArtboardBase.widthPropertyKey:
        (object as ArtboardBase).width = value;
        break;
      case ArtboardBase.heightPropertyKey:
        (object as ArtboardBase).height = value;
        break;
      case ArtboardBase.xPropertyKey:
        (object as ArtboardBase).x = value;
        break;
      case ArtboardBase.yPropertyKey:
        (object as ArtboardBase).y = value;
        break;
      case ArtboardBase.originXPropertyKey:
        (object as ArtboardBase).originX = value;
        break;
      case ArtboardBase.originYPropertyKey:
        (object as ArtboardBase).originY = value;
        break;
      case BoneBase.lengthPropertyKey:
        (object as BoneBase).length = value;
        break;
      case RootBoneBase.xPropertyKey:
        (object as RootBoneBase).x = value;
        break;
      case RootBoneBase.yPropertyKey:
        (object as RootBoneBase).y = value;
        break;
      case SkinBase.xxPropertyKey:
        (object as SkinBase).xx = value;
        break;
      case SkinBase.yxPropertyKey:
        (object as SkinBase).yx = value;
        break;
      case SkinBase.xyPropertyKey:
        (object as SkinBase).xy = value;
        break;
      case SkinBase.yyPropertyKey:
        (object as SkinBase).yy = value;
        break;
      case SkinBase.txPropertyKey:
        (object as SkinBase).tx = value;
        break;
      case SkinBase.tyPropertyKey:
        (object as SkinBase).ty = value;
        break;
      case TendonBase.xxPropertyKey:
        (object as TendonBase).xx = value;
        break;
      case TendonBase.yxPropertyKey:
        (object as TendonBase).yx = value;
        break;
      case TendonBase.xyPropertyKey:
        (object as TendonBase).xy = value;
        break;
      case TendonBase.yyPropertyKey:
        (object as TendonBase).yy = value;
        break;
      case TendonBase.txPropertyKey:
        (object as TendonBase).tx = value;
        break;
      case TendonBase.tyPropertyKey:
        (object as TendonBase).ty = value;
        break;
    }
  }

  static void setColor(Core object, int propertyKey, int value) {
    switch (propertyKey) {
      case KeyFrameColorBase.valuePropertyKey:
        (object as KeyFrameColorBase).value = value;
        break;
      case SolidColorBase.colorValuePropertyKey:
        (object as SolidColorBase).colorValue = value;
        break;
      case GradientStopBase.colorValuePropertyKey:
        (object as GradientStopBase).colorValue = value;
        break;
    }
  }

  static void setBool(Core object, int propertyKey, bool value) {
    switch (propertyKey) {
      case LinearAnimationBase.enableWorkAreaPropertyKey:
        (object as LinearAnimationBase).enableWorkArea = value;
        break;
      case StateMachineBoolBase.valuePropertyKey:
        (object as StateMachineBoolBase).value = value;
        break;
      case ShapePaintBase.isVisiblePropertyKey:
        (object as ShapePaintBase).isVisible = value;
        break;
      case StrokeBase.transformAffectsStrokePropertyKey:
        (object as StrokeBase).transformAffectsStroke = value;
        break;
      case PointsPathBase.isClosedPropertyKey:
        (object as PointsPathBase).isClosed = value;
        break;
      case ClippingShapeBase.isVisiblePropertyKey:
        (object as ClippingShapeBase).isVisible = value;
        break;
    }
  }
}

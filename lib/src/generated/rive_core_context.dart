import 'package:rive/src/core/core.dart';
import 'package:rive/src/core/field_types/core_bool_type.dart';
import 'package:rive/src/core/field_types/core_color_type.dart';
import 'package:rive/src/core/field_types/core_double_type.dart';
import 'package:rive/src/core/field_types/core_field_type.dart';
import 'package:rive/src/core/field_types/core_int_type.dart';
import 'package:rive/src/core/field_types/core_string_type.dart';
import 'package:rive/src/core/field_types/core_uint_type.dart';
import 'package:rive/src/generated/animation/animation_base.dart';
import 'package:rive/src/generated/animation/cubic_interpolator_base.dart';
import 'package:rive/src/generated/animation/keyed_object_base.dart';
import 'package:rive/src/generated/animation/keyed_property_base.dart';
import 'package:rive/src/generated/animation/keyframe_base.dart';
import 'package:rive/src/generated/animation/keyframe_color_base.dart';
import 'package:rive/src/generated/animation/keyframe_double_base.dart';
import 'package:rive/src/generated/animation/keyframe_draw_order_base.dart';
import 'package:rive/src/generated/animation/keyframe_draw_order_value_base.dart';
import 'package:rive/src/generated/animation/linear_animation_base.dart';
import 'package:rive/src/generated/artboard_base.dart';
import 'package:rive/src/generated/backboard_base.dart';
import 'package:rive/src/generated/component_base.dart';
import 'package:rive/src/generated/drawable_base.dart';
import 'package:rive/src/generated/node_base.dart';
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
import 'package:rive/src/generated/shapes/parametric_path_base.dart';
import 'package:rive/src/generated/shapes/path_composer_base.dart';
import 'package:rive/src/generated/shapes/path_vertex_base.dart';
import 'package:rive/src/generated/shapes/points_path_base.dart';
import 'package:rive/src/generated/shapes/rectangle_base.dart';
import 'package:rive/src/generated/shapes/shape_base.dart';
import 'package:rive/src/generated/shapes/straight_vertex_base.dart';
import 'package:rive/src/generated/shapes/triangle_base.dart';
import 'package:rive/src/rive_core/animation/animation.dart';
import 'package:rive/src/rive_core/animation/cubic_interpolator.dart';
import 'package:rive/src/rive_core/animation/keyed_object.dart';
import 'package:rive/src/rive_core/animation/keyed_property.dart';
import 'package:rive/src/rive_core/animation/keyframe_color.dart';
import 'package:rive/src/rive_core/animation/keyframe_double.dart';
import 'package:rive/src/rive_core/animation/keyframe_draw_order.dart';
import 'package:rive/src/rive_core/animation/keyframe_draw_order_value.dart';
import 'package:rive/src/rive_core/animation/linear_animation.dart';
import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/rive_core/backboard.dart';
import 'package:rive/src/rive_core/node.dart';
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
import 'package:rive/src/rive_core/shapes/path_composer.dart';
import 'package:rive/src/rive_core/shapes/points_path.dart';
import 'package:rive/src/rive_core/shapes/rectangle.dart';
import 'package:rive/src/rive_core/shapes/shape.dart';
import 'package:rive/src/rive_core/shapes/straight_vertex.dart';
import 'package:rive/src/rive_core/shapes/triangle.dart';

// ignore: avoid_classes_with_only_static_members
class RiveCoreContext {
  static Core makeCoreInstance(int typeKey) {
    switch (typeKey) {
      case KeyedObjectBase.typeKey:
        return KeyedObject();
      case KeyedPropertyBase.typeKey:
        return KeyedProperty();
      case AnimationBase.typeKey:
        return Animation();
      case CubicInterpolatorBase.typeKey:
        return CubicInterpolator();
      case KeyFrameDoubleBase.typeKey:
        return KeyFrameDouble();
      case KeyFrameColorBase.typeKey:
        return KeyFrameColor();
      case LinearAnimationBase.typeKey:
        return LinearAnimation();
      case KeyFrameDrawOrderBase.typeKey:
        return KeyFrameDrawOrder();
      case KeyFrameDrawOrderValueBase.typeKey:
        return KeyFrameDrawOrderValue();
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
      case FillBase.typeKey:
        return Fill();
      case NodeBase.typeKey:
        return Node();
      case ShapeBase.typeKey:
        return Shape();
      case StraightVertexBase.typeKey:
        return StraightVertex();
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
      case PathComposerBase.typeKey:
        return PathComposer();
      case CubicDetachedVertexBase.typeKey:
        return CubicDetachedVertex();
      case ArtboardBase.typeKey:
        return Artboard();
      case BackboardBase.typeKey:
        return Backboard();
      default:
        return null;
    }
  }

  static void setObjectProperty(Core object, int propertyKey, Object value) {
    switch (propertyKey) {
      case KeyedObjectBase.objectIdPropertyKey:
        if (object is KeyedObjectBase && value is int) {
          object.objectId = value;
        }
        break;
      case KeyedPropertyBase.propertyKeyPropertyKey:
        if (object is KeyedPropertyBase && value is int) {
          object.propertyKey = value;
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
        if (object is KeyFrameBase) {
          if (value is int) {
            object.interpolatorId = value;
          } else if (value == null) {
            object.interpolatorId = null;
          }
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
      case KeyFrameDrawOrderValueBase.drawableIdPropertyKey:
        if (object is KeyFrameDrawOrderValueBase && value is int) {
          object.drawableId = value;
        }
        break;
      case KeyFrameDrawOrderValueBase.valuePropertyKey:
        if (object is KeyFrameDrawOrderValueBase && value is int) {
          object.value = value;
        }
        break;
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
      case FillBase.fillRulePropertyKey:
        if (object is FillBase && value is int) {
          object.fillRule = value;
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
      case NodeBase.rotationPropertyKey:
        if (object is NodeBase && value is double) {
          object.rotation = value;
        }
        break;
      case NodeBase.scaleXPropertyKey:
        if (object is NodeBase && value is double) {
          object.scaleX = value;
        }
        break;
      case NodeBase.scaleYPropertyKey:
        if (object is NodeBase && value is double) {
          object.scaleY = value;
        }
        break;
      case NodeBase.opacityPropertyKey:
        if (object is NodeBase && value is double) {
          object.opacity = value;
        }
        break;
      case DrawableBase.drawOrderPropertyKey:
        if (object is DrawableBase && value is int) {
          object.drawOrder = value;
        }
        break;
      case DrawableBase.blendModeValuePropertyKey:
        if (object is DrawableBase && value is int) {
          object.blendModeValue = value;
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
      case StraightVertexBase.radiusPropertyKey:
        if (object is StraightVertexBase && value is double) {
          object.radius = value;
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
    }
  }

  static CoreFieldType uintType = CoreUintType();
  static CoreFieldType intType = CoreIntType();
  static CoreFieldType stringType = CoreStringType();
  static CoreFieldType doubleType = CoreDoubleType();
  static CoreFieldType colorType = CoreColorType();
  static CoreFieldType boolType = CoreBoolType();
  static CoreFieldType coreType(int propertyKey) {
    switch (propertyKey) {
      case KeyedObjectBase.objectIdPropertyKey:
      case KeyFrameBase.interpolatorIdPropertyKey:
      case KeyFrameDrawOrderValueBase.drawableIdPropertyKey:
      case KeyFrameDrawOrderValueBase.valuePropertyKey:
      case ComponentBase.parentIdPropertyKey:
      case DrawableBase.drawOrderPropertyKey:
        return uintType;
      case KeyedPropertyBase.propertyKeyPropertyKey:
      case KeyFrameBase.framePropertyKey:
      case KeyFrameBase.interpolationTypePropertyKey:
      case LinearAnimationBase.fpsPropertyKey:
      case LinearAnimationBase.durationPropertyKey:
      case LinearAnimationBase.loopValuePropertyKey:
      case LinearAnimationBase.workStartPropertyKey:
      case LinearAnimationBase.workEndPropertyKey:
      case StrokeBase.capPropertyKey:
      case StrokeBase.joinPropertyKey:
      case FillBase.fillRulePropertyKey:
      case DrawableBase.blendModeValuePropertyKey:
        return intType;
      case AnimationBase.namePropertyKey:
      case ComponentBase.namePropertyKey:
        return stringType;
      case CubicInterpolatorBase.x1PropertyKey:
      case CubicInterpolatorBase.y1PropertyKey:
      case CubicInterpolatorBase.x2PropertyKey:
      case CubicInterpolatorBase.y2PropertyKey:
      case KeyFrameDoubleBase.valuePropertyKey:
      case LinearAnimationBase.speedPropertyKey:
      case LinearGradientBase.startXPropertyKey:
      case LinearGradientBase.startYPropertyKey:
      case LinearGradientBase.endXPropertyKey:
      case LinearGradientBase.endYPropertyKey:
      case LinearGradientBase.opacityPropertyKey:
      case StrokeBase.thicknessPropertyKey:
      case GradientStopBase.positionPropertyKey:
      case NodeBase.xPropertyKey:
      case NodeBase.yPropertyKey:
      case NodeBase.rotationPropertyKey:
      case NodeBase.scaleXPropertyKey:
      case NodeBase.scaleYPropertyKey:
      case NodeBase.opacityPropertyKey:
      case PathVertexBase.xPropertyKey:
      case PathVertexBase.yPropertyKey:
      case StraightVertexBase.radiusPropertyKey:
      case CubicAsymmetricVertexBase.rotationPropertyKey:
      case CubicAsymmetricVertexBase.inDistancePropertyKey:
      case CubicAsymmetricVertexBase.outDistancePropertyKey:
      case ParametricPathBase.widthPropertyKey:
      case ParametricPathBase.heightPropertyKey:
      case RectangleBase.cornerRadiusPropertyKey:
      case CubicMirroredVertexBase.rotationPropertyKey:
      case CubicMirroredVertexBase.distancePropertyKey:
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
        return doubleType;
      case KeyFrameColorBase.valuePropertyKey:
      case SolidColorBase.colorValuePropertyKey:
      case GradientStopBase.colorValuePropertyKey:
        return colorType;
      case LinearAnimationBase.enableWorkAreaPropertyKey:
      case ShapePaintBase.isVisiblePropertyKey:
      case StrokeBase.transformAffectsStrokePropertyKey:
      case PointsPathBase.isClosedPropertyKey:
        return boolType;
      default:
        return null;
    }
  }

  static int getUint(Core object, int propertyKey) {
    switch (propertyKey) {
      case KeyedObjectBase.objectIdPropertyKey:
        return (object as KeyedObjectBase).objectId;
      case KeyFrameBase.interpolatorIdPropertyKey:
        return (object as KeyFrameBase).interpolatorId;
      case KeyFrameDrawOrderValueBase.drawableIdPropertyKey:
        return (object as KeyFrameDrawOrderValueBase).drawableId;
      case KeyFrameDrawOrderValueBase.valuePropertyKey:
        return (object as KeyFrameDrawOrderValueBase).value;
      case ComponentBase.parentIdPropertyKey:
        return (object as ComponentBase).parentId;
      case DrawableBase.drawOrderPropertyKey:
        return (object as DrawableBase).drawOrder;
    }
    return 0;
  }

  static int getInt(Core object, int propertyKey) {
    switch (propertyKey) {
      case KeyedPropertyBase.propertyKeyPropertyKey:
        return (object as KeyedPropertyBase).propertyKey;
      case KeyFrameBase.framePropertyKey:
        return (object as KeyFrameBase).frame;
      case KeyFrameBase.interpolationTypePropertyKey:
        return (object as KeyFrameBase).interpolationType;
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
      case FillBase.fillRulePropertyKey:
        return (object as FillBase).fillRule;
      case DrawableBase.blendModeValuePropertyKey:
        return (object as DrawableBase).blendModeValue;
    }
    return 0;
  }

  static String getString(Core object, int propertyKey) {
    switch (propertyKey) {
      case AnimationBase.namePropertyKey:
        return (object as AnimationBase).name;
      case ComponentBase.namePropertyKey:
        return (object as ComponentBase).name;
    }
    return null;
  }

  static double getDouble(Core object, int propertyKey) {
    switch (propertyKey) {
      case CubicInterpolatorBase.x1PropertyKey:
        return (object as CubicInterpolatorBase).x1;
      case CubicInterpolatorBase.y1PropertyKey:
        return (object as CubicInterpolatorBase).y1;
      case CubicInterpolatorBase.x2PropertyKey:
        return (object as CubicInterpolatorBase).x2;
      case CubicInterpolatorBase.y2PropertyKey:
        return (object as CubicInterpolatorBase).y2;
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
      case NodeBase.xPropertyKey:
        return (object as NodeBase).x;
      case NodeBase.yPropertyKey:
        return (object as NodeBase).y;
      case NodeBase.rotationPropertyKey:
        return (object as NodeBase).rotation;
      case NodeBase.scaleXPropertyKey:
        return (object as NodeBase).scaleX;
      case NodeBase.scaleYPropertyKey:
        return (object as NodeBase).scaleY;
      case NodeBase.opacityPropertyKey:
        return (object as NodeBase).opacity;
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
      case RectangleBase.cornerRadiusPropertyKey:
        return (object as RectangleBase).cornerRadius;
      case CubicMirroredVertexBase.rotationPropertyKey:
        return (object as CubicMirroredVertexBase).rotation;
      case CubicMirroredVertexBase.distancePropertyKey:
        return (object as CubicMirroredVertexBase).distance;
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
      case ShapePaintBase.isVisiblePropertyKey:
        return (object as ShapePaintBase).isVisible;
      case StrokeBase.transformAffectsStrokePropertyKey:
        return (object as StrokeBase).transformAffectsStroke;
      case PointsPathBase.isClosedPropertyKey:
        return (object as PointsPathBase).isClosed;
    }
    return false;
  }

  static void setUint(Core object, int propertyKey, int value) {
    switch (propertyKey) {
      case KeyedObjectBase.objectIdPropertyKey:
        (object as KeyedObjectBase).objectId = value;
        break;
      case KeyFrameBase.interpolatorIdPropertyKey:
        (object as KeyFrameBase).interpolatorId = value;
        break;
      case KeyFrameDrawOrderValueBase.drawableIdPropertyKey:
        (object as KeyFrameDrawOrderValueBase).drawableId = value;
        break;
      case KeyFrameDrawOrderValueBase.valuePropertyKey:
        (object as KeyFrameDrawOrderValueBase).value = value;
        break;
      case ComponentBase.parentIdPropertyKey:
        (object as ComponentBase).parentId = value;
        break;
      case DrawableBase.drawOrderPropertyKey:
        (object as DrawableBase).drawOrder = value;
        break;
    }
  }

  static void setInt(Core object, int propertyKey, int value) {
    switch (propertyKey) {
      case KeyedPropertyBase.propertyKeyPropertyKey:
        (object as KeyedPropertyBase).propertyKey = value;
        break;
      case KeyFrameBase.framePropertyKey:
        (object as KeyFrameBase).frame = value;
        break;
      case KeyFrameBase.interpolationTypePropertyKey:
        (object as KeyFrameBase).interpolationType = value;
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
      case FillBase.fillRulePropertyKey:
        (object as FillBase).fillRule = value;
        break;
      case DrawableBase.blendModeValuePropertyKey:
        (object as DrawableBase).blendModeValue = value;
        break;
    }
  }

  static void setString(Core object, int propertyKey, String value) {
    switch (propertyKey) {
      case AnimationBase.namePropertyKey:
        (object as AnimationBase).name = value;
        break;
      case ComponentBase.namePropertyKey:
        (object as ComponentBase).name = value;
        break;
    }
  }

  static void setDouble(Core object, int propertyKey, double value) {
    switch (propertyKey) {
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
      case NodeBase.xPropertyKey:
        (object as NodeBase).x = value;
        break;
      case NodeBase.yPropertyKey:
        (object as NodeBase).y = value;
        break;
      case NodeBase.rotationPropertyKey:
        (object as NodeBase).rotation = value;
        break;
      case NodeBase.scaleXPropertyKey:
        (object as NodeBase).scaleX = value;
        break;
      case NodeBase.scaleYPropertyKey:
        (object as NodeBase).scaleY = value;
        break;
      case NodeBase.opacityPropertyKey:
        (object as NodeBase).opacity = value;
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
      case RectangleBase.cornerRadiusPropertyKey:
        (object as RectangleBase).cornerRadius = value;
        break;
      case CubicMirroredVertexBase.rotationPropertyKey:
        (object as CubicMirroredVertexBase).rotation = value;
        break;
      case CubicMirroredVertexBase.distancePropertyKey:
        (object as CubicMirroredVertexBase).distance = value;
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
      case ShapePaintBase.isVisiblePropertyKey:
        (object as ShapePaintBase).isVisible = value;
        break;
      case StrokeBase.transformAffectsStrokePropertyKey:
        (object as StrokeBase).transformAffectsStroke = value;
        break;
      case PointsPathBase.isClosedPropertyKey:
        (object as PointsPathBase).isClosed = value;
        break;
    }
  }
}

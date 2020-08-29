import 'dart:ui';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/animation.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/drawable.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';
import 'package:rive/src/rive_core/rive_animation_controller.dart';
import 'package:rive/src/rive_core/shapes/paint/shape_paint_mutator.dart';
import 'package:rive/src/rive_core/shapes/shape_paint_container.dart';
import 'package:rive/src/utilities/dependency_sorter.dart';
import 'package:rive/src/generated/artboard_base.dart';
export 'package:rive/src/generated/artboard_base.dart';

class Artboard extends ArtboardBase with ShapePaintContainer {
  @override
  bool get canBeOrphaned => true;
  final Path path = Path();
  List<Component> _dependencyOrder = [];
  final DrawableList _drawables = DrawableList();
  final Set<Component> _components = {};
  DrawableList get drawables => _drawables;
  final AnimationList _animations = AnimationList();
  AnimationList get animations => _animations;
  bool get hasAnimations => _animations.isNotEmpty;
  int _dirtDepth = 0;
  int _dirt = 255;
  void forEachComponent(void Function(Component) callback) =>
      _components.forEach(callback);
  @override
  Artboard get artboard => this;
  Vec2D get originWorld {
    return Vec2D.fromValues(
        x + width * (originX ?? 0), y + height * (originY ?? 0));
  }

  bool updateComponents() {
    bool didUpdate = false;
    if ((_dirt & ComponentDirt.drawOrder) != 0) {
      _drawables.sortDrawables();
      _dirt &= ~ComponentDirt.drawOrder;
      didUpdate = true;
    }
    if ((_dirt & ComponentDirt.components) != 0) {
      const int maxSteps = 100;
      int step = 0;
      int count = _dependencyOrder.length;
      while ((_dirt & ComponentDirt.components) != 0 && step < maxSteps) {
        _dirt &= ~ComponentDirt.components;
        for (int i = 0; i < count; i++) {
          Component component = _dependencyOrder[i];
          _dirtDepth = i;
          int d = component.dirt;
          if (d == 0) {
            continue;
          }
          component.dirt = 0;
          component.update(d);
          if (_dirtDepth < i) {
            break;
          }
        }
        step++;
      }
      return true;
    }
    return didUpdate;
  }

  bool advance(double elapsedSeconds) {
    bool didUpdate = false;
    for (final controller in _animationControllers) {
      if (controller.isActive) {
        controller.apply(context, elapsedSeconds);
        didUpdate = true;
      }
    }
    return updateComponents() || didUpdate;
  }

  @override
  void heightChanged(double from, double to) {
    addDirt(ComponentDirt.worldTransform);
    invalidateStrokeEffects();
  }

  void onComponentDirty(Component component) {
    if ((dirt & ComponentDirt.components) == 0) {
      context?.markNeedsAdvance();
      _dirt |= ComponentDirt.components;
    }
    if (component.graphOrder < _dirtDepth) {
      _dirtDepth = component.graphOrder;
    }
  }

  @override
  bool resolveArtboard() => true;
  void sortDependencies() {
    var optimistic = DependencySorter<Component>();
    var order = optimistic.sort(this);
    if (order == null) {
      var robust = TarjansDependencySorter<Component>();
      order = robust.sort(this);
    }
    _dependencyOrder = order;
    for (final component in _dependencyOrder) {
      component.graphOrder = graphOrder++;
    }
    _dirt |= ComponentDirt.components;
  }

  @override
  void update(int dirt) {
    if (dirt & ComponentDirt.worldTransform != 0) {
      var rect = Rect.fromLTWH(0, 0, width, height);
      path.reset();
      path.addRect(rect);
    }
  }

  @override
  void widthChanged(double from, double to) {
    addDirt(ComponentDirt.worldTransform);
    invalidateStrokeEffects();
  }

  @override
  void xChanged(double from, double to) {
    addDirt(ComponentDirt.worldTransform);
  }

  @override
  void yChanged(double from, double to) {
    addDirt(ComponentDirt.worldTransform);
  }

  Vec2D renderTranslation(Vec2D worldTranslation) {
    final wt = originWorld;
    return Vec2D.add(Vec2D(), worldTranslation, wt);
  }

  void addComponent(Component component) {
    if (!_components.add(component)) {
      return;
    }
    if (component is Drawable) {
      assert(!_drawables.contains(component));
      _drawables.add(component);
      markDrawOrderDirty();
    }
  }

  void removeComponent(Component component) {
    _components.remove(component);
    if (component is Drawable) {
      _drawables.remove(component);
    }
  }

  void markDrawOrderDirty() {
    if ((dirt & ComponentDirt.drawOrder) == 0) {
      context?.markNeedsAdvance();
      _dirt |= ComponentDirt.drawOrder;
    }
  }

  void draw(Canvas canvas) {
    for (final fill in fills) {
      fill.draw(canvas, path);
    }
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, width, height));
    canvas.translate(width * (originX ?? 0), height * (originY ?? 0));
    for (final drawable in _drawables) {
      drawable.draw(canvas);
    }
    canvas.restore();
  }

  @override
  Mat2D get worldTransform => Mat2D();
  @override
  void originXChanged(double from, double to) {
    addDirt(ComponentDirt.worldTransform);
  }

  @override
  void originYChanged(double from, double to) {
    addDirt(ComponentDirt.worldTransform);
  }

  bool internalAddAnimation(Animation animation) {
    if (_animations.contains(animation)) {
      return false;
    }
    _animations.add(animation);
    return true;
  }

  bool internalRemoveAnimation(Animation animation) {
    bool removed = _animations.remove(animation);
    return removed;
  }

  final Set<RiveAnimationController> _animationControllers = {};
  bool addController(RiveAnimationController controller) {
    assert(controller != null);
    if (_animationControllers.contains(controller) ||
        !controller.init(context)) {
      return false;
    }
    controller.isActiveChanged.addListener(_onControllerPlayingChanged);
    _animationControllers.add(controller);
    if (controller.isActive) {
      context?.markNeedsAdvance();
    }
    return true;
  }

  bool removeController(RiveAnimationController controller) {
    assert(controller != null);
    if (_animationControllers.remove(controller)) {
      controller.isActiveChanged.removeListener(_onControllerPlayingChanged);
      controller.dispose();
      return true;
    }
    return false;
  }

  void _onControllerPlayingChanged() => context?.markNeedsAdvance();
  @override
  void onFillsChanged() {}
  @override
  void onPaintMutatorChanged(ShapePaintMutator mutator) {}
  @override
  void onStrokesChanged() {}
  @override
  Vec2D get worldTranslation => Vec2D();
}

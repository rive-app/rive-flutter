import 'dart:ui';

import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/artboard_base.dart';
import 'package:rive/src/rive_core/animation/animation.dart';
import 'package:rive/src/rive_core/animation/linear_animation.dart';
import 'package:rive/src/rive_core/animation/state_machine.dart';
import 'package:rive/src/rive_core/backboard.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/draw_rules.dart';
import 'package:rive/src/rive_core/draw_target.dart';
import 'package:rive/src/rive_core/drawable.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';
import 'package:rive/src/rive_core/nested_artboard.dart';
import 'package:rive/src/rive_core/rive_animation_controller.dart';
import 'package:rive/src/rive_core/shapes/paint/shape_paint_mutator.dart';
import 'package:rive/src/rive_core/shapes/shape_paint_container.dart';
import 'package:rive/src/utilities/dependency_sorter.dart';

export 'package:rive/src/generated/artboard_base.dart';

class Artboard extends ArtboardBase with ShapePaintContainer {
  bool _frameOrigin = true;

  /// Returns true when the artboard will shift the origin from the top left to
  /// the relative width/height of the artboard itself. This is what the editor
  /// does visually when you change the origin value to give context as to where
  /// the origin lies within the framed bounds.
  bool get frameOrigin => _frameOrigin;

  /// When composing multiple artboards together in a common world-space, it may
  /// be desireable to have them share the same space regardless of origin
  /// offset from the bounding artboard. Set frameOrigin to false to move the
  /// bounds relative to the origin instead of the origin relative to the
  /// bounds.
  set frameOrigin(bool value) {
    if (_frameOrigin == value) {
      return;
    }
    _frameOrigin = value;
    addDirt(ComponentDirt.paint);
  }

  /// Should antialiasing be used when drawing?
  bool _antialiasing = true;

  bool get antialiasing => _antialiasing;
  set antialiasing(bool value) {
    if (_antialiasing == value) {
      return;
    }
    _antialiasing = value;
    // Call syncColor on all ShapePaintMutators to update antialiasing on the
    // paint objects
    forAll((c) {
      if (c is ShapePaintMutator) {
        (c as ShapePaintMutator).syncColor();
      }
      return true;
    });
  }

  /// Artboard are one of the few (only?) components that can be orphaned.
  @override
  bool get canBeOrphaned => true;

  final Path path = Path();
  List<Component> _dependencyOrder = [];
  final List<Drawable> _drawables = [];
  final List<DrawRules> _rules = [];
  List<DrawTarget> _sortedDrawRules = [];

  final Set<Component> _components = {};

  List<Drawable> get drawables => _drawables;

  final AnimationList _animations = AnimationList();

  /// List of animations and state machines in the artboard.
  AnimationList get animations => _animations;

  /// List of linear animations in the artboard.
  Iterable<LinearAnimation> get linearAnimations =>
      _animations.whereType<LinearAnimation>();

  /// List of state machines in the artboard.
  Iterable<StateMachine> get stateMachines =>
      _animations.whereType<StateMachine>();

  /// Does this artboard have animations?
  bool get hasAnimations => _animations.isNotEmpty;

  int _dirtDepth = 0;

  /// Iterate each component and call callback for it.
  void forEachComponent(void Function(Component) callback) =>
      _components.forEach(callback);

  /// Find a component of a specific type with a specific name.
  T? component<T>(String name) {
    for (final component in _components) {
      if (component is T && component.name == name) {
        return component as T;
      }
    }
    return null;
  }

  @override
  Artboard get artboard => this;

  Vec2D get originWorld {
    return Vec2D.fromValues(x + width * originX, y + height * originY);
  }

  /// Walk the dependency tree and update components in order. Returns true if
  /// any component updated.
  bool updateComponents() {
    bool didUpdate = false;

    if ((dirt & ComponentDirt.drawOrder) != 0) {
      sortDrawOrder();
      dirt &= ~ComponentDirt.drawOrder;
      didUpdate = true;
    }
    if ((dirt & ComponentDirt.components) != 0) {
      const int maxSteps = 100;
      int step = 0;
      int count = _dependencyOrder.length;
      while ((dirt & ComponentDirt.components) != 0 && step < maxSteps) {
        dirt &= ~ComponentDirt.components;
        // Track dirt depth here so that if something else marks
        // dirty, we restart.
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

  final Set<NestedArtboard> _activeNestedArtboards = {};
  Iterable<NestedArtboard> get activeNestedArtboards => _activeNestedArtboards;

  /// Update any dirty components in this artboard.
  bool advance(double elapsedSeconds, {bool nested = false}) {
    bool didUpdate = false;
    for (final controller in _animationControllers) {
      if (controller.isActive) {
        controller.apply(context, elapsedSeconds);
        didUpdate = true;
      }
    }
    if (updateComponents() || didUpdate) {
      didUpdate = true;
    }

    if (nested) {
      var active = _activeNestedArtboards.toList(growable: false);
      for (final activeNestedArtboard in active) {
        if (activeNestedArtboard.advance(elapsedSeconds)) {
          didUpdate = true;
        }
      }
    }

    return didUpdate;
  }

  @override
  void heightChanged(double from, double to) {
    addDirt(ComponentDirt.worldTransform);
    invalidateStrokeEffects();
  }

  void onComponentDirty(Component component) {
    if ((dirt & ComponentDirt.components) == 0) {
      context.markNeedsAdvance();
      dirt |= ComponentDirt.components;
    }

    /// If the order of the component is less than the current dirt depth,
    /// update the dirt depth so that the update loop can break out early and
    /// re-run (something up the tree is dirty).
    if (component.graphOrder < _dirtDepth) {
      _dirtDepth = component.graphOrder;
    }
  }

  @override
  bool resolveArtboard() => true;

  /// Sort the DAG for resolution in order of dependencies such that dependent
  /// compnents process after their dependencies.
  void sortDependencies() {
    var optimistic = DependencySorter<Component>();
    var order = optimistic.sort(this);
    if (order.isEmpty) {
      // cycle detected, use a more robust solver
      var robust = TarjansDependencySorter<Component>();
      order = robust.sort(this);
    }

    _dependencyOrder = order;
    for (final component in _dependencyOrder) {
      component.graphOrder = graphOrder++;
      // component.dirt = 255;
    }

    dirt |= ComponentDirt.components;
  }

  @override
  void update(int dirt) {
    if (dirt & ComponentDirt.worldTransform != 0) {
      var rect =
          Rect.fromLTWH(width * -originX, height * -originY, width, height);
      path.reset();
      path.addRect(rect);

      for (final fill in fills) {
        fill.renderOpacity = opacity;
      }
      for (final stroke in strokes) {
        stroke.renderOpacity = opacity;
      }
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
    return worldTranslation + wt;
  }

  /// Adds a component to the artboard. Good place for the artboard to check for
  /// components it'll later need to do stuff with (like draw them or sort them
  /// when the draw order changes).
  void addComponent(Component component) {
    if (!_components.add(component)) {
      return;
    }
    if (component is NestedArtboard) {
      _activeNestedArtboards.add(component);
    }
  }

  /// Remove a component from the artboard and its various tracked lists of
  /// components.
  void removeComponent(Component component) {
    _components.remove(component);
    if (component is NestedArtboard) {
      _activeNestedArtboards.remove(component);
    }
  }

  /// Let the artboard know that the drawables need to be resorted before
  /// drawing next.
  void markDrawOrderDirty() {
    if ((dirt & ComponentDirt.drawOrder) == 0) {
      context.markNeedsAdvance();
      dirt |= ComponentDirt.drawOrder;
    }
  }

  /// Draw the drawable components in this artboard.
  void draw(Canvas canvas) {
    canvas.save();
    if (clip) {
      if (_frameOrigin) {
        canvas.clipRect(Rect.fromLTWH(0, 0, width, height));
      } else {
        canvas.clipRect(
            Rect.fromLTWH(-width * originX, -height * originY, width, height));
      }
    }
    // Get into artboard's world space. This is because the artboard draws
    // components in the artboard's space (in component lingo we call this world
    // space). The artboards themselves are drawn in the editor's world space,
    // which is the world space that is used by stageItems. This is a little
    // confusing and perhaps we should find a better wording for the transform
    // spaces. We used "world space" in components as that's the game engine
    // ratified way of naming the top-most transformation. Perhaps we should
    // rename those to artboardTransform and worldTransform is only reserved for
    // stageItems? The other option is to stick with 'worldTransform' in
    // components and use 'editor or stageTransform' for stageItems.
    if (_frameOrigin) {
      canvas.translate(width * originX, height * originY);
    }
    for (final fill in fills) {
      fill.draw(canvas, path);
    }

    for (var drawable = _firstDrawable;
        drawable != null;
        drawable = drawable.prev) {
      if (drawable.isHidden) {
        continue;
      }
      drawable.draw(canvas);
    }
    canvas.restore();
  }

  @override
  void originXChanged(double from, double to) {
    addDirt(ComponentDirt.worldTransform);
  }

  @override
  void originYChanged(double from, double to) {
    addDirt(ComponentDirt.worldTransform);
  }

  /// Called by rive_core to add an Animation to an Artboard. This should be
  /// @internal when it's supported.
  bool internalAddAnimation(Animation animation) {
    if (_animations.contains(animation)) {
      return false;
    }
    _animations.add(animation);

    return true;
  }

  /// Called by rive_core to remove an Animation from an Artboard. This should
  /// be @internal when it's supported.
  bool internalRemoveAnimation(Animation animation) {
    bool removed = _animations.remove(animation);

    return removed;
  }

  /// The animation controllers that are called back whenever the artboard
  /// advances.
  final Set<RiveAnimationController> _animationControllers = {};

  /// Access a read-only iterator of currently applied animation controllers.
  Iterable<RiveAnimationController> get animationControllers =>
      _animationControllers;

  /// Add an animation controller to this artboard. Playing will be scheduled if
  /// it's already playing.
  bool addController(RiveAnimationController controller) {
    if (_animationControllers.contains(controller) ||
        !controller.init(context)) {
      return false;
    }
    controller.isActiveChanged.addListener(_onControllerPlayingChanged);
    _animationControllers.add(controller);
    if (controller.isActive) {
      context.markNeedsAdvance();
    }
    return true;
  }

  /// Remove an animation controller form this artboard.
  bool removeController(RiveAnimationController controller) {
    if (_animationControllers.remove(controller)) {
      controller.isActiveChanged.removeListener(_onControllerPlayingChanged);
      controller.dispose();
      return true;
    }
    return false;
  }

  void _onControllerPlayingChanged() => context.markNeedsAdvance();

  @override
  void onFillsChanged() {}

  @override
  void onPaintMutatorChanged(ShapePaintMutator mutator) {}

  @override
  void onStrokesChanged() {}

  @override
  Vec2D get worldTranslation => Vec2D();

  Drawable? _firstDrawable;

  void computeDrawOrder() {
    _drawables.clear();
    _rules.clear();
    buildDrawOrder(_drawables, null, _rules);

    // Build rule dependencies. In practice this'll need to happen anytime a
    // target drawable is changed or rule is added/removed.
    var root = DrawTarget();
    // Make sure all dependents are empty.
    for (final nodeRules in _rules) {
      for (final target in nodeRules.targets) {
        target.dependents.clear();
      }
    }

    // Now build up the dependencies.
    for (final nodeRules in _rules) {
      for (final target in nodeRules.targets) {
        root.dependents.add(target);
        var dependentRules = target.drawable?.flattenedDrawRules;
        if (dependentRules != null) {
          for (final dependentRule in dependentRules.targets) {
            dependentRule.dependents.add(target);
          }
        }
      }
    }

    var sorter = DependencySorter<Component>();

    _sortedDrawRules = sorter.sort(root).cast<DrawTarget>().skip(1).toList();

    sortDrawOrder();
  }

  void sortDrawOrder() {
    // Clear out rule first/last items.
    for (final rule in _sortedDrawRules) {
      rule.first = rule.last = null;
    }

    _firstDrawable = null;
    Drawable? lastDrawable;
    for (final drawable in _drawables) {
      var rules = drawable.flattenedDrawRules;

      var target = rules?.activeTarget;
      if (target != null) {
        if (target.first == null) {
          target.first = target.last = drawable;
          drawable.prev = drawable.next = null;
        } else {
          target.last?.next = drawable;
          drawable.prev = target.last;
          target.last = drawable;
          drawable.next = null;
        }
      } else {
        drawable.prev = lastDrawable;
        drawable.next = null;
        if (lastDrawable == null) {
          lastDrawable = _firstDrawable = drawable;
        } else {
          lastDrawable.next = drawable;
          lastDrawable = drawable;
        }
      }
    }

    for (final rule in _sortedDrawRules) {
      if (rule.first == null) {
        continue;
      }
      switch (rule.placement) {
        case DrawTargetPlacement.before:
          if (rule.drawable?.prev != null) {
            rule.drawable!.prev?.next = rule.first;
            rule.first?.prev = rule.drawable!.prev;
          }
          if (rule.drawable == _firstDrawable) {
            _firstDrawable = rule.first;
          }
          rule.drawable?.prev = rule.last;
          rule.last?.next = rule.drawable;
          break;
        case DrawTargetPlacement.after:
          if (rule.drawable?.next != null) {
            rule.drawable!.next!.prev = rule.last;
            rule.last?.next = rule.drawable?.next;
          }
          if (rule.drawable == lastDrawable) {
            lastDrawable = rule.last;
          }
          rule.drawable?.next = rule.first;
          rule.first?.prev = rule.drawable;
          break;
      }
    }

    _firstDrawable = lastDrawable;
  }

  // Make an instance of the artboard, clones internal objects and properties.
  Artboard instance() {
    /// Intentionally not implemented in the editor, must be overridden in
    /// runtime version of the artboard.
    throw UnsupportedError(
        'Instancing the artboard in the editor isn\'t supported');
  }

  @override
  void clipChanged(bool from, bool to) => addDirt(ComponentDirt.paint);

  @override
  bool import(ImportStack stack) {
    var backboardImporter =
        stack.latest<BackboardImporter>(BackboardBase.typeKey);
    if (backboardImporter != null) {
      // Backboard isn't strictly required (editor doesn't always export a
      // backboard when serializing for the clipboard, for example).
      backboardImporter.addArtboard(this);
    }

    return super.import(stack);
  }

  StateMachine? _defaultStateMachine;
  StateMachine? get defaultStateMachine => _defaultStateMachine;
  set defaultStateMachine(StateMachine? value) {
    if (_defaultStateMachine == value) {
      return;
    }

    _defaultStateMachine = value;
    defaultStateMachineId = value?.id ?? Core.missingId;
  }

  @override
  void onAddedDirty() {
    super.onAddedDirty();
    defaultStateMachine = defaultStateMachineId == Core.missingId
        ? null
        : context.resolve(defaultStateMachineId);
  }

  @override
  void defaultStateMachineIdChanged(int from, int to) {
    defaultStateMachine = to == Core.missingId ? null : context.resolve(to);
  }
}

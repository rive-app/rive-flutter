import 'dart:collection';
import 'dart:ui';

import 'package:meta/meta.dart';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/generated/artboard_base.dart';
import 'package:rive/src/rive_core/animation/animation.dart';
import 'package:rive/src/rive_core/animation/linear_animation.dart';
import 'package:rive/src/rive_core/animation/nested_bool.dart';
import 'package:rive/src/rive_core/animation/nested_number.dart';
import 'package:rive/src/rive_core/animation/nested_trigger.dart';
import 'package:rive/src/rive_core/animation/state_machine.dart';
import 'package:rive/src/rive_core/backboard.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/data_bind/data_bind.dart';
import 'package:rive/src/rive_core/data_bind/data_bind_context.dart';
import 'package:rive/src/rive_core/data_bind/data_context.dart';
import 'package:rive/src/rive_core/draw_rules.dart';
import 'package:rive/src/rive_core/draw_target.dart';
import 'package:rive/src/rive_core/drawable.dart';
import 'package:rive/src/rive_core/event.dart';
import 'package:rive/src/rive_core/joystick.dart';
import 'package:rive/src/rive_core/layout_component.dart';
import 'package:rive/src/rive_core/nested_artboard.dart';
import 'package:rive/src/rive_core/rive_animation_controller.dart';
import 'package:rive/src/rive_core/shapes/paint/shape_paint_mutator.dart';
import 'package:rive/src/rive_core/shapes/shape_paint_container.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance.dart';
import 'package:rive_common/layout_engine.dart';
import 'package:rive_common/math.dart';
import 'package:rive_common/utilities.dart';

export 'package:rive/src/generated/artboard_base.dart';

class Artboard extends ArtboardBase with ShapePaintContainer {
  final HashSet<LayoutComponent> _dirtyLayout = HashSet<LayoutComponent>();

  void markLayoutDirty(LayoutComponent layoutComponent) {
    _dirtyLayout.add(layoutComponent);
  }

  @override
  AABB get layoutBounds {
    if (!hasLayoutMeasurements()) {
      return AABB.fromValues(
        x,
        y,
        x + width,
        y + height,
      );
    }
    return super.layoutBounds;
  }

  bool _frameOrigin = true;
  bool hasChangedDrawOrderInLastUpdate = false;

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

  ViewModelInstance? viewModelInstance;

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
  final EventList _events = EventList();

  /// List of animations and state machines in the artboard.
  AnimationList get animations => _animations;

  /// List of events in the artboard.
  EventList get events => _events;

  DataContext? dataContext;
  final List<DataBind> globalDataBinds = [];

  /// List of linear animations in the artboard.
  Iterable<LinearAnimation> get linearAnimations =>
      _animations.whereType<LinearAnimation>();

  /// List of state machines in the artboard.
  Iterable<StateMachine> get stateMachines =>
      _animations.whereType<StateMachine>();

  int _dirtDepth = 0;

  /// Iterate each component and call callback for it.
  void forEachComponent(void Function(Component) callback) =>
      _components.forEach(callback);

  /// Find a component of a specific type with a specific name.
  T? component<T>(String name) {
    return getComponentWhereOrNull((component) => component.name == name);
  }

  /// Find a component that matches the given predicate.
  T? getComponentWhereOrNull<T>(bool Function(Component) callback) {
    for (final component in _components) {
      if (component is T && callback(component)) {
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

  Vec2D get origin => Vec2D.fromValues(width * originX, height * originY);

  /// Walk the dependency tree and update components in order. Returns true if
  /// any component updated.
  bool updateComponents() {
    bool didUpdate = false;

    if ((dirt & ComponentDirt.bindings) != 0) {
      computeBindings(true);
      dirt &= ~ComponentDirt.bindings;
      didUpdate = true;
    }
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

          if (d == 0 || (d & ComponentDirt.collapsed) != 0) {
            continue;
          }

          component.dirt &= ComponentDirt.collapsed;
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

  final List<Joystick> _joysticks = [];
  Iterable<Joystick> get joysticks => _joysticks;

  final List<DataBind> _dataBinds = [];
  Iterable<DataBind> get dataBinds => _dataBinds;

  bool canPreApplyJoysticks() {
    if (_joysticks.isEmpty) {
      return false;
    }
    if (_joysticks.any((joystick) => joystick.isComplex)) {
      return false;
    }
    return true;
  }

  void updateDataBinds() {
    for (final dataBind in globalDataBinds) {
      dataBind.updateSourceBinding();
      final dirt = dataBind.dirt;
      if (dirt == 0) {
        continue;
      }
      dataBind.update(dirt);
      dataBind.dirt = 0;
    }
  }

  bool applyJoysticks({bool isRoot = false}) {
    if (_joysticks.isEmpty) {
      return false;
    }
    for (final joystick in _joysticks) {
      if (isRoot) {
        updateDataBinds();
      }
      if (joystick.isComplex) {
        updateComponents();
      }
      joystick.apply(context);
    }
    return true;
  }

  /// Update any dirty components in this artboard.
  bool advanceInternal(double elapsedSeconds,
      {bool nested = false, bool isRoot = false}) {
    bool didUpdate = false;
    if (_dirtyLayout.isNotEmpty) {
      var dirtyLayout = _dirtyLayout.toList();
      _dirtyLayout.clear();
      syncStyle();
      for (final layoutComponent in dirtyLayout) {
        layoutComponent.syncStyle();
      }
      layoutNode.calculateLayout(width, height, LayoutDirection.ltr);
      if (dirt & ComponentDirt.layoutStyle != 0) {
        // Maybe we can genericize this to pass all styles to children if
        // the child should inherit
        cascadeAnimationStyle(interpolation, interpolator, interpolationTime);
      }
      // Need to sync all layout positions.
      for (final layout in _dependencyOrder.whereType<LayoutComponent>()) {
        layout.updateLayoutBounds();
        if ((layout == this && super.advance(elapsedSeconds)) ||
            (layout != this && layout.advance(elapsedSeconds))) {
          didUpdate = true;
        }
      }
    }

    for (final controller in _animationControllers) {
      if (controller.isActive) {
        controller.apply(context, elapsedSeconds);
        didUpdate = true;
      }
    }
    hasChangedDrawOrderInLastUpdate = false;

    // Joysticks can be applied before updating components if none of the
    // joysticks have "external" control. If they are controlled/moved by some
    // other component then they need to apply after the update cycle, which is
    // less efficient.
    var canApplyJoysticksEarly = canPreApplyJoysticks();
    if (canApplyJoysticksEarly) {
      applyJoysticks(isRoot: isRoot);
    }

    if (isRoot) {
      updateDataBinds();
    }
    if (updateComponents() || didUpdate) {
      didUpdate = true;
    }

    // If joysticks applied, run the update again for the animation changes.
    if (!canApplyJoysticksEarly && applyJoysticks(isRoot: isRoot)) {
      if (updateComponents()) {
        didUpdate = true;
      }
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
  bool advance(double elapsedSeconds, {bool nested = false}) {
    return advanceInternal(elapsedSeconds, nested: nested, isRoot: true);
  }

  @override
  void heightChanged(double from, double to) {
    addDirt(ComponentDirt.worldTransform);
    invalidateStrokeEffects();
    super.heightChanged(from, to);
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
  /// components process after their dependencies.
  void sortDependencies() {
    var optimistic = DependencyGraphNodeSorter<Component>();
    var order = optimistic.sort(this);
    if (order.isEmpty) {
      // cycle detected, use a more robust solver
      var robust = TarjansDependencyGraphNodeSorter<Component>();
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
    super.widthChanged(from, to);
  }

  @override
  void xChanged(double from, double to) {
    addDirt(ComponentDirt.worldTransform);
  }

  @override
  void yChanged(double from, double to) {
    addDirt(ComponentDirt.worldTransform);
  }

  @override
  void viewModelIdChanged(int from, int to) {}

  Vec2D renderTranslation(Vec2D worldTranslation) {
    final wt = originWorld;
    return worldTranslation + wt;
  }

  Mat2D get renderTransform => Mat2D.fromTranslate(x, y);

  /// Adds a component to the artboard. Good place for the artboard to check for
  /// components it'll later need to do stuff with (like draw them or sort them
  /// when the draw order changes).
  void addComponent(Component component) {
    if (!_components.add(component)) {
      return;
    }
    switch (component.coreType) {
      case NestedArtboardBase.typeKey:
        addNestedArtboard(component as NestedArtboard);
        break;
      case NestedBoolBase.typeKey:
      case NestedNumberBase.typeKey:
      case NestedTriggerBase.typeKey:
        break;
      case JoystickBase.typeKey:
        _joysticks.add(component as Joystick);
        break;
      case DataBindBase.typeKey:
      case DataBindContextBase.typeKey:
        _dataBinds.add(component as DataBind);
        break;
    }
  }

  /// Remove a component from the artboard and its various tracked lists of
  /// components.
  void removeComponent(Component component) {
    _components.remove(component);
    switch (component.coreType) {
      case NestedArtboardBase.typeKey:
        removeNestedArtboard(component as NestedArtboard);
        break;
      case NestedBoolBase.typeKey:
      case NestedNumberBase.typeKey:
      case NestedTriggerBase.typeKey:
        break;
      case JoystickBase.typeKey:
        _joysticks.remove(component as Joystick);
        break;
      case DataBindBase.typeKey:
      case DataBindContextBase.typeKey:
        _dataBinds.remove(component as DataBind);
        break;
    }
  }

  void addNestedArtboard(NestedArtboard artboard) {
    _activeNestedArtboards.add(artboard);
  }

  void removeNestedArtboard(NestedArtboard artboard) {
    _activeNestedArtboards.remove(artboard);
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
  void draw(
    Canvas canvas,
  ) {
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

    for (var drawable = firstDrawable;
        drawable != null;
        drawable = drawable.prev) {
      if (drawable.isHidden || drawable.renderOpacity == 0) {
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

  /// Called by rive_core to add an Event to an Artboard. This should be
  /// @internal when it's supported.
  bool internalAddEvent(Event event) {
    if (_events.contains(event)) {
      return false;
    }
    _events.add(event);

    return true;
  }

  /// Called by rive_core to remove an Event from an Artboard. This should
  /// be @internal when it's supported.
  bool internalRemoveEvent(Event event) {
    bool removed = _events.remove(event);

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

  @mustBeOverridden
  void play() {}

  @mustBeOverridden
  void pause() {}

  @mustBeOverridden
  bool get isPlaying => true;

  @override
  Vec2D get worldTranslation => Vec2D();

  Drawable? firstDrawable;

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

    var sorter = DependencyGraphNodeSorter<Component>();

    _sortedDrawRules = sorter.sort(root).cast<DrawTarget>().skip(1).toList();

    sortDrawOrder();
  }

  void populateDataBinds(List<DataBind> globalDataBinds) {
    dataBinds.forEach((dataBind) {
      globalDataBinds.add(dataBind);
    });

    for (final nestedArtboard in _activeNestedArtboards) {
      final mountedArtboard = nestedArtboard.mountedArtboard;
      if (mountedArtboard != null) {
        mountedArtboard.populateDataBinds(globalDataBinds);
      }
    }
  }

  void sortDataBinds() {
    globalDataBinds.sort((a, b) => a.flags.compareTo(b.flags) * -1);
  }

  void computeBindings(bool isRoot) {
    if (dataContext == null) {
      return;
    }
    for (final dataBind in dataBinds) {
      dataBind.bind(dataContext);
    }
    if (isRoot) {
      globalDataBinds.clear();
      populateDataBinds(globalDataBinds);
      sortDataBinds();
    }
  }

  void sortDrawOrder() {
    hasChangedDrawOrderInLastUpdate = true;
    // Clear out rule first/last items.
    for (final rule in _sortedDrawRules) {
      rule.first = rule.last = null;
    }

    firstDrawable = null;
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
          lastDrawable = firstDrawable = drawable;
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
          if (rule.drawable == firstDrawable) {
            firstDrawable = rule.first;
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

    firstDrawable = lastDrawable;
  }

  // Make an instance of the artboard, clones internal objects and properties.
  Artboard instance() {
    /// Intentionally not implemented in the editor, must be overridden in
    /// runtime version of the artboard.
    throw UnsupportedError(
        'Instancing the artboard in the editor isn\'t supported');
  }

  @override
  void clipChanged(bool from, bool to) {
    addDirt(ComponentDirt.paint);
  }

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
    dependencyRoot = this;
    defaultStateMachine = defaultStateMachineId == Core.missingId
        ? null
        : context.resolve(defaultStateMachineId);
  }

  @override
  void defaultStateMachineIdChanged(int from, int to) {
    defaultStateMachine = to == Core.missingId ? null : context.resolve(to);
  }

  void internalDataContext(DataContext dataContextValue,
      DataContext? parentDataContext, bool isRoot) {
    dataContext = dataContextValue;
    dataContext!.parent = parentDataContext;
    for (final nestedArtboard in _activeNestedArtboards) {
      final mountedArtboard = nestedArtboard.mountedArtboard;
      if (mountedArtboard != null) {
        ViewModelInstance? nestedViewModelInstance =
            dataContext!.getViewModelInstance(nestedArtboard.dataBindPath);
        if (nestedViewModelInstance != null) {
          mountedArtboard.setDataContextFromInstance(
              nestedViewModelInstance, dataContext, false);
        } else {
          mountedArtboard.internalDataContext(
              dataContext!, dataContext!.parent, false);
        }
      }
    }
    computeBindings(isRoot);
  }

  void setDataContextFromInstance(
      ViewModelInstance viewModelInstance, DataContext? parent, bool isRoot) {
    final dataContext = DataContext(viewModelInstance);
    internalDataContext(dataContext, parent, isRoot);
  }
}

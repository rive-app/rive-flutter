import 'package:flutter/rendering.dart';
import 'package:rive/src/controllers/state_machine_controller.dart';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/data_bind/data_bind.dart';
import 'package:rive/src/rive_core/data_bind/data_context.dart';
import 'package:rive/src/rive_core/event.dart';
import 'package:rive/src/rive_core/nested_artboard.dart';
import 'package:rive/src/rive_core/viewmodel/viewmodel_instance.dart';
import 'package:rive_common/math.dart';

/// Callback signature for events firing.
typedef OnRuntimeEvent = void Function(Event);

abstract class RuntimeEventReporter {
  void addRuntimeEventListener(OnRuntimeEvent callback);
  void removeRuntimeEventListener(OnRuntimeEvent callback);
}

class RuntimeMountedArtboard extends MountedArtboard {
  NestedArtboard nestedArtboard;
  final RuntimeArtboard artboardInstance;
  final _runtimeEventListeners = <RuntimeEventReporter>{};
  Size originalArtboardInstanceSize = const Size(0, 0);

  Set<StateMachineController> get controllers =>
      _runtimeEventListeners.whereType<StateMachineController>().toSet();

  // The callback used for bubbling events up from nested artboards
  Function(Event, NestedArtboard)? eventCallback;

  RuntimeMountedArtboard(this.artboardInstance, this.nestedArtboard) {
    // Store the initial w/h of the artboard and use that as the starting point
    originalArtboardInstanceSize =
        Size(artboardInstance.width, artboardInstance.height);
    artboardInstance.frameOrigin = false;
    artboardInstance.advance(0, nested: true);
  }

  @override
  void populateDataBinds(List<DataBind> globalDataBinds) {
    artboardInstance.populateDataBinds(globalDataBinds);
  }

  @override
  void dispose() {
    _runtimeEventListeners.clear();
    eventCallback = null;
  }

  @override
  Mat2D worldTransform = Mat2D();

  @override
  void draw(Canvas canvas) {
    canvas.save();
    canvas.transform(worldTransform.mat4);
    artboardInstance.draw(canvas);
    canvas.restore();
  }

  @override
  AABB get bounds {
    var width = originalArtboardWidth;

    var height = originalArtboardHeight;
    var x = -artboardInstance.originX * width;
    var y = -artboardInstance.originY * height;
    return AABB.fromValues(x, y, x + width, y + height);
  }

  @override
  double get renderOpacity => artboardInstance.opacity;

  @override
  double get artboardWidth => artboardInstance.width;

  @override
  set artboardWidth(double width) {
    artboardInstance.width = width;
  }

  @override
  double get artboardHeight => artboardInstance.height;

  @override
  set artboardHeight(double height) {
    artboardInstance.height = height;
  }

  @override
  void artboardWidthOverride(double width, int widthUnitValue, bool isRow) {}

  @override
  void artboardHeightOverride(double height, int heightUnitValue, bool isRow) {}

  @override
  void artboardWidthIntrinsicallySizeOverride(bool intrinsic) {}

  @override
  void artboardHeightIntrinsicallySizeOverride(bool intrinsic) {}

  @override
  void updateLayoutBounds(bool animate) {}

  @override
  double get originalArtboardWidth => originalArtboardInstanceSize.width;

  @override
  double get originalArtboardHeight => originalArtboardInstanceSize.height;

  @override
  set renderOpacity(double value) {
    artboardInstance.opacity = value;
  }

  @override
  bool advance(double seconds, {bool nested = true}) =>
      artboardInstance.advance(seconds, nested: nested);

  void addEventListener(RuntimeEventReporter listener) {
    _runtimeEventListeners.add(listener);
    listener.addRuntimeEventListener(_handleRuntimeEvent);
    // Pass an event callback into the child nested artboard's
    // mounted artboard so we get an event bubbled up to us
    artboardInstance.activeNestedArtboards.forEach((artboard) {
      if (artboard.mountedArtboard is RuntimeMountedArtboard) {
        (artboard.mountedArtboard as RuntimeMountedArtboard).eventCallback =
            _handleNestedEvent;
      }
    });
  }

  void removeEventListeners() {
    _runtimeEventListeners.forEach(
        (listener) => listener.removeRuntimeEventListener(_handleRuntimeEvent));
    _runtimeEventListeners.clear();
  }

  void _handleRuntimeEvent(Event event) {
    if (eventCallback != null) {
      eventCallback!(event, nestedArtboard);
    }
  }

  void _handleNestedEvent(Event event, NestedArtboard target) {
    _runtimeEventListeners.forEach((listener) {
      if (listener is StateMachineController &&
          listener.hasListenerWithTarget(target)) {
        listener.reportNestedEvent(event, target);
        listener.isActive = true;
      }
    });
  }

  @override
  void bindViewModelInstance(ViewModelInstance viewModelInstance,
      DataContext? dataContextValue, bool isRoot) {
    artboardInstance.bindViewModelInstance(
        viewModelInstance, dataContextValue, isRoot);
  }

  @override
  void internalDataContext(DataContext dataContextValue,
      DataContext? parentDataContext, bool isRoot) {
    artboardInstance.internalDataContext(
        dataContextValue, parentDataContext, isRoot);
  }
}

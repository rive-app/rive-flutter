import 'package:flutter/rendering.dart';
import 'package:rive/src/controllers/state_machine_controller.dart';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/event.dart';
import 'package:rive/src/rive_core/nested_artboard.dart';
import 'package:rive_common/math.dart';

class RuntimeMountedArtboard extends MountedArtboard {
  NestedArtboard nestedArtboard;
  final RuntimeArtboard artboardInstance;
  StateMachineController? controller;
  Size originalArtboardInstanceSize = const Size(0, 0);

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
  void dispose() {
    controller = null;
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
  double get originalArtboardWidth => originalArtboardInstanceSize.width;

  @override
  double get originalArtboardHeight => originalArtboardInstanceSize.height;

  @override
  set renderOpacity(double value) {
    artboardInstance.opacity = value;
  }

  @override
  bool advance(double seconds) =>
      artboardInstance.advance(seconds, nested: true);

  void addEventListener(StateMachineController listener) {
    controller = listener;
    controller?.addRuntimeEventListener(_handleRuntimeEvent);
    // Pass an event callback into the child nested artboard's
    // mounted artboard so we get an event bubbled up to us
    artboardInstance.activeNestedArtboards.forEach((artboard) {
      if (artboard.mountedArtboard is RuntimeMountedArtboard) {
        (artboard.mountedArtboard as RuntimeMountedArtboard).eventCallback =
            _handleNestedEvent;
      }
    });
  }

  void removeEventListener() {
    controller?.removeRuntimeEventListener(_handleRuntimeEvent);
  }

  void _handleRuntimeEvent(Event event) {
    if (eventCallback != null) {
      eventCallback!(event, nestedArtboard);
    }
  }

  void _handleNestedEvent(Event event, NestedArtboard target) {
    if (controller?.hasListenerWithTarget(target) ?? false) {
      controller?.reportNestedEvent(event, target);
      controller?.isActive = true;
    }
  }
}

/// Web stub for [BackgroundRiveWidgetController].
///
/// Background rendering requires native Metal/Vulkan GPU access and is not
/// supported on web. This stub provides the same public API surface so that
/// the types are importable on web, but [initialize] always returns `false`.

import 'package:rive_native/rive_native.dart';

class SnapshotEntry {
  final String name;
  final int type;
  final String rawValue;
  const SnapshotEntry({
    required this.name,
    required this.type,
    required this.rawValue,
  });
}

class RiveThreadedEvent {
  final String name;
  final double secondsDelay;
  const RiveThreadedEvent(this.name, this.secondsDelay);
}

class BackgroundRiveWidgetController {
  BackgroundRiveWidgetController({
    required Artboard artboard,
    required StateMachine stateMachine,
    ViewModelInstance? viewModelInstance,
  });

  bool get isInitialized => false;

  RenderTexture get renderTexture =>
      throw UnsupportedError('Background rendering is not supported on web');

  Future<bool> initialize({
    required int width,
    required int height,
    required double devicePixelRatio,
  }) async =>
      false;

  void dispose() {}
  void advance(double elapsedSeconds) {}
  void setEnumProperty(String name, String value) {}
  void setNumberProperty(String name, double value) {}
  void setBoolProperty(String name, bool value) {}
  void setStringProperty(String name, String value) {}
  void fireTriggerProperty(String name) {}
  void watchProperty(String name) {}
  void unwatchProperty(String name) {}
  List<SnapshotEntry> acquireSnapshot({int maxProperties = 32}) => const [];
  List<RiveThreadedEvent> pollEvents({int maxEvents = 32}) => const [];
  void pointerDown(double x, double y, {int pointerId = 0}) {}
  void pointerMove(double x, double y, {int pointerId = 0}) {}
  void pointerUp(double x, double y, {int pointerId = 0}) {}
  void pointerExit(double x, double y, {int pointerId = 0}) {}
}

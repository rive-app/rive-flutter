// ignore_for_file: avoid_classes_with_only_static_members
/// Objects to collect performance stats
import 'package:plato/plato.dart';
import 'package:rive/src/rive_core/rive_animation_controller.dart';

import '../../rive.dart';
import 'animation/state_instance.dart';
import 'component.dart';
import 'state_machine_controller.dart';

const _logr = Logr.always(prefix: 'stats');

class _AdvanceStats with Printable {

  _AdvanceStats._();
  static final _singleton = _AdvanceStats._();
  static _AdvanceStats get instance => _singleton;

  int syncStyle = 0;
  int layoutComponentSyncStyle = 0;
  int cascadeAnimationStyle = 0;
  int dependencyOrder = 0;
  int animationControllers = 0;
  int updateComponents = 0;
  int nested = 0;
  int sortHittableComponents = 0;
  int layerController = 0;
  int applyEvents = 0;

  int get total =>
      syncStyle + layoutComponentSyncStyle + cascadeAnimationStyle +
          dependencyOrder + animationControllers +
          updateComponents + nested + sortHittableComponents +
          layerController + applyEvents;

  String format(int value) =>
      '${((1000 * value) / _Stopwatcher._commits).toInt()}';

  @override
  String toString() => printr(
    'total=${format(total)}',
    '---',
    'syncStyle=${format(syncStyle)}',
    'layoutComponentSyncStyle=${format(layoutComponentSyncStyle)}',
    'cascadeAnimationStyle=${format(cascadeAnimationStyle)}',
    'dependencyOrder=${format(dependencyOrder)}',
    'animationControllers=${format(animationControllers)}',
    'updateComponents=${format(updateComponents)}',
    'nested=${format(nested)}',
    '---',
    'sortHittableComponents=${format(sortHittableComponents)}',
    'layerController=${format(layerController)}',
    'applyEvents=${format(applyEvents)}',
  );
}

class _Stopwatcher {
  final stopwatch = Stopwatch();

  void start() {
    stopwatch..reset()..start();
  }

  static int _commits = 0;

  void commit(Function(int) function) {
    function(stopwatch.elapsedMicroseconds);
    if (_commits++ % 50000 == 50000-1) {
      _logr.always.log(() => '${_AdvanceStats._singleton}');
    }
  }
}

abstract class _FrequencyPrinter {

  static var _count = 0;
  static void print(String Function() string, {int frequency = 10000, int divider = 1}) {
    if (_count++ % frequency == frequency-1 && _count % divider == 0) {
      _logr.info(string(), 1);
    }
  }
}

class StateStats with Printable {

  StateStats._(this.name);
  static StateStats? _singleton;

  static int _count = 0;

  static void renew(String name) {
    if (_count++ % 3000 == 3000-1) {
      _singleton = StateStats._(name);
    } else {
      _singleton = null;
    }
  }

  final String name;

  final _controllers = <RiveAnimationController>[];
  final _layers = <LayerController>[];
  final _states = <StateInstance>[];
  final _animationCallbacks = <LinearAnimation>[];

  final _updates = <Component>[];

  static void applyController(RiveAnimationController controller) {
    _singleton?._controllers.add(controller);
  }

  static void applyLayer(LayerController layer) {
    _singleton?._layers.add(layer);
  }

  static void advance(StateInstance? state) {
    if (state == null) return;
    _singleton?._states.add(state);
  }

  static void callbackAnimation(LinearAnimation? animation) {
    if (animation == null) return;
    _singleton?._animationCallbacks.add(animation);
  }

  static void update(Component component) {
    _singleton?._updates.add(component);
  }

  static void print() {
    if (_singleton != null) {
      _logr.info(_singleton);
    }
  }

  String? _print(String name, List<Tickerable> list) {
    if (list.isEmpty) {
      return null;
    } else {
      return '\n$name=${list.length} > ${list.map((a) => '${a.ticker}').join(',')}';
    }
  }

  @override
  String toString() => printr(
    name,
    _print('controllers', _controllers),
    _print('layers', _layers),
    _print('states', _states),
    _print('animations', _animationCallbacks),
    _print('updates', _updates),
  );
}

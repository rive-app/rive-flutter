// ignore_for_file: avoid_classes_with_only_static_members
/// Objects to collect performance stats
import 'package:plato/plato.dart';

const _logr = Logr.always(prefix: 'stats');

class AdvanceStats with Printable {

  AdvanceStats._();
  static final _singleton = AdvanceStats._();
  static AdvanceStats get instance => _singleton;

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
      '${((1000 * value) / Stopwatcher._commits).toInt()}';

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

class Stopwatcher {
  final stopwatch = Stopwatch();

  void start() {
    stopwatch..reset()..start();
  }

  static int _commits = 0;

  void commit(Function(int) function) {
    function(stopwatch.elapsedMicroseconds);
    if (_commits++ % 50000 == 50000-1) {
      _logr.always.log(() => '${AdvanceStats._singleton}');
    }
  }
}

abstract class FrequencyPrinter {

  static var _count = 0;
  static void print(String Function() string, {int frequency = 10000, int divider = 1}) {
    if (_count++ % frequency == frequency-1 && _count % divider == 0) {
      _logr.info(string(), 1);
    }
  }
}
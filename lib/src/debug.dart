import 'package:flutter/foundation.dart';

/// Print a message only when running in debug.
void printDebugMessage(String message) {
  assert(() {
    debugPrint(message);
    return true;
  }());
}

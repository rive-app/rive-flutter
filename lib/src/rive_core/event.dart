import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Just a way to get around the protected notifyListeners so we can use trigger
// multiple events from a single object.
class Event extends ChangeNotifier {
  void notify() => notifyListeners();
}

import 'package:flutter/foundation.dart';

// Just a way to get around the protected notifyListeners so we can use trigger
// multiple events from a single object.
class Notifier extends ChangeNotifier {
  void notify() => notifyListeners();
}

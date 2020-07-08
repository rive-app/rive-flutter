import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Event extends ChangeNotifier {
  void notify() => notifyListeners();
}

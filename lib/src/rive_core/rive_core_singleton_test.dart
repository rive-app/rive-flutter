import 'package:rive/src/rive_core/animation/linear_animation.dart';

class RiveCoreSingletonTest {
  static final RiveCoreSingletonTest _instance =
      RiveCoreSingletonTest._internal();

  final double num = 1.23;
  // bool isDebug = false;
  bool isAnimation = false;
  bool isArtboard = false;
  bool isLayer = false;
  bool isColorType = false;
  int currentTime = 0;
  LinearAnimation? la;

  // using a factory is important
  // because it promises to return _an_ object of this type
  // but it doesn't promise to make a new one.
  factory RiveCoreSingletonTest() {
    return _instance;
  }

  // This named constructor is the "real" constructor
  // It'll be called exactly once, by the static property assignment above
  // it's also private, so it can only be called in this class
  RiveCoreSingletonTest._internal() {
    // initialization logic
  }

  // This named constructor is the "real" constructor
  // It'll be called exactly once, by the static property assignment above
  // it's also private, so it can only be called in this class
  bool isDebug() {
    return isArtboard && isAnimation && isLayer;
  }
}

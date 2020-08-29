import 'dart:ui';

abstract class StrokeEffect {
  Path effectPath(Path source);
  void invalidateEffect();
}

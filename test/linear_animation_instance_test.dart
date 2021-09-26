import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';

import 'src/utils.dart';

void main() {
  late RiveFile riveFile;

  setUp(() {
    final riveBytes = loadFile('assets/rive-flutter-test-asset.riv');
    riveFile = RiveFile.import(riveBytes);
  });

  test('LinearAnimationInstance exposes direction is either +/-1', () {
    final artboard = riveFile.mainArtboard;

    expect(artboard.hasAnimations, isTrue);
    LinearAnimationInstance instance =
        LinearAnimationInstance(artboard.animations.first as LinearAnimation);

    expect(instance.direction, 1);
    instance.direction = -1;
    expect(instance.direction, -1);
    // If any other integer is given, it should default to 1
    instance.direction = -4;
    expect(instance.direction, 1);
  });

  test('LinearAnimationInstance has a valid start and end time', () {
    final artboard = riveFile.mainArtboard;

    expect(artboard.hasAnimations, isTrue);
    LinearAnimationInstance instance =
        LinearAnimationInstance(artboard.animations.first as LinearAnimation);

    final startTime = instance.animation.startTime;
    final endTime = instance.animation.endTime;
    expect(startTime <= endTime, isTrue);
    expect(instance.direction, 1);
    // Advance the animation to the mid point
    instance.advance((endTime - startTime) / 2);
    expect(instance.time > startTime, isTrue);
    expect(instance.time < endTime, isTrue);
    // Advance past the end of the4 animation
    instance.advance(endTime);
    expect(instance.time == endTime, isTrue);
  });

  test('LinearAnimationInstance can be reset', () {
    final artboard = riveFile.mainArtboard;

    expect(artboard.hasAnimations, isTrue);
    LinearAnimationInstance instance =
        LinearAnimationInstance(artboard.animations.first as LinearAnimation);

    // Check the starting position
    expect(instance.animation.startTime < instance.animation.endTime, isTrue);
    expect(instance.animation.startTime, instance.time);

    // Advance
    instance.advance(instance.animation.endTime);
    expect(instance.time, instance.animation.endTime);

    // Reset
    instance.reset();
    expect(instance.time, instance.animation.startTime);
  });
}

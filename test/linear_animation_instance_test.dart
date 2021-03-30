import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:rive/rive.dart';

void main() {
  late Artboard artboard;

  void loadTestAssets() {
    final riveData = ByteData.sublistView(
      File('assets/one_shot_0_6_5.riv').readAsBytesSync(),
    );
    final riveFile = RiveFile.import(riveData);
    artboard = riveFile.mainArtboard;
  }

  setUp(loadTestAssets);

  test('LinearAnimationInstance exposes direction is either +/-1', () {
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
    expect(artboard.hasAnimations, isTrue);
    LinearAnimationInstance instance =
        LinearAnimationInstance(artboard.animations.first as LinearAnimation);

    final startTime = instance.startTime;
    final endTime = instance.endTime;
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
    expect(artboard.hasAnimations, isTrue);
    LinearAnimationInstance instance =
        LinearAnimationInstance(artboard.animations.first as LinearAnimation);

    // Check the starting position
    expect(instance.startTime < instance.endTime, isTrue);
    expect(instance.startTime, instance.time);

    // Advance
    instance.advance(instance.endTime);
    expect(instance.time, instance.endTime);

    // Reset
    instance.reset();
    expect(instance.time, instance.startTime);
  });
}

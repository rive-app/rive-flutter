// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:rive/rive.dart' as rive;

class Arrow {
  static const double appleRadius = 50;
  static const appleRadiusSquared = appleRadius * appleRadius;

  final rive.Artboard artboard;
  final rive.Vec2D heading;
  rive.Vec2D translation;
  double time = 0;

  Arrow({
    required this.artboard,
    required this.translation,
    required this.heading,
  });

  void dispose() => artboard.dispose();

  bool get draws => time >= 0.1;
  bool get isDead => time > 2;

  void advance(double elapsedSeconds, Set<Apple> apples) {
    time += elapsedSeconds;
    if (!draws) {
      // Arrow is still leaving the bow (fire animation is playing on
      // centaur).
      return;
    } else if (isDead) {
      return;
    }
    // You'd likely use a scene tree to ray cast against here, but this is a
    // simple example.
    for (var apple in apples) {
      // const { explodeTrigger, x, y } = appleInstance;
      if ((apple.translation - translation).squaredLength() <
          appleRadiusSquared) {
        apple.damage();
      }
    }
    translation += heading * elapsedSeconds * 3000;
    heading.y += elapsedSeconds;
    // Normalize heading.
    heading.norm();
  }

  void draw(rive.Renderer renderer) {
    if (!draws) {
      return;
    }
    renderer.save();
    var arrowTransform = rive.Mat2D.fromTranslation(
      translation,
    ).mul(rive.Mat2D.fromRotation(rive.Mat2D(), atan2(heading.y, heading.x)));
    renderer.transform(arrowTransform);
    artboard.draw(renderer);
    renderer.restore();
  }
}

class Apple {
  final rive.Artboard artboard;
  final rive.StateMachine machine;
  final rive.TriggerInput explode;
  final rive.AABB bounds;
  rive.Vec2D translation;
  bool _isDead = false;

  bool get isDead => _deadTime > 1;
  double _deadTime = 0;

  Apple({
    required this.artboard,
    required this.machine,
    required this.explode,
    required this.translation,
  }) : bounds = artboard.bounds {
    var center = bounds.center();
    artboard.renderTransform = rive.Mat2D.fromTranslation(translation - center);
  }

  void damage() {
    if (_isDead) {
      return;
    }
    explode.fire();
    _isDead = true;
  }

  void advance(double elapsedSeconds) {
    // We don't advance the state machine here as we do all the apples in a
    // single batch call.
    if (_isDead) {
      _deadTime += elapsedSeconds;
    }
  }

  void draw(rive.Renderer renderer) {
    renderer.save();
    var center = bounds.center();
    renderer.translate(translation.x - center.x, translation.y - center.y);
    artboard.draw(renderer);
    renderer.restore();
  }

  void dispose() {
    artboard.dispose();
    machine.dispose();
  }
}

class GhostApple {
  final Apple apple;
  rive.Vec2D translation;

  GhostApple(this.apple, this.translation);

  void draw(rive.Renderer renderer) {
    renderer.save();
    var center = apple.bounds.center();
    renderer.translate(translation.x - center.x, translation.y - center.y);
    apple.artboard.draw(renderer);
    renderer.restore();
  }
}

base class CentaurGame extends rive.RenderTexturePainter {
  final rive.File riveFile;

  final rive.Artboard character;
  late rive.StateMachine characterMachine;
  final rive.Artboard backgroundTile;
  final Set<Arrow> _arrows = {};
  final Set<Apple> _apples = {};
  late rive.Component target;
  rive.Component? _characterRoot;
  rive.Component? _arrowLocation;
  rive.NumberInput? _moveInput;
  rive.TriggerInput? _fireInput;
  double _characterX = 0;
  double _characterDirection = 1;
  double move = 0;
  double _currentMoveSpeed = 0;
  CentaurGame(this.riveFile)
      : character = riveFile.artboard('Character')!,
        backgroundTile = riveFile.artboard('Background_tile')! {
    characterMachine = character.defaultStateMachine()!;
    character.frameOrigin = false;
    backgroundTile.frameOrigin = false;
    target = character.component('Look')!;
    _characterRoot = character.component('Character');
    _arrowLocation = character.component('ArrowLocation');
    _moveInput = characterMachine.number('Move');
    _fireInput = characterMachine.trigger('Fire');
  }

  @override
  void dispose() {
    character.dispose();
    backgroundTile.dispose();
    riveFile.dispose();
    super.dispose();
  }

  rive.Vec2D localCursor = rive.Vec2D();

  void aimAt(Offset localPosition) {
    localCursor = rive.Vec2D.fromOffset(localPosition);
  }

  void pointerDown(PointerDownEvent event) {
    _fireInput?.fire();
    var transform = _arrowLocation?.worldTransform ?? rive.Mat2D();
    var artboard = riveFile.artboard('Arrow');
    if (artboard == null) {
      return;
    }
    artboard.frameOrigin = false;
    var arrowInstance = Arrow(
      artboard: artboard,
      translation:
          transform.translation + rive.Vec2D.fromValues(_characterX, 0.0),
      heading: transform.xDirection,
    );

    _arrows.add(arrowInstance);
  }

  static const int minApples = 30;
  static const int maxApples = 100;
  final Stopwatch _appleCooloff = Stopwatch()..start();
  void spawnApples(int maxSpawnIterations) {
    if (_appleCooloff.elapsedMilliseconds < 10) {
      return;
    }
    _appleCooloff.reset();
    _appleCooloff.start();
    var rand = Random();
    var count = rand.nextInt(maxApples - minApples) + minApples;
    var bounds = spawnAppleBounds;
    var range = bounds.maximum - bounds.minimum;

    int spawnCount = 0;
    while (_apples.length < count) {
      var artboard = riveFile.artboard('Apple');
      if (artboard == null) {
        return;
      }

      var stateMachine = artboard.defaultStateMachine();
      if (stateMachine == null) {
        artboard.dispose();
        return;
      }

      var explode = stateMachine.trigger('Explode');
      if (explode == null) {
        artboard.dispose();
        stateMachine.dispose();
        return;
      }

      var apple = Apple(
        artboard: artboard,
        machine: stateMachine,
        explode: explode,
        translation: rive.Vec2D.fromValues(
          bounds.minimum.x + range.x * rand.nextDouble(),
          bounds.minimum.y + range.y * rand.nextDouble(),
        ),
        // translation: bounds.minimum,
      );
      _apples.add(apple);
      spawnCount++;
      if (spawnCount > maxSpawnIterations) {
        return;
      }
    }
  }

  rive.AABB get sceneBounds {
    final bounds = character.bounds;
    final characterWidth = bounds.width;
    return bounds.inset(-characterWidth * 5, 0);
  }

  rive.AABB get spawnAppleBounds {
    return rive.AABB.fromMinMax(
      sceneBounds.minimum - rive.Vec2D.fromValues(0, 3000),
      sceneBounds.maximum - rive.Vec2D.fromValues(0, 600),
    );
  }

  @override
  bool paint(
    rive.RenderTexture texture,
    double devicePixelRatio,
    Size size,
    double elapsedSeconds,
  ) {
    var renderer = texture.renderer;

    var viewTransform = rive.Renderer.computeAlignment(
      rive.Fit.contain,
      Alignment.bottomCenter,
      rive.AABB.fromValues(0, 0, size.width, size.height),
      sceneBounds,
      devicePixelRatio,
    );

    // Compute cursor in world space.
    final inverseViewTransform = rive.Mat2D();
    var worldCursor = rive.Vec2D();
    if (rive.Mat2D.invert(inverseViewTransform, viewTransform)) {
      worldCursor = inverseViewTransform * localCursor;
      // Check if we should invert the character's direction by comparing
      // the world location of the cursor to the world location of the
      // character (need to compensate by character movement, characterX).
      _characterDirection = _characterX < worldCursor.x ? 1 : -1;
      _characterRoot?.scaleX = _characterDirection;
    }

    target.worldTransform = rive.Mat2D.fromTranslation(
      worldCursor - rive.Vec2D.fromValues(_characterX, 0),
    );

    const moveSpeed = 100;
    var targetMoveSpeed = move * moveSpeed;
    _moveInput?.value = move * _characterDirection.sign;

    _currentMoveSpeed +=
        (targetMoveSpeed - _currentMoveSpeed) * min(1, elapsedSeconds * 10);
    _characterX += elapsedSeconds * _currentMoveSpeed;

    characterMachine.advanceAndApply(elapsedSeconds);
    renderer.save();
    renderer.transform(viewTransform);

    double backgroundScale = 3;
    for (int b = -2; b <= 2; b++) {
      renderer.save();
      var xform = rive.Mat2D.fromScale(backgroundScale, backgroundScale);
      xform[4] = backgroundScale * b * backgroundTile.bounds.width;
      renderer.transform(xform);
      backgroundTile.draw(renderer);
      renderer.restore();
    }

    renderer.save();
    renderer.translate(_characterX, 0);
    character.draw(renderer);
    renderer.restore();

    var deadArrows = <Arrow>{};
    for (final arrow in _arrows) {
      if (arrow.isDead) {
        deadArrows.add(arrow);
        arrow.dispose();
        continue;
      }
      arrow.draw(renderer);
      arrow.advance(elapsedSeconds, _apples);
    }
    _arrows.removeAll(deadArrows);

    bool batchRender = true;
    // Advance apple state machines in one multi-threaded batch.
    if (batchRender) {
      rive.Rive.batchAdvanceAndRender(
        _apples.map((apple) => apple.machine),
        elapsedSeconds,
        renderer,
      );
      // ignore: dead_code
    } else {
      rive.Rive.batchAdvance(
        _apples.map((apple) => apple.machine),
        elapsedSeconds,
      );
    }

    var deadApples = <Apple>{};
    for (final apple in _apples) {
      if (apple.isDead) {
        deadApples.add(apple);
        apple.dispose();
        continue;
      }
      apple.advance(elapsedSeconds);
      // ignore: dead_code
      if (!batchRender) {
        apple.draw(renderer);
      }
    }
    _apples.removeAll(deadApples);
    spawnApples(5);

    renderer.restore();

    return true;
  }

  @override
  Color get background => const Color(0xFF6F8C9B);
}

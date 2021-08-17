import 'package:flutter/rendering.dart';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/nested_artboard.dart';

class RuntimeNestedArtboard extends NestedArtboard {
  Artboard? sourceArtboard;
  @override
  K? clone<K extends Core<CoreContext>>() {
    var object = RuntimeNestedArtboard();
    object.copy(this);
    if (sourceArtboard != null) {
      object.sourceArtboard = sourceArtboard;
      object.mountedArtboard =
          RuntimeMountedArtboard(sourceArtboard!.instance());
    }

    return object as K;
  }
}

class RuntimeMountedArtboard extends MountedArtboard {
  final Artboard artboardInstance;
  RuntimeMountedArtboard(this.artboardInstance);

  @override
  Mat2D worldTransform = Mat2D();

  @override
  void draw(Canvas canvas) {
    canvas.save();
    canvas.transform(worldTransform.mat4);
    canvas.translate(-artboardInstance.originX * artboardInstance.width,
        -artboardInstance.originY * artboardInstance.height);
    artboardInstance.advance(0);
    artboardInstance.draw(canvas);
    canvas.restore();
  }
}

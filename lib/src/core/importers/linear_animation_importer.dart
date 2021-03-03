import 'package:rive/rive.dart';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/keyed_object.dart';

class LinearAnimationImporter extends ImportStackObject {
  final LinearAnimation linearAnimation;
  final keyedObjects = <KeyedObject>[];

  LinearAnimationImporter(this.linearAnimation);

  void addKeyedObject(KeyedObject object) {
    linearAnimation.context.addObject(object);
    
    keyedObjects.add(object);
    linearAnimation.internalAddKeyedObject(object);
  }

  @override
  void resolve() {
    for (final keyedObject in keyedObjects) {
      keyedObject?.objectId ??= linearAnimation.artboard.id;
    }
  }
}

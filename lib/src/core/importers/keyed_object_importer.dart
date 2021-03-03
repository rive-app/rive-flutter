import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/keyed_object.dart';
import 'package:rive/src/rive_core/animation/keyed_property.dart';

class KeyedObjectImporter extends ImportStackObject {
  final KeyedObject keyedObject;

  KeyedObjectImporter(this.keyedObject);

  void addKeyedProperty(KeyedProperty property) {
    keyedObject.context.addObject(property);
    keyedObject.internalAddKeyedProperty(property);
  }

  @override
  void resolve() {}
}

import 'dart:collection';
import 'dart:typed_data';

import 'package:rive/src/core/field_types/core_field_type.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/runtime/runtime_header.dart';
import 'package:rive/src/rive_core/backboard.dart';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/utilities/binary_buffer/binary_reader.dart';
import 'package:rive/src/rive_core/runtime/exceptions/rive_format_error_exception.dart';
import 'package:rive/src/rive_core/animation/animation.dart';
import 'package:rive/src/rive_core/animation/keyed_object.dart';
import 'package:rive/src/rive_core/animation/keyed_property.dart';
import 'package:rive/src/rive_core/animation/keyframe.dart';
import 'package:rive/src/rive_core/animation/linear_animation.dart';

class RiveFile {
  RuntimeHeader _header;
  RuntimeHeader get header => _header;
  Backboard _backboard;
  Backboard get backboard => _backboard;

  final _artboards = <RuntimeArtboard>[];

  /// Returns all artboards in the file
  List<RuntimeArtboard> get artboards => _artboards;

  /// Returns the first (main) artboard
  RuntimeArtboard get mainArtboard => _artboards.first;

  /// Returns an artboard from the specified name, or null if no artboard with
  /// that name exists in the file
  RuntimeArtboard artboardByName(String name) =>
      _artboards.firstWhere((a) => a.name == name, orElse: () => null);

  bool import(ByteData bytes) {
    assert(_header == null, 'can only import once');
    var reader = BinaryReader(bytes);
    _header = RuntimeHeader.read(reader);

    // Property fields toc.
    final propertyToField = HashMap<int, CoreFieldType>();

    final indexToField = <CoreFieldType>[
      RiveCoreContext.uintType,
      RiveCoreContext.stringType,
      RiveCoreContext.doubleType,
      RiveCoreContext.colorType
    ];

    _header.propertyToFieldIndex.forEach((key, fieldIndex) {
      if (fieldIndex < 0 || fieldIndex >= indexToField.length) {
        throw RiveFormatErrorException('unexpected field index $fieldIndex');
      }

      propertyToField[key] = indexToField[fieldIndex];
    });

    _backboard = _readRuntimeObject<Backboard>(reader, propertyToField);
    if (_backboard == null) {
      throw const RiveFormatErrorException(
          'expected first object to be a Backboard');
    }

    int numArtboards = reader.readVarUint();
    for (int i = 0; i < numArtboards; i++) {
      var numObjects = reader.readVarUint();
      if (numObjects == 0) {
        throw const RiveFormatErrorException(
            'artboards must contain at least one object (themselves)');
      }
      var artboard =
          _readRuntimeObject(reader, propertyToField, RuntimeArtboard());
      // Kind of weird, but the artboard is the core context at runtime, so we
      // want other objects to be able to resolve it. It's always at the 0
      // index.
      artboard?.addObject(artboard);
      _artboards.add(artboard);
      // var objects = List<Core<RiveCoreContext>>(numObjects);
      for (int i = 1; i < numObjects; i++) {
        Core<CoreContext> object = _readRuntimeObject(reader, propertyToField);
        // N.B. we add objects that don't load (null) too as we need to look
        // them up by index.
        artboard.addObject(object);
      }

      // Animations also need to reference objects, so make sure they get read
      // in before the hierarchy resolves (batch add completes).
      var numAnimations = reader.readVarUint();
      for (int i = 0; i < numAnimations; i++) {
        var animation = _readRuntimeObject<Animation>(reader, propertyToField);
        if (animation == null) {
          continue;
        }
        artboard.addObject(animation);
        animation.artboard = artboard;
        if (animation is LinearAnimation) {
          var numKeyedObjects = reader.readVarUint();
          var keyedObjects = List<KeyedObject>(numKeyedObjects);
          for (int j = 0; j < numKeyedObjects; j++) {
            var keyedObject =
                _readRuntimeObject<KeyedObject>(reader, propertyToField);
            if (keyedObject == null) {
              continue;
            }
            keyedObjects[j] = keyedObject;
            artboard.addObject(keyedObject);

            animation.internalAddKeyedObject(keyedObject);

            var numKeyedProperties = reader.readVarUint();
            for (int k = 0; k < numKeyedProperties; k++) {
              var keyedProperty =
                  _readRuntimeObject<KeyedProperty>(reader, propertyToField);
              if (keyedProperty == null) {
                continue;
              }
              artboard.addObject(keyedProperty);
              keyedObject.internalAddKeyedProperty(keyedProperty);

              var numKeyframes = reader.readVarUint();
              for (int l = 0; l < numKeyframes; l++) {
                var keyframe =
                    _readRuntimeObject<KeyFrame>(reader, propertyToField);
                if (keyframe == null) {
                  continue;
                }
                artboard.addObject(keyframe);
                keyedProperty.internalAddKeyFrame(keyframe);
                keyframe.computeSeconds(animation);
              }
            }
          }

          for (final keyedObject in keyedObjects) {
            keyedObject?.objectId ??= artboard.id;
          }
        }
      }

      // Any component objects with no id map to the artboard. Skip first item
      // as it's the artboard itself.
      for (final object in artboard.objects.skip(1)) {
        if (object is Component && object.parentId == null) {
          object.parent = artboard;
        }
        object?.onAddedDirty();
      }

      assert(!artboard.children.contains(artboard),
          'artboard should never contain itself as a child');
      for (final object in artboard.objects) {
        object?.onAdded();
      }
      artboard.clean();
    }

    return true;
  }
}

void _skipProperty(BinaryReader reader, int propertyKey,
    HashMap<int, CoreFieldType> propertyToField) {
  var field = propertyToField[propertyKey];
  if (field == null) {
    throw UnsupportedError('Unsupported property key $propertyKey. '
        'A new runtime is likely necessary to play this file.');
  }
  // Desrialize but don't do anything with the contents...
  field.deserialize(reader);
}

T _readRuntimeObject<T extends Core<CoreContext>>(
    BinaryReader reader, HashMap<int, CoreFieldType> propertyToField,
    [T instance]) {
  int coreObjectKey = reader.readVarUint();

  var object = instance ?? RiveCoreContext.makeCoreInstance(coreObjectKey);

  while (true) {
    int propertyKey = reader.readVarUint();
    if (propertyKey == 0) {
      // Terminator. https://media.giphy.com/media/7TtvTUMm9mp20/giphy.gif
      break;
    }

    var fieldType = RiveCoreContext.coreType(propertyKey);
    if (fieldType == null || object == null) {
      _skipProperty(reader, propertyKey, propertyToField);
    } else {
      RiveCoreContext.setObjectProperty(
          object, propertyKey, fieldType.deserialize(reader));
    }
  }
  return object as T;
}

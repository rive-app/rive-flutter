import 'dart:collection';
import 'dart:typed_data';

import 'package:meta/meta.dart';
import 'package:rive/src/core/field_types/core_field_type.dart';
import 'package:rive/src/generated/animation/keyed_property_base.dart';
import 'package:rive/src/generated/animation/state_machine_base.dart';
import 'package:rive/src/rive_core/animation/keyed_property.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/runtime/runtime_header.dart';
import 'package:rive/src/rive_core/backboard.dart';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/utilities/binary_buffer/binary_reader.dart';
import 'package:rive/src/rive_core/runtime/exceptions/rive_format_error_exception.dart';
import 'package:rive/src/rive_core/animation/animation.dart';
import 'package:rive/src/rive_core/animation/keyed_object.dart';
import 'package:rive/src/rive_core/animation/linear_animation.dart';
import 'package:rive/src/rive_core/artboard.dart';

class RiveFile {
  RuntimeHeader _header;
  RuntimeHeader get header => _header;
  Backboard _backboard;
  Backboard get backboard => _backboard;

  final _artboards = <Artboard>[];

  /// Returns all artboards in the file
  List<Artboard> get artboards => _artboards;

  /// Returns the first (main) artboard
  Artboard get mainArtboard => _artboards.first;

  /// Returns an artboard from the specified name, or null if no artboard with
  /// that name exists in the file
  Artboard artboardByName(String name) =>
      _artboards.firstWhere((a) => a.name == name, orElse: () => null);

  /// Imports a Rive file from an array of bytes. Returns true if successfully
  /// imported, false otherwise.
  bool import(ByteData bytes) {
    assert(_header == null, 'can only import once');
    var reader = BinaryReader(bytes);
    _header = RuntimeHeader.read(reader);

    /// Property fields table of contents
    final propertyToField = HashMap<int, CoreFieldType>();

    // List of core file types
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
    var importStack = ImportStack();
    while (!reader.isEOF) {
      var object = _readRuntimeObject(reader, propertyToField);
      if (object == null) {
        continue;
      }
      var previousOfType = importStack.latest(object.coreType);
      if (previousOfType != null) {
        previousOfType.resolve();
      }

      ImportStackObject stackObject;
      switch (object.coreType) {
        case ArtboardBase.typeKey:
          stackObject = ArtboardImporter(object as RuntimeArtboard);
          break;
        case LinearAnimationBase.typeKey:
          stackObject = LinearAnimationImporter(object as LinearAnimation);
          // helper = _AnimationImportHelper();
          break;
        case KeyedObjectBase.typeKey:
          stackObject = KeyedObjectImporter(object as KeyedObject);
          break;
        case KeyedPropertyBase.typeKey:
          {
            // KeyedProperty importer requires a linear animation importer, so
            // make sure there's one on the stack.
            var linearAnimationImporter = importStack
                .latest<LinearAnimationImporter>(LinearAnimationBase.typeKey);
            if (linearAnimationImporter != null) {
              stackObject = KeyedPropertyImporter(object as KeyedProperty,
                  linearAnimationImporter.linearAnimation);
            }
            break;
          }
        case StateMachineBase.typeKey:
          // stackObject = _LinearAnimationStackObject(object as LinearAnimation);
          // helper = _AnimationImportHelper();
          break;
        default:
          if (object is Component) {
            // helper = _ArtboardObjectImportHelper();
          }
          break;
      }

      importStack.makeLatest(object.coreType, stackObject);

      if (object?.import(importStack) ?? true) {
        switch (object.coreType) {
          case ArtboardBase.typeKey:
            _artboards.add(object as Artboard);
            break;
          case BackboardBase.typeKey:
            assert(_backboard == null, 'expect only one backboard in the file');
            _backboard = object as Backboard;
            break;
        }
      }
    }
    importStack.resolve();

    // _backboard = _readRuntimeObject<Backboard>(reader, propertyToField);
    // if (_backboard == null) {
    //   throw const RiveFormatErrorException(
    //       'expected first object to be a Backboard');
    // }

    // int numArtboards = reader.readVarUint();
    // for (int i = 0; i < numArtboards; i++) {
    //   var numObjects = reader.readVarUint();
    //   if (numObjects == 0) {
    //     throw const RiveFormatErrorException(
    //         'artboards must contain at least one object (themselves)');
    //   }
    //   var artboard =
    //       _readRuntimeObject(reader, propertyToField, RuntimeArtboard());
    //   // Kind of weird, but the artboard is the core context at runtime, so we
    //   // want other objects to be able to resolve it. It's always at the 0
    //   // index.
    //   artboard?.addObject(artboard);
    //   _artboards.add(artboard);
    //   // var objects = List<Core<RiveCoreContext>>(numObjects);
    //   for (int i = 1; i < numObjects; i++) {
    //     Core<CoreContext> object = _readRuntimeObject(reader, propertyToField);
    //     // N.B. we add objects that don't load (null) too as we need to look
    //     // them up by index.
    //     artboard.addObject(object);
    //   }

    //   // Animations also need to reference objects, so make sure they get read
    //   // in before the hierarchy resolves (batch add completes).
    //   var numAnimations = reader.readVarUint();
    //   for (int i = 0; i < numAnimations; i++) {
    //     var animation = _readRuntimeObject<Animation>(reader, propertyToField);
    //     if (animation == null) {
    //       continue;
    //     }
    //     artboard.addObject(animation);
    //     animation.artboard = artboard;
    //     if (animation is LinearAnimation) {
    //       var numKeyedObjects = reader.readVarUint();
    //       var keyedObjects = List<KeyedObject>.filled(numKeyedObjects, null);
    //       for (int j = 0; j < numKeyedObjects; j++) {
    //         var keyedObject =
    //             _readRuntimeObject<KeyedObject>(reader, propertyToField);
    //         if (keyedObject == null) {
    //           continue;
    //         }
    //         keyedObjects[j] = keyedObject;
    //         artboard.addObject(keyedObject);

    //         animation.internalAddKeyedObject(keyedObject);

    //         var numKeyedProperties = reader.readVarUint();
    //         for (int k = 0; k < numKeyedProperties; k++) {
    //           var keyedProperty =
    //               _readRuntimeObject<KeyedProperty>(reader, propertyToField);
    //           if (keyedProperty == null) {
    //             continue;
    //           }
    //           artboard.addObject(keyedProperty);
    //           keyedObject.internalAddKeyedProperty(keyedProperty);

    //           var numKeyframes = reader.readVarUint();
    //           for (int l = 0; l < numKeyframes; l++) {
    //             var keyframe =
    //                 _readRuntimeObject<KeyFrame>(reader, propertyToField);
    //             if (keyframe == null) {
    //               continue;
    //             }
    //             artboard.addObject(keyframe);
    //             keyedProperty.internalAddKeyFrame(keyframe);
    //             keyframe.computeSeconds(animation);
    //           }
    //         }
    //       }

    //       for (final keyedObject in keyedObjects) {
    //         keyedObject?.objectId ??= artboard.id;
    //       }
    //     }
    //   }

    //   // Any component objects with no id map to the artboard. Skip first item
    //   // as it's the artboard itself.
    //   for (final object in artboard.objects.skip(1)) {
    //     if (object is Component && object.parentId == null) {
    //       object.parent = artboard;
    //     }
    //     object?.onAddedDirty();
    //   }

    //   assert(!artboard.children.contains(artboard),
    //       'artboard should never contain itself as a child');
    //   for (final object in artboard.objects.toList(growable: false)) {
    //     if (object == null) {
    //       continue;
    //     }
    //     object.onAdded();
    //   }
    //   artboard.clean();

    return true;
  }
}

void _skipProperty(BinaryReader reader, int propertyKey,
    HashMap<int, CoreFieldType> propertyToField) {
  var field =
      RiveCoreContext.coreType(propertyKey) ?? propertyToField[propertyKey];
  if (field == null) {
    throw UnsupportedError('Unsupported property key $propertyKey. '
        'A new runtime is likely necessary to play this file.');
  }
  // Desrialize but don't do anything with the contents...
  field.deserialize(reader);
}

Core<CoreContext> _readRuntimeObject(
    BinaryReader reader, HashMap<int, CoreFieldType> propertyToField) {
  int coreObjectKey = reader.readVarUint();

  Core<CoreContext> instance;
  switch (coreObjectKey) {
    case ArtboardBase.typeKey:
      instance = RuntimeArtboard();
      break;
  }
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
  return object;
}

class _ArtboardImportStackObject extends ImportStackObject {
  final RuntimeArtboard artboard;
  _ArtboardImportStackObject(this.artboard);

  void addObject(Core<CoreContext> object) => artboard.addObject(object);

  @override
  void resolve() {
    for (final object in artboard.objects.skip(1)) {
      if (object is Component && object.parentId == null) {
        object.parent = artboard;
      }
      object?.onAddedDirty();
    }
    assert(!artboard.children.contains(artboard),
        'artboard should never contain itself as a child');
    for (final object in artboard.objects.toList(growable: false)) {
      if (object == null) {
        continue;
      }
      object.onAdded();
    }
    artboard.clean();
  }
}

class _ArtboardObjectImportHelper<T extends Core<CoreContext>>
    extends ImportHelper<T> {
  @override
  bool import(T object, ImportStack stack) {
    _ArtboardImportStackObject artboardStackObject =
        stack.latest(ArtboardBase.typeKey);
    if (artboardStackObject == null) {
      return false;
    }
    artboardStackObject.addObject(object);
    withArtboard(object, artboardStackObject);
    return true;
  }

  @protected
  void withArtboard(T object, _ArtboardImportStackObject artboardStackObject) {}
}

class _AnimationImportHelper extends _ArtboardObjectImportHelper<Animation> {
  @override
  void withArtboard(
      Animation object, _ArtboardImportStackObject artboardStackObject) {
    object.artboard = artboardStackObject.artboard;
  }
}

class _LinearAnimationStackObject extends ImportStackObject {
  final LinearAnimation linearAnimation;
  final keyedObjects = <KeyedObject>[];

  _LinearAnimationStackObject(this.linearAnimation);

  void addKeyedObject(KeyedObject object) {
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

class _KeyedObjectImportHelper
    extends _ArtboardObjectImportHelper<KeyedObject> {
  @override
  bool import(KeyedObject object, ImportStack stack) {
    if (!super.import(object, stack)) {
      return false;
    }
    _LinearAnimationStackObject animationStackObject =
        stack.latest(LinearAnimationBase.typeKey);
    if (animationStackObject == null) {
      return false;
    }
    animationStackObject.addKeyedObject(object);

    return true;
  }
}

import 'dart:collection';
import 'dart:typed_data';

import 'package:rive/src/core/field_types/core_field_type.dart';
import 'package:rive/src/generated/animation/animation_state_base.dart';
import 'package:rive/src/generated/animation/any_state_base.dart';
import 'package:rive/src/generated/animation/entry_state_base.dart';
import 'package:rive/src/generated/animation/exit_state_base.dart';
import 'package:rive/src/generated/animation/keyed_property_base.dart';
import 'package:rive/src/generated/animation/state_machine_base.dart';
import 'package:rive/src/rive_core/animation/keyed_property.dart';
import 'package:rive/src/rive_core/animation/layer_state.dart';
import 'package:rive/src/rive_core/animation/state_machine.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/runtime/runtime_header.dart';
import 'package:rive/src/rive_core/backboard.dart';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/utilities/binary_buffer/binary_reader.dart';
import 'package:rive/src/rive_core/runtime/exceptions/rive_format_error_exception.dart';
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
      var stackType = object.coreType;
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
          stackObject = StateMachineImporter(object as StateMachine);
          break;
        case EntryStateBase.typeKey:
        case AnyStateBase.typeKey:
        case ExitStateBase.typeKey:
        case AnimationStateBase.typeKey:
          stackObject = LayerStateImporter(object as LayerState);
          stackType = LayerStateBase.typeKey;
          break;
        default:
          if (object is Component) {
            // helper = _ArtboardObjectImportHelper();
          }
          break;
      }

      importStack.makeLatest(stackType, stackObject);

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

import 'dart:collection';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/core/field_types/core_field_type.dart';
import 'package:rive/src/generated/animation/animation_state_base.dart';
import 'package:rive/src/generated/animation/any_state_base.dart';
import 'package:rive/src/generated/animation/entry_state_base.dart';
import 'package:rive/src/generated/animation/exit_state_base.dart';
import 'package:rive/src/generated/animation/keyed_property_base.dart';
import 'package:rive/src/generated/animation/state_machine_base.dart';
import 'package:rive/src/rive_core/animation/keyed_object.dart';
import 'package:rive/src/rive_core/animation/keyed_property.dart';
import 'package:rive/src/rive_core/animation/layer_state.dart';
import 'package:rive/src/rive_core/animation/linear_animation.dart';
import 'package:rive/src/rive_core/animation/state_machine.dart';
import 'package:rive/src/rive_core/animation/state_machine_layer.dart';
import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/rive_core/backboard.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/runtime/exceptions/rive_format_error_exception.dart';
import 'package:rive/src/rive_core/runtime/runtime_header.dart';
import 'package:rive/src/utilities/binary_buffer/binary_reader.dart';

import 'rive_core/animation/state_transition.dart';

Core<CoreContext>? _readRuntimeObject(
    BinaryReader reader, HashMap<int, CoreFieldType> propertyToField) {
  int coreObjectKey = reader.readVarUint();

  Core<CoreContext>? instance;
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

/// Encapsulates a [RiveFile] and provides access to the list of [Artboard]
/// objects it contains.
class RiveFile {
  /// Contains the [RiveFile]'s version information.
  final RuntimeHeader header;

  Backboard _backboard = Backboard.unknown;
  final _artboards = <Artboard>[];

  RiveFile._(
    BinaryReader reader,
    this.header,
  ) {
    /// Property fields table of contents
    final propertyToField = HashMap<int, CoreFieldType>();

    // List of core file types
    final indexToField = <CoreFieldType>[
      RiveCoreContext.uintType,
      RiveCoreContext.stringType,
      RiveCoreContext.doubleType,
      RiveCoreContext.colorType
    ];

    header.propertyToFieldIndex.forEach((key, fieldIndex) {
      if (fieldIndex < 0 || fieldIndex >= indexToField.length) {
        throw RiveFormatErrorException('unexpected field index $fieldIndex');
      }

      propertyToField[key] = indexToField[fieldIndex];
    });
    var importStack = ImportStack();
    while (!reader.isEOF) {
      final object = _readRuntimeObject(reader, propertyToField);
      if (object == null) {
        continue;
      }

      ImportStackObject? stackObject;
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
            var linearAnimationImporter =
                importStack.requireLatest<LinearAnimationImporter>(
                    LinearAnimationBase.typeKey);
            stackObject = KeyedPropertyImporter(object as KeyedProperty,
                linearAnimationImporter.linearAnimation);
            break;
          }
        case StateMachineBase.typeKey:
          stackObject = StateMachineImporter(object as StateMachine);
          break;
        case StateMachineLayerBase.typeKey:
          {
            // Needs artboard importer to resolve linear animations.
            var artboardImporter = importStack
                .requireLatest<ArtboardImporter>(ArtboardBase.typeKey);
            stackObject = StateMachineLayerImporter(
                object as StateMachineLayer, artboardImporter);
            break;
          }
        case EntryStateBase.typeKey:
        case AnyStateBase.typeKey:
        case ExitStateBase.typeKey:
        case AnimationStateBase.typeKey:
          stackObject = LayerStateImporter(object as LayerState);
          stackType = LayerStateBase.typeKey;
          break;
        case StateTransitionBase.typeKey:
          {
            var stateMachineImporter = importStack
                .requireLatest<StateMachineImporter>(StateMachineBase.typeKey);
            stackObject = StateTransitionImporter(
                object as StateTransition, stateMachineImporter);
            break;
          }
        default:
          if (object is Component) {
            // helper = _ArtboardObjectImportHelper();
          }
          break;
      }

      if (!importStack.makeLatest(stackType, stackObject)) {
        throw const RiveFormatErrorException('Rive file is corrupt.');
      }

      if (object.import(importStack)) {
        switch (object.coreType) {
          case ArtboardBase.typeKey:
            _artboards.add(object as Artboard);
            break;
          case BackboardBase.typeKey:
            if (_backboard != Backboard.unknown) {
              throw const RiveFormatErrorException(
                  'Rive file expects only one backboard.');
            }
            _backboard = object as Backboard;
            break;
        }
      }
    }
    if (!importStack.resolve()) {
      throw const RiveFormatErrorException('Rive file is corrupt.');
    }
    if (_backboard == Backboard.unknown) {
      throw const RiveFormatErrorException('Rive file is missing a backboard.');
    }

    for (final artboard in _artboards) {
      var runtimeArtboard = artboard as RuntimeArtboard;
      for (final object in runtimeArtboard.objects) {
        if (object != null && object.validate()) {
          InternalCoreHelper.markValid(object);
        } else {
          throw RiveFormatErrorException(
              'Rive file is corrupt. Invalid $object.');
        }
      }
    }
  }

  /// Imports a Rive file from an array of bytes. Will throw
  /// [RiveFormatErrorException] if data is malformed. Will throw
  /// [RiveUnsupportedVersionException] if the version is not supported.
  factory RiveFile.import(ByteData bytes) {
    var reader = BinaryReader(bytes);
    return RiveFile._(reader, RuntimeHeader.read(reader));
  }

  /// Returns all artboards in the file
  List<Artboard> get artboards => _artboards;

  /// Returns the first (main) artboard
  Artboard get mainArtboard => _artboards.first;

  /// Returns an artboard from the specified name, or null if no artboard with
  /// that name exists in the file
  Artboard? artboardByName(String name) =>
      _artboards.firstWhereOrNull((a) => a.name == name);
}

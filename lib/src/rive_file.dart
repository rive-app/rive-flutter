import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:rive/src/asset_loader.dart';
import 'package:rive/src/core/core.dart';
import 'package:rive/src/core/field_types/core_field_type.dart';
import 'package:rive/src/generated/animation/animation_state_base.dart';
import 'package:rive/src/generated/animation/any_state_base.dart';
import 'package:rive/src/generated/animation/blend_state_transition_base.dart';
import 'package:rive/src/generated/animation/entry_state_base.dart';
import 'package:rive/src/generated/animation/exit_state_base.dart';
import 'package:rive/src/generated/assets/font_asset_base.dart';
import 'package:rive/src/generated/nested_artboard_base.dart';
import 'package:rive/src/local_file_io.dart'
    if (dart.library.html) 'package:rive/src/local_file_web.dart';
import 'package:rive/src/rive_core/animation/blend_state_1d.dart';
import 'package:rive/src/rive_core/animation/blend_state_direct.dart';
import 'package:rive/src/rive_core/animation/keyed_object.dart';
import 'package:rive/src/rive_core/animation/keyed_property.dart';
import 'package:rive/src/rive_core/animation/layer_state.dart';
import 'package:rive/src/rive_core/animation/linear_animation.dart';
import 'package:rive/src/rive_core/animation/nested_state_machine.dart';
import 'package:rive/src/rive_core/animation/state_machine.dart';
import 'package:rive/src/rive_core/animation/state_machine_layer.dart';
import 'package:rive/src/rive_core/animation/state_machine_listener.dart';
import 'package:rive/src/rive_core/animation/state_transition.dart';
import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/rive_core/assets/file_asset.dart';
import 'package:rive/src/rive_core/assets/file_asset_contents.dart';
import 'package:rive/src/rive_core/assets/image_asset.dart';
import 'package:rive/src/rive_core/backboard.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/runtime/exceptions/rive_format_error_exception.dart';
import 'package:rive/src/rive_core/runtime/runtime_header.dart';
import 'package:rive/src/runtime_nested_artboard.dart';

import 'package:rive_common/utilities.dart';

Core<CoreContext>? _readRuntimeObject(
    BinaryReader reader, HashMap<int, CoreFieldType> propertyToField) {
  int coreObjectKey = reader.readVarUint();
  Core<CoreContext>? instance;
  switch (coreObjectKey) {
    case ArtboardBase.typeKey:
      instance = RuntimeArtboard();
      break;
    case NestedArtboardBase.typeKey:
      instance = RuntimeNestedArtboard();
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
  field.skip(reader);
}

/// Encapsulates a [RiveFile] and provides access to the list of [Artboard]
/// objects it contains.
class RiveFile {
  /// Contains the [RiveFile]'s version information.
  final RuntimeHeader header;

  Backboard _backboard = Backboard.unknown;
  final _artboards = <Artboard>[];
  final FileAssetLoader? _assetLoader;

  RiveFile._(
    BinaryReader reader,
    this.header,
    this._assetLoader, {
    bool importEmbeddedAssets = true,
  }) {
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
    int artboardId = 0;
    var artboardLookup = HashMap<int, Artboard>();
    var importStack = ImportStack();
    while (!reader.isEOF) {
      final object = _readRuntimeObject(reader, propertyToField);
      if (object == null) {
        // See if there's an artboard on the stack, need to track the null
        // object as it'll still hold an id.
        var artboardImporter =
            importStack.latest<ArtboardImporter>(ArtboardBase.typeKey);
        if (artboardImporter != null) {
          artboardImporter.addComponent(null);
        }
        continue;
      }
      // two options, either tell the fileAssetImporter,
      // or simply skip the object. i think we should skip the object.
      if (!importEmbeddedAssets && object is FileAssetContentsBase) {
        // suppress importing embedded assets
        continue;
      }

      ImportStackObject? stackObject;
      var stackType = object.coreType;
      switch (object.coreType) {
        case BackboardBase.typeKey:
          stackObject = BackboardImporter(artboardLookup, object as Backboard);
          break;
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
          stackObject = StateMachineLayerImporter(object as StateMachineLayer);
          break;
        case StateMachineListenerBase.typeKey:
          stackObject =
              StateMachineListenerImporter(object as StateMachineListener);
          break;
        case NestedStateMachineBase.typeKey:
          stackObject =
              NestedStateMachineImporter(object as NestedStateMachine);
          break;
        case EntryStateBase.typeKey:
        case AnyStateBase.typeKey:
        case ExitStateBase.typeKey:
        case AnimationStateBase.typeKey:
        case BlendStateDirectBase.typeKey:
        case BlendState1DBase.typeKey:
          stackObject = LayerStateImporter(object as LayerState);
          stackType = LayerStateBase.typeKey;
          break;
        case StateTransitionBase.typeKey:
        case BlendStateTransitionBase.typeKey:
          {
            var stateMachineImporter = importStack
                .requireLatest<StateMachineImporter>(StateMachineBase.typeKey);
            stackObject = StateTransitionImporter(
                object as StateTransition, stateMachineImporter);
            stackType = StateTransitionBase.typeKey;
            break;
          }
        case ImageAssetBase.typeKey:
        case FontAssetBase.typeKey:
          // all these stack objects are resolvers. they get resolved.
          stackObject = FileAssetImporter(
            object as FileAsset,
            _assetLoader,
            importEmbeddedAssets: importEmbeddedAssets,
          );
          stackType = FileAssetBase.typeKey;
          break;
        default:
          if (object is Component) {
            // helper = _ArtboardObjectImportHelper();
          }
          break;
      }

      if (!importStack.makeLatest(stackType, stackObject)) {
        throw const RiveFormatErrorException('Rive file is corrupt.');
      }

      // Store all as some may fail to import (will be set to null, but we still
      // want them to occupy an id).
      if (object.import(importStack)) {
        switch (object.coreType) {
          case ArtboardBase.typeKey:
            artboardLookup[artboardId++] = object as Artboard;
            _artboards.add(object);
            break;
          case BackboardBase.typeKey:
            if (_backboard != Backboard.unknown) {
              throw const RiveFormatErrorException(
                  'Rive file expects only one backboard.');
            }
            _backboard = object as Backboard;
            break;
        }
      } else {
        switch (object.coreType) {
          case ArtboardBase.typeKey:
            artboardId++;
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
      for (final object in runtimeArtboard.objects.whereNotNull()) {
        if (object.validate()) {
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
  factory RiveFile.import(
    ByteData bytes, {
    FileAssetLoader? assetLoader,
    bool cdn = true,
    bool importEmbeddedAssets = true,
  }) {
    var reader = BinaryReader(bytes);
    return RiveFile._(
      reader,
      RuntimeHeader.read(reader),
      FallbackAssetLoader(
        [
          if (assetLoader != null) assetLoader,
          if (cdn) CDNAssetLoader(),
        ],
      ),
      importEmbeddedAssets: importEmbeddedAssets,
    );
  }

  /// Imports a Rive file from an asset bundle.
  /// By default we will look for out of bound assets next to the [bundleKey] & check
  /// Rive's CDN for content.
  static Future<RiveFile> asset(
    String bundleKey, {
    FileAssetLoader? assetLoader,
    bool cdn = true,
    bool importEmbeddedAssets = true,
    AssetBundle? bundle,
  }) async {
    final bytes = await (bundle ?? rootBundle).load(
      bundleKey,
    );

    return RiveFile.import(
      bytes,
      assetLoader: assetLoader,
      cdn: cdn,
      importEmbeddedAssets: importEmbeddedAssets,
    );
  }

  /// Imports a Rive file from a URL over HTTP. Provide an [assetResolver] if
  /// your file contains images that needed to be loaded with separate network
  /// requests.
  static Future<RiveFile> network(
    String url, {
    FileAssetLoader? assetLoader,
    Map<String, String>? headers,
    bool cdn = true,
    bool importEmbeddedAssets = true,
  }) async {
    final res = await http.get(Uri.parse(url), headers: headers);
    final bytes = ByteData.view(res.bodyBytes.buffer);
    return RiveFile.import(
      bytes,
      assetLoader: assetLoader,
      cdn: cdn,
      importEmbeddedAssets: importEmbeddedAssets,
    );
  }

  /// Imports a Rive file from local folder
  static Future<RiveFile> file(
    String path, {
    FileAssetLoader? assetLoader,
    bool cdn = true,
    bool importEmbeddedAssets = true,
  }) async {
    final bytes = await localFileBytes(path);
    return RiveFile.import(
      ByteData.view(bytes!.buffer),
      assetLoader: assetLoader,
      importEmbeddedAssets: importEmbeddedAssets,
      cdn: cdn,
    );
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

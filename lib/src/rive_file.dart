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
import 'package:rive/src/generated/text/text_base.dart';
import 'package:rive/src/local_file_io.dart'
    if (dart.library.js_interop) 'package:rive/src/local_file_web.dart';
import 'package:rive/src/rive_core/animation/blend_state_1d.dart';
import 'package:rive/src/rive_core/animation/blend_state_direct.dart';
import 'package:rive/src/rive_core/animation/keyed_object.dart';
import 'package:rive/src/rive_core/animation/keyed_property.dart';
import 'package:rive/src/rive_core/animation/layer_state.dart';
import 'package:rive/src/rive_core/animation/linear_animation.dart';
import 'package:rive/src/rive_core/animation/nested_state_machine.dart';
import 'package:rive/src/rive_core/animation/state_machine.dart';
import 'package:rive/src/rive_core/animation/state_machine_layer.dart';
import 'package:rive/src/rive_core/animation/state_machine_layer_component.dart';
import 'package:rive/src/rive_core/animation/state_machine_listener.dart';
import 'package:rive/src/rive_core/animation/state_transition.dart';
import 'package:rive/src/rive_core/artboard.dart';
import 'package:rive/src/rive_core/assets/audio_asset.dart';
import 'package:rive/src/rive_core/assets/file_asset.dart';
import 'package:rive/src/rive_core/assets/image_asset.dart';
import 'package:rive/src/rive_core/backboard.dart';
import 'package:rive/src/rive_core/component.dart';
import 'package:rive/src/rive_core/runtime/exceptions/rive_format_error_exception.dart';
import 'package:rive/src/rive_core/runtime/runtime_header.dart';
import 'package:rive/src/runtime_nested_artboard.dart';
import 'package:rive_common/rive_text.dart';
import 'package:rive_common/utilities.dart';

typedef Core<CoreContext>? ObjectGenerator(int coreTypeKey);

Core<CoreContext>? _readRuntimeObject(BinaryReader reader,
    HashMap<int, CoreFieldType> propertyToField, ObjectGenerator? generator) {
  int coreObjectKey = reader.readVarUint();
  Core<CoreContext>? instance = generator?.call(coreObjectKey);
  if (instance == null) {
    switch (coreObjectKey) {
      case ArtboardBase.typeKey:
        instance = RuntimeArtboard();
        break;
      case NestedArtboardBase.typeKey:
        instance = RuntimeNestedArtboard();
        break;
    }
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

int _peekRuntimeObjectType(
    BinaryReader reader, HashMap<int, CoreFieldType> propertyToField) {
  int coreObjectKey = reader.readVarUint();

  while (true) {
    int propertyKey = reader.readVarUint();
    if (propertyKey == 0) {
      // Terminator. https://media.giphy.com/media/7TtvTUMm9mp20/giphy.gif
      break;
    }

    _skipProperty(reader, propertyKey, propertyToField);
  }
  return coreObjectKey;
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

  // List of core file types
  static final indexToField = <CoreFieldType>[
    RiveCoreContext.uintType,
    RiveCoreContext.stringType,
    RiveCoreContext.doubleType,
    RiveCoreContext.colorType
  ];

  static HashMap<int, CoreFieldType> _propertyToFieldLookup(
      RuntimeHeader header) {
    /// Property fields table of contents
    final propertyToField = HashMap<int, CoreFieldType>();

    header.propertyToFieldIndex.forEach((key, fieldIndex) {
      if (fieldIndex < 0 || fieldIndex >= indexToField.length) {
        throw RiveFormatErrorException('unexpected field index $fieldIndex');
      }

      propertyToField[key] = indexToField[fieldIndex];
    });
    return propertyToField;
  }

  @Deprecated('This method will always return true and is no longer accurate')
  // Peek into the bytes to see if we're going to need to use the text runtime.
  static bool needsTextRuntime(ByteData bytes) {
    var reader = BinaryReader(bytes);
    var header = RuntimeHeader.read(reader);

    /// Property fields table of contents
    final propertyToField = _propertyToFieldLookup(header);

    while (!reader.isEOF) {
      final coreType = _peekRuntimeObjectType(reader, propertyToField);
      switch (coreType) {
        case TextBase.typeKey:
        // Since all rive_common wasm modules are currently bundled together
        // we need to check for existance of any of these. And since Artboard
        // extends LayoutComponent, we will always need to load it
        case ArtboardBase.typeKey:
        case AudioAssetBase.typeKey:
          return true;
      }
    }
    return false;
  }

  RiveFile._(
    BinaryReader reader,
    this.header,
    ObjectGenerator? generator,
    this._assetLoader,
  ) {
    /// Property fields table of contents
    final propertyToField = _propertyToFieldLookup(header);

    int artboardId = 0;
    var artboardLookup = HashMap<int, Artboard>();
    var importStack = ImportStack();
    while (!reader.isEOF) {
      final object = _readRuntimeObject(reader, propertyToField, generator);
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
        case AudioAssetBase.typeKey:
        case ImageAssetBase.typeKey:
        case FontAssetBase.typeKey:
          // all these stack objects are resolvers. they get resolved.
          stackObject = FileAssetImporter(
            object as FileAsset,
            _assetLoader,
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
      // Special case for StateMachineLayerComponents as the concrete types also
      // add importers.
      if (object is StateMachineLayerComponent) {
        if (!importStack.makeLatest(StateMachineLayerComponentBase.typeKey,
            StateMachineLayerComponentImporter(object))) {
          throw const RiveFormatErrorException('Rive file is corrupt.');
        }
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

  /// Imports a Rive file from an array of bytes.
  ///
  /// {@template rive_file_asset_loader_params}
  /// Provide an [assetLoader] to load assets from a custom location (out of
  /// band assets). See [CallbackAssetLoader] for an example.
  ///
  /// Set [loadCdnAssets] to `false` to disable loading assets from the CDN.
  ///
  /// Whether an assets is embedded/cdn/referenced is determined by the Rive
  /// file - as set in the editor.
  ///
  /// Loading assets documentation: https://help.rive.app/runtimes/loading-assets
  /// {@endtemplate}
  ///
  /// Provide an [objectGenerator] if you want to override any built-in Rive
  /// types.
  ///
  /// Will throw [RiveFormatErrorException] if data is malformed. Will throw
  /// [RiveUnsupportedVersionException] if the version is not supported.
  factory RiveFile.import(
    ByteData bytes, {
    FileAssetLoader? assetLoader,
    ObjectGenerator? objectGenerator,
    bool loadCdnAssets = true,
  }) {
    // TODO: in the next major version add an assert here to make this a
    // requirement
    if (!_initializedText) {
      debugPrint('''Rive: RiveFile.import called before RiveFile.initialize()

Consider calling `await RiveFile.initialize()` before using `RiveFile.import`''');
    }

    var reader = BinaryReader(bytes);
    return RiveFile._(
      reader,
      RuntimeHeader.read(reader),
      objectGenerator,
      FallbackAssetLoader(
        [
          if (assetLoader != null) assetLoader,
          if (loadCdnAssets) CDNAssetLoader(),
        ],
      ),
    );
  }

  static bool _initializedText = false;

  /// Initialize Rive's text, audio, and layout engines.
  ///
  /// This method is automatically called when using `RiveFile.asset`,
  /// `RiveFile.network`, and `RiveFile.file`.
  ///
  /// When using `RiveFile.import` then `RiveFile.initialize()` should be
  /// called manually.
  ///
  /// Consider calling `unawaited(RiveFile.initialize());` in the `main` method
  /// to ensure the engine has initialized before displaying the first Rive
  /// graphic.
  static Future<void> initialize() async {
    if (!_initializedText) {
      final status = await Font.initialize();
      if (status == FontInitStatus.success ||
          status == FontInitStatus.alreadyInitialized) {
        _initializedText = true;
      }
    }
  }

  /// Initialize Rive's text engine if it hasn't been yet.
  @Deprecated('Use `initialize()` instead')
  static Future<void> initializeText() async {
    await initialize();
  }

  static Future<RiveFile> _initTextAndImport(
    ByteData bytes, {
    FileAssetLoader? assetLoader,
    bool loadCdnAssets = true,
    ObjectGenerator? objectGenerator,
  }) async {
    /// If the file looks like it needs the text runtime, let's load it.
    if (!_initializedText) {
      await initialize();
    }
    return RiveFile.import(
      bytes,
      assetLoader: assetLoader,
      loadCdnAssets: loadCdnAssets,
      objectGenerator: objectGenerator,
    );
  }

  /// Imports a Rive file from an asset bundle.
  ///
  /// Default uses [rootBundle] from Flutter. Provide a custom [bundle] to load
  /// from a different bundle.
  ///
  /// {@macro rive_file_asset_loader_params}
  ///
  /// Whether an assets is embedded/cdn/referenced is determined by the Rive
  /// file - as set in the editor.
  static Future<RiveFile> asset(
    String bundleKey, {
    AssetBundle? bundle,
    FileAssetLoader? assetLoader,
    bool loadCdnAssets = true,
    ObjectGenerator? objectGenerator,
  }) async {
    final bytes = await (bundle ?? rootBundle).load(
      bundleKey,
    );

    return _initTextAndImport(
      bytes,
      assetLoader: assetLoader,
      loadCdnAssets: loadCdnAssets,
      objectGenerator: objectGenerator,
    );
  }

  /// Imports a Rive file from a [url] over HTTP.
  ///
  /// Provide [headers] to add custom HTTP headers to the request.
  ///
  /// {@macro rive_file_asset_loader_params}
  ///
  /// Whether an assets is embedded/cdn/referenced is determined by the Rive
  /// file - as set in the editor.
  static Future<RiveFile> network(
    String url, {
    Map<String, String>? headers,
    FileAssetLoader? assetLoader,
    bool loadCdnAssets = true,
    ObjectGenerator? objectGenerator,
  }) async {
    final res = await http.get(Uri.parse(url), headers: headers);
    final bytes = ByteData.view(res.bodyBytes.buffer);
    return _initTextAndImport(
      bytes,
      assetLoader: assetLoader,
      loadCdnAssets: loadCdnAssets,
      objectGenerator: objectGenerator,
    );
  }

  /// Imports a Rive file from local path
  ///
  /// {@macro rive_file_asset_loader_params}
  ///
  /// Whether an assets is embedded/cdn/referenced is determined by the Rive
  /// file - as set in the editor.
  static Future<RiveFile> file(
    String path, {
    FileAssetLoader? assetLoader,
    bool loadCdnAssets = true,
    ObjectGenerator? objectGenerator,
  }) async {
    final bytes = await localFileBytes(path);
    return _initTextAndImport(
      ByteData.view(bytes!.buffer),
      assetLoader: assetLoader,
      loadCdnAssets: loadCdnAssets,
      objectGenerator: objectGenerator,
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

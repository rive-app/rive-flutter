import 'dart:collection';

import 'package:rive/src/core/core.dart';
import 'package:rive/src/rive_core/animation/animation_state.dart';
import 'package:rive/src/rive_core/animation/blend_state.dart';
import 'package:rive/src/rive_core/animation/keyed_object.dart';
import 'package:rive/src/rive_core/animation/keyed_property.dart';
import 'package:rive/src/rive_core/animation/keyframe_color.dart';
import 'package:rive/src/rive_core/animation/keyframe_double.dart';
import 'package:rive/src/rive_core/animation/linear_animation.dart';
import 'package:rive/src/rive_core/animation/state_instance.dart';
import 'package:rive_common/utilities.dart';

bool _isDouble(int propertyKey, Core object) {
  final coreType = RiveCoreContext.coreType(propertyKey);
  return coreType == RiveCoreContext.doubleType;
}

bool _isColor(int propertyKey, Core object) {
  final coreType = RiveCoreContext.coreType(propertyKey);
  return coreType == RiveCoreContext.colorType;
}

class AnimationReset {
  BinaryReader? _reader;
  late final BinaryWriter _writer;
  int _dataSize = 0;

  AnimationReset() {
    _writer = BinaryWriter(endian: Endian.big);
  }

  int get size {
    return _writer.maxSize;
  }

  void writeObjectId(int id) {
    _writer.writeVarUint(id);
  }

  void writeTotalProperties(int totalProperties) {
    _writer.writeVarUint(totalProperties);
  }

  void writePropertyKey(int propertyKey) {
    _writer.writeVarUint(propertyKey);
  }

  void writeColor(int value) {
    _writer.writeInt32(value);
  }

  void writeDouble(double value) {
    _writer.writeFloat32(value);
  }

  void clear() {
    _writer.writeIndex = 0;
  }

  void createReader() {
    // We only need to regenerate the reader if its size is smaller than the
    // writer size
    _dataSize = _writer.size;
    if (_reader == null || _reader!.size < _writer.size) {
      _reader = BinaryReader(_writer.buffer, endian: Endian.big);
    }
  }

  int resolveId(int intId) {
    return intId;
  }

  void apply(CoreContext core) {
    BinaryReader reader = _reader!;
    reader.readIndex = 0;
    while (reader.readIndex < _dataSize) {
      // First we read the object's id
      final objectIntId = reader.readVarUint();
      final objectId = resolveId(objectIntId);
      final object = core.resolve<Core>(objectId);
      // Second we read how many keyframed properties it has
      final totalProperties = reader.readVarUint();
      int currentPropertyIndex = 0;
      while (currentPropertyIndex < totalProperties) {
        // Third we read the property key for each property
        final propertyKey = reader.readVarUint();
        // Fourth we read the property value for each property
        if (_isDouble(propertyKey, object!)) {
          double value = reader.readFloat32();
          RiveCoreContext.setDouble(object, propertyKey, value);
        } else if (_isColor(propertyKey, object)) {
          int value = reader.readInt32();
          RiveCoreContext.setColor(object, propertyKey, value);
        }
        currentPropertyIndex += 1;
      }
    }
  }
}

class _KeyedProperty {
  final KeyedProperty property;
  final bool isBaseline;
  _KeyedProperty(this.property, this.isBaseline);
  bool readProperty() {
    if (property.propertyKey == 1) {
      return true;
    }
    return false;
  }

  int get propertyKey {
    return property.propertyKey;
  }

  int get size {
    return 1 + 4; // property id + float value
  }
}

class _KeyedObject {
  final List<_KeyedProperty> properties = [];
  final KeyedObject data;
  final Set<int> visitedProperties = HashSet<int>();//{};
  _KeyedObject(this.data);
  void addProperties(
      Iterable<KeyedProperty> props, Core object, bool storeAsBaseline) {
    for (final property in props) {
      if (!visitedProperties.contains(property.propertyKey)) {
        visitedProperties.add(property.propertyKey);
        if (_isColor(property.propertyKey, object) ||
            _isDouble(property.propertyKey, object)) {
          properties.add(_KeyedProperty(property, storeAsBaseline));
        }
      }
    }
  }

  int get size {
    if (properties.isEmpty) {
      return 0;
    }
    int _size = 1 + 1; // object id + number of properties
    for (final property in properties) {
      _size += property.size;
    }
    return _size;
  }
}

class _AnimationsData {
  int size = 0;

  List<_KeyedObject> keyedObjects = [];
  Map<int, _KeyedObject> visitedObjects = HashMap<int, _KeyedObject>();//{};

  _AnimationsData(Iterable<LinearAnimation> animations, CoreContext core,
      bool useFirstAsBaseline) {
    bool isFirstAnimation = useFirstAsBaseline;
    for (final animation in animations) {
      // animation.keyedObjects.forEach((keyedObject) {
      for (final keyedObject in animation.keyedObjects) {
        final objectIntId = resolveId(keyedObject.objectId);
        final object = core.resolve<Core>(keyedObject.objectId);
        if (!visitedObjects.containsKey(objectIntId)) {
          visitedObjects[objectIntId] = _KeyedObject(keyedObject);
          keyedObjects.add(visitedObjects[objectIntId]!);
        }
        visitedObjects[objectIntId]!.addProperties(
            keyedObject.keyedProperties, object!, isFirstAnimation); // .toList()
      }//);
      isFirstAnimation = false;
    }
    for (final object in keyedObjects) {
      size += object.size;
    }
  }

  int resolveId(int intId) {
    return intId;
  }

  void writeObjects(AnimationReset animationReset, CoreContext core) {

    // keyedObjects.forEach((keyedObject) {
    for (final keyedObject in keyedObjects) {
      // We might have added keyed objects but no properties need resetting
      if (keyedObject.properties.isNotEmpty) {
        int objectIntId = resolveId(keyedObject.data.objectId);
        final object = core.resolve<Core>(keyedObject.data.objectId);

        animationReset.writeObjectId(objectIntId);
        animationReset.writeTotalProperties(keyedObject.properties.length);

        for (final property in keyedObject.properties) {
          if (_isColor(property.propertyKey, object!)) {
            animationReset.writePropertyKey(property.propertyKey);
            if (property.isBaseline) {
              animationReset.writeColor(
                  (property.property.keyframes.first as KeyFrameColor).value);
            } else {
              animationReset.writeColor(RiveCoreContext.getColor(
                  core.resolve(keyedObject.data.objectId),
                  property.propertyKey));
            }
          } else if (_isDouble(property.propertyKey, object)) {
            animationReset.writePropertyKey(property.propertyKey);
            if (property.isBaseline) {
              animationReset.writeDouble(
                  (property.property.keyframes.first as KeyFrameDouble).value_);
            } else {
              animationReset.writeDouble(RiveCoreContext.getDouble(
                  core.resolve(keyedObject.data.objectId),
                  property.propertyKey));
            }
          }
        }
      }
    }//);
    animationReset.createReader();
  }
}

List<AnimationReset> _pool = [];

AnimationReset fromAnimations(Iterable<LinearAnimation> animations,
    CoreContext core, bool useFirstAsBaseline) {
  final animationData = _AnimationsData(animations, core, useFirstAsBaseline);
  AnimationReset? animationReset;
  for (final pooled in _pool) {
    if (animationReset == null || animationReset.size > pooled.size) {
      animationReset = pooled;
    }
    if (pooled.size >= animationData.size) {
      break;
    }
  }
  if (animationReset != null) {
    _pool.remove(animationReset);
  } else {
    animationReset = AnimationReset();
  }
  animationData.writeObjects(animationReset, core);
  return animationReset;
}

List<LinearAnimation> _fromState(
    StateInstance? stateInstance, CoreContext core) {
  List<LinearAnimation> animations = [];
  if (stateInstance != null) {
    final state = stateInstance.state;
    if (state is AnimationState && state.animation != null) {
      animations.add(state.animation!);
    } else if (state is BlendState) {

      // state.animations.forEach((blend1DAnimation) {
      for (final blend1DAnimation in state.animations) {
        final animation =
            core.resolve<LinearAnimation>(blend1DAnimation.animationId);
        if (animation != null) {
          animations.add(animation);
        }
      }//);
    }
  }
  return animations;
}

AnimationReset fromStates(
    StateInstance? stateFrom, StateInstance? currentState, CoreContext core) {
  List<LinearAnimation> animations = [];
  animations.addAll(_fromState(currentState, core));
  animations.addAll(_fromState(stateFrom, core));
  return fromAnimations(animations, core, false);
}

void release(AnimationReset value) {
  value.clear();
  int index = 0;
  while (index < _pool.length) {
    final animationReset = _pool.elementAt(index);
    if (animationReset.size > value.size) {
      break;
    }
    index++;
  }
  _pool.insert(index, value);
  // TODO @hernan set a maximum pooling space. Perhaps remove the smallest
  // sizes?
  // if (_pool.length > 10) {}
}

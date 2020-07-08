import 'package:flutter/foundation.dart';
import 'package:rive/src/rive_core/bounds_delegate.dart';
import 'package:rive/src/rive_core/component_dirt.dart';
import 'package:rive/src/rive_core/container_component.dart';
import 'package:rive/src/rive_core/math/mat2d.dart';
import 'package:rive/src/rive_core/math/vec2d.dart';
import 'package:rive/src/generated/node_base.dart';
import 'package:meta/meta.dart';
export 'package:rive/src/generated/node_base.dart';

class Node extends NodeBase {
  final Mat2D transform = Mat2D();
  final Mat2D worldTransform = Mat2D();
  BoundsDelegate _delegate;
  double _renderOpacity = 0;
  double get renderOpacity => _renderOpacity;
  @override
  void update(int dirt) {
    if (dirt & ComponentDirt.transform != 0) {
      updateTransform();
    }
    if (dirt & ComponentDirt.worldTransform != 0) {
      updateWorldTransform();
    }
  }

  Vec2D get translation => Vec2D.fromValues(x, y);
  Vec2D get worldTranslation =>
      Vec2D.fromValues(worldTransform[4], worldTransform[5]);
  set translation(Vec2D pos) {
    x = pos[0];
    y = pos[1];
  }

  Vec2D get scale => Vec2D.fromValues(scaleX, scaleY);
  set scale(Vec2D value) {
    scaleX = value[0];
    scaleY = value[1];
  }

  void updateTransform() {
    if (rotation != 0) {
      Mat2D.fromRotation(transform, rotation);
    } else {
      Mat2D.identity(transform);
    }
    transform[4] = x;
    transform[5] = y;
    Mat2D.scaleByValues(transform, scaleX, scaleY);
  }

  double get childOpacity => _renderOpacity;
  @mustCallSuper
  void updateWorldTransform() {
    _renderOpacity = opacity;
    if (parent is Node) {
      var parentNode = parent as Node;
      _renderOpacity *= parentNode.childOpacity;
      Mat2D.multiply(worldTransform, parentNode.worldTransform, transform);
    } else {
      Mat2D.copy(worldTransform, transform);
    }
    _delegate?.boundsChanged();
  }

  @override
  void userDataChanged(dynamic from, dynamic to) {
    if (to is BoundsDelegate) {
      _delegate = to;
    } else {
      _delegate = null;
    }
  }

  void calculateWorldTransform() {
    var parent = this.parent;
    final chain = <Node>[this];
    while (parent != null) {
      if (parent is Node) {
        chain.insert(0, parent);
      }
      parent = parent.parent;
    }
    for (final item in chain) {
      item.updateTransform();
      item.updateWorldTransform();
    }
  }

  @override
  void buildDependencies() {
    super.buildDependencies();
    parent?.addDependent(this);
  }

  void markTransformDirty() {
    if (!addDirt(ComponentDirt.transform)) {
      return;
    }
    markWorldTransformDirty();
  }

  void markWorldTransformDirty() {
    addDirt(ComponentDirt.worldTransform, recurse: true);
  }

  @override
  void xChanged(double from, double to) {
    markTransformDirty();
  }

  @override
  void yChanged(double from, double to) {
    markTransformDirty();
  }

  @override
  void rotationChanged(double from, double to) {
    markTransformDirty();
  }

  @override
  void scaleXChanged(double from, double to) {
    markTransformDirty();
  }

  @override
  void scaleYChanged(double from, double to) {
    markTransformDirty();
  }

  @override
  void opacityChanged(double from, double to) {
    markTransformDirty();
  }

  @override
  void parentChanged(ContainerComponent from, ContainerComponent to) {
    super.parentChanged(from, to);
    markWorldTransformDirty();
  }
}

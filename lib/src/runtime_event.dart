import 'package:flutter/widgets.dart';
import 'package:rive/src/rive_core/custom_property_boolean.dart';
import 'package:rive/src/rive_core/custom_property_number.dart';
import 'package:rive/src/rive_core/custom_property_string.dart';
import 'package:rive/src/rive_core/event.dart';
import 'package:rive/src/rive_core/open_url_event.dart';
import 'package:rive/src/rive_core/open_url_target.dart';

/// A Rive Event that is reported from an StateMachineController.
///
/// See:
/// - [RiveGeneralEvent]
/// - [RiveOpenURLEvent]
///
/// For specific event types.
///
/// Documentation: https://rive.app/community/doc/rive-events/docbOnaeffgr
@immutable
class RiveEvent {
  final String name;
  final double secondsDelay;
  final Map<String, dynamic> properties;

  const RiveEvent({
    required this.name,
    required this.secondsDelay,
    required this.properties,
  });

  factory RiveEvent.fromCoreEvent(Event event) {
    final Map<String, dynamic> properties = {};
    for (final property in event.customProperties) {
      dynamic value;
      switch (property.coreType) {
        case CustomPropertyNumberBase.typeKey:
          value = (property as CustomPropertyNumber).propertyValue;
          break;
        case CustomPropertyStringBase.typeKey:
          value = (property as CustomPropertyString).propertyValue;
          break;
        case CustomPropertyBooleanBase.typeKey:
          value = (property as CustomPropertyBoolean).propertyValue;
          break;
      }
      if (value != null) {
        properties[property.name] = value;
      }
    }
    if (event.coreType == OpenUrlEventBase.typeKey) {
      event = event as OpenUrlEvent;
      return RiveOpenURLEvent(
        name: event.name,
        url: event.url,
        target: event.target,
        secondsDelay: event.secondsDelay,
        properties: properties,
      );
    } else {
      return RiveGeneralEvent(
        name: event.name,
        secondsDelay: event.secondsDelay,
        properties: properties,
      );
    }
  }

  @override
  String toString() => 'Rive Event - name: $name, properties: $properties';
}

/// A general Rive event that provides information about the event.
@immutable
class RiveGeneralEvent extends RiveEvent {
  const RiveGeneralEvent({
    required String name,
    required double secondsDelay,
    required Map<String, dynamic> properties,
  }) : super(name: name, secondsDelay: secondsDelay, properties: properties);

  @override
  String toString() =>
      'Rive GeneralEvent - name: $name, properties: $properties';
}

/// An Open URL Rive event that provides information about the URL and target.
///
/// See:
/// - [url]
/// - [target]
@immutable
class RiveOpenURLEvent extends RiveEvent {
  final String url;
  final OpenUrlTarget target;
  const RiveOpenURLEvent({
    required String name,
    required double secondsDelay,
    required Map<String, dynamic> properties,
    required this.target,
    required this.url,
  }) : super(name: name, secondsDelay: secondsDelay, properties: properties);

  @override
  String toString() =>
      'Rive OpenURLEvent - name: $name, properties: $properties';
}

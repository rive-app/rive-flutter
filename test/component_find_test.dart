// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rive/rive.dart';

import 'src/utils.dart';

class MockAssetBundle extends Mock implements AssetBundle {}

void main() {
  setUpAll(() {});
  group("Test finding components on artboard", () {
    test('Find a component of a specific type with a specific name.', () async {
      final riveBytes = loadFile('assets/component_discovery.riv');
      final riveFile = RiveFile.import(riveBytes);
      final artboard = riveFile.mainArtboard.instance();

      final nestedArtboard =
          artboard.component<RuntimeNestedArtboard>("NestedArtboardFindMe");
      expect(nestedArtboard, isNotNull);
      expect(nestedArtboard!.name, "NestedArtboardFindMe");

      final textRun = artboard.component<TextValueRun>("TextRunFindMe");
      expect(textRun, isNotNull);
      expect(textRun!.name, "TextRunFindMe");

      final shapeEllipse = artboard.component<Shape>("EllipseFindMe");
      expect(shapeEllipse, isNotNull);
      expect(shapeEllipse!.name, "EllipseFindMe");

      final shapeRectangle = artboard.component<Shape>("RectangleFindMe");
      expect(shapeRectangle, isNotNull);
      expect(shapeRectangle!.name, "RectangleFindMe");

      final notFoundComponent = artboard.component<Shape>("DoesNotExist");
      expect(notFoundComponent, isNull);
    });

    test('Get a component that matches the given predicate', () async {
      final riveBytes = loadFile('assets/component_discovery.riv');
      final riveFile = RiveFile.import(riveBytes);
      final artboard = riveFile.mainArtboard.instance();

      final nestedArtboard =
          artboard.getComponentWhereOrNull<RuntimeNestedArtboard>(
              (component) => component.name.startsWith("NestedArtboard"));

      expect(nestedArtboard, isNotNull);
      expect(nestedArtboard!.name, "NestedArtboardFindMe");

      final textRun = artboard.getComponentWhereOrNull<TextValueRun>(
          (component) => component.name.startsWith("TextRun"));

      expect(textRun, isNotNull);
      expect(textRun!.name, "TextRunFindMe");

      final shapeEllipse = artboard.getComponentWhereOrNull<Shape>(
          (component) => component.name.startsWith("Ellipse"));

      expect(shapeEllipse, isNotNull);
      expect(shapeEllipse!.name, "EllipseFindMe");

      final shapeRectangle = artboard.getComponentWhereOrNull<Shape>(
          (component) => component.name.startsWith("Rectangle"));

      expect(shapeRectangle, isNotNull);
      expect(shapeRectangle!.name, "RectangleFindMe");

      final notFoundComponent = artboard.getComponentWhereOrNull<TextValueRun>(
          (component) => component.name.startsWith("DoesNotExist"));
      expect(notFoundComponent, isNull);
    });
  });
}

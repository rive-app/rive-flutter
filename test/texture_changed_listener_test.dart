import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rive_native/rive_native.dart' as rive;

/// Minimal concrete [rive.RenderTexture] exercising only the texture-changed
/// listener plumbing (the rest throws since it isn't needed here).
base class _ListenerTexture extends rive.RenderTexture {
  @override
  int get textureId => -1;
  @override
  dynamic get nativeTexture => null;
  @override
  int get actualWidth => 0;
  @override
  int get actualHeight => 0;
  @override
  bool get isReady => true;
  @override
  bool get isDisposed => false;
  @override
  rive.Renderer get renderer => throw UnimplementedError();
  @override
  bool clear(Color color, [bool write = true]) => true;
  @override
  bool flush(double devicePixelRatio) => true;
  @override
  bool needsResize(int width, int height) => false;
  @override
  Future<void> makeRenderTexture(int width, int height) async {}
  @override
  Future<ui.Image> toImage() => throw UnimplementedError();
  @override
  Widget widget({rive.RenderTexturePainter? painter, Key? key}) =>
      throw UnimplementedError();
  @override
  void dispose() {}
}

void main() {
  group('RenderTexture texture-changed listeners', () {
    test('every registered listener fires on textureChanged', () {
      final texture = _ListenerTexture();
      var a = 0;
      var b = 0;
      void listenerA() => a++;
      void listenerB() => b++;

      texture.addTextureChangedListener(listenerA);
      texture.addTextureChangedListener(listenerB);

      texture.textureChanged();

      // This is the multi-viewport regression: with a single callback slot the
      // second registration would silently overwrite the first.
      expect(a, 1);
      expect(b, 1);
    });

    test('removeTextureChangedListener stops a single listener', () {
      final texture = _ListenerTexture();
      var a = 0;
      var b = 0;
      void listenerA() => a++;
      void listenerB() => b++;

      texture.addTextureChangedListener(listenerA);
      texture.addTextureChangedListener(listenerB);
      texture.removeTextureChangedListener(listenerA);

      texture.textureChanged();

      expect(a, 0);
      expect(b, 1);
    });

    test('removeAllTextureChangedListeners clears everything', () {
      final texture = _ListenerTexture();
      var count = 0;
      texture.addTextureChangedListener(() => count++);
      texture.addTextureChangedListener(() => count++);

      texture.removeAllTextureChangedListeners();
      texture.textureChanged();

      expect(count, 0);
    });

    test('the deprecated single callback still fires alongside listeners', () {
      final texture = _ListenerTexture();
      var listener = 0;
      var single = 0;
      texture.addTextureChangedListener(() => listener++);
      // ignore: deprecated_member_use
      texture.onTextureChanged = () => single++;

      texture.textureChanged();

      expect(listener, 1);
      expect(single, 1);
    });

    test('a listener can remove itself during the callback', () {
      final texture = _ListenerTexture();
      var a = 0;
      var b = 0;
      late void Function() listenerA;
      listenerA = () {
        a++;
        // Mutating the list mid-notification must not throw — textureChanged
        // iterates over a copy.
        texture.removeTextureChangedListener(listenerA);
      };
      texture.addTextureChangedListener(listenerA);
      texture.addTextureChangedListener(() => b++);

      texture.textureChanged();
      texture.textureChanged();

      expect(a, 1); // removed itself after the first notification
      expect(b, 2);
    });
  });
}

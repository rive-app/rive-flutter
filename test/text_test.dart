import 'dart:ffi';
import 'package:flutter_test/flutter_test.dart';
// ignore: implementation_imports
import 'package:rive/src/rive_text.dart';
import 'src/utils.dart';

void main() {
  test('simple shaping', () {
    final bytes = loadFile('assets/RobotoFlex.ttf');
    expect(bytes.lengthInBytes, 1654412);

    DynamicLibrary.open('shared_lib/build/bin/debug/librive_text.dylib');

    var roboto = Font.decode(bytes.buffer.asUint8List());
    expect(roboto, isNotNull);
  });
}

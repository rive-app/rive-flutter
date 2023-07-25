import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rive/rive.dart';

import 'mocks/mocks.dart';
import 'src/network.dart';
import 'src/utils.dart';

void main() {
  late MockHttpClient mockHttpClient;

  // ignore: close_sinks
  late MockHttpClientRequest request;

  setUpAll(() {
    registerFallbackValue(ArtboardFake());
    registerFallbackValue(Uri());
    registerFallbackValue(Stream.value(<int>[]));
    // Build our app and trigger a frame.
    final riveBytes = loadFile('assets/rive-flutter-test-asset.riv');
    final body = riveBytes.buffer.asUint8List();
    mockHttpClient = getMockHttpClient();

    request = prepMockRequest(mockHttpClient, body);
  });

  testWidgets('Using the network, calls the http client without headers',
      (WidgetTester tester) async {
    await HttpOverrides.runZoned(() async {
      await tester.pumpWidget(
        const MaterialApp(
          home: RiveAnimation.network('https://some.fake.url'),
        ),
      );
    }, createHttpClient: (_) => mockHttpClient);

    verify(() => mockHttpClient.openUrl(any(), any())).called(1);
    verifyNever(() => request.headers.set(any(), any()));
  });

  testWidgets('Using the network, calls the http client with headers',
      (WidgetTester tester) async {
    await HttpOverrides.runZoned(() async {
      await tester.pumpWidget(
        const MaterialApp(
          home: RiveAnimation.network('https://some.fake.url', headers: {
            'first': 'header',
            'second': 'header',
          }),
        ),
      );
    }, createHttpClient: (_) => mockHttpClient);

    verify(() => mockHttpClient.openUrl(any(), any())).called(1);
    verify(() => request.headers.set(any(), any())).called(2);
  });
}

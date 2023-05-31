import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rive/rive.dart';

import 'mocks/mocks.dart';
import 'src/utils.dart';

class MockHttpClient extends Mock implements HttpClient {}

class MockHttpClientRequest extends Mock implements HttpClientRequest {}

class MockHttpClientResponse extends Mock implements HttpClientResponse {}

class MockHttpHeaders extends Mock implements HttpHeaders {}

void main() {
  late MockHttpClient mockHttpClient;
  late MockHttpClientRequest request;
  setUpAll(() {
    registerFallbackValue(ArtboardFake());
    registerFallbackValue(Uri());
    registerFallbackValue(Stream.value(<int>[]));
    // Build our app and trigger a frame.
    final riveBytes = loadFile('assets/rive-flutter-test-asset.riv');
    final body = riveBytes.buffer.asUint8List();
    mockHttpClient = MockHttpClient();
    request = MockHttpClientRequest();

    when(() => request.headers).thenReturn(MockHttpHeaders());

    when(() => mockHttpClient.openUrl(any(), any())).thenAnswer((invocation) {
      final response = MockHttpClientResponse();
      when(request.close).thenAnswer((_) => Future.value(response));
      when(() => request.addStream(any())).thenAnswer((_) async => null);
      when(() => response.headers).thenReturn(MockHttpHeaders());
      when(() => response.handleError(any(), test: any(named: 'test')))
          .thenAnswer((_) => Stream.value(body));
      when(() => response.statusCode).thenReturn(200);
      when(() => response.reasonPhrase).thenReturn('OK');
      when(() => response.contentLength).thenReturn(body.length);
      when(() => response.isRedirect).thenReturn(false);
      when(() => response.persistentConnection).thenReturn(false);
      return Future.value(request);
    });
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

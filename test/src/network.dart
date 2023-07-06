import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements HttpClient {}

class MockHttpClientRequest extends Mock implements HttpClientRequest {}

class MockHttpClientResponse extends Mock implements HttpClientResponse {}

class MockHttpHeaders extends Mock implements HttpHeaders {}

MockHttpClient getMockHttpClient() => MockHttpClient();
MockHttpClientRequest prepMockRequest(
  MockHttpClient httpClient,
  Uint8List body,
) {
  MockHttpClientRequest request = MockHttpClientRequest();

  when(() => request.headers).thenReturn(MockHttpHeaders());

  when(() => httpClient.openUrl(any(), any())).thenAnswer((invocation) {
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
  return request;
}

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:valuefinder/core/services/firebase_services/upload_image_api_service.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  setUpAll(() {
    registerFallbackValue(
        http.Request('POST', Uri.parse('https://mockserver.com/upload')));
  });

  group('UploadImageApiService', () {
    late UploadImageApiService apiService;
    late MockClient client;

    setUp(() {
      client = MockClient();
      apiService = UploadImageApiService(
        baseUrl: 'https://mockserver.com/upload',
        token: 'mockToken',
      );
    });

    test('uploads image successfully', () async {
      // Create a temporary file
      final tempFile = File('test/temp_test_image.png');
      tempFile.writeAsBytesSync([0, 1, 2, 3, 4]); // Write some dummy bytes

      final response = http.Response('{"status": "success"}', 200);

      // Mock the client to return the expected response
      when(() => client.send(any()))
          .thenAnswer((_) async => http.StreamedResponse(
                Stream.fromIterable([response.bodyBytes]),
                response.statusCode,
                headers: response.headers,
              ));

      final result = await apiService.uploadImage(tempFile);

      // Check the response
      expect(result.statusCode, 200);
      expect(result.body, '{"status": "success"}');

      // Clean up the temporary file
      tempFile.deleteSync();
    });

    test('fails to upload image due to HTTP error', () async {
      // Create a temporary file
      final tempFile = File('test/temp_test_image.png');
      tempFile.writeAsBytesSync([0, 1, 2, 3, 4]); // Write some dummy bytes

      final response = http.Response('{"error": "failed"}', 500);

      // Mock the client to return the expected response
      when(() => client.send(any()))
          .thenAnswer((_) async => http.StreamedResponse(
                Stream.fromIterable([response.bodyBytes]),
                response.statusCode,
                headers: response.headers,
              ));

      final result = await apiService.uploadImage(tempFile);

      // Check the response
      expect(result.statusCode, 500);
      expect(result.body, '{"error": "failed"}');

      // Clean up the temporary file
      tempFile.deleteSync();
    });
  });
}

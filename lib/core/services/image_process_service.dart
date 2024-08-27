// lib/core/services/image_processing_service.dart

import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:valuefinder/core/constants/constants.dart';
import 'package:valuefinder/core/error/failures.dart';
import 'package:valuefinder/features/data/models/product.dart';

class ImageProcessingService {
  final String imageUrl;
  final FirebaseAuth auth;

  ImageProcessingService({
    required this.imageUrl,
    required this.auth,
  });

  Future<void> processImage(
      Function(String keyword, List<Product> products) onSuccess,
      Function(Failure) onError,
      Function(String message)? onUnclearObject) async {
    try {
      User? user = auth.currentUser;
      if (user == null) {
        throw PhotoCaptureFailure(message: 'No user is currently signed in.');
      }

      String? token = await user.getIdToken();
      if (token == null) {
        throw PhotoCaptureFailure(
            message: 'Failed to retrieve Firebase ID token.');
      }

      // Step 1: Send image URL to initial endpoint
      final response = await http.post(
        Uri.parse(createThreadBaseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'url': imageUrl}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final String runId = result['runId'] ?? '';
        final String threadId = result['threadId'] ?? '';
        final List toolCalls = result['toolCalls'] ?? [];

        String keyword = '';
        for (var call in toolCalls) {
          if (call['type'] == 'function') {
            final functionArgs = jsonDecode(call['function']['arguments']);
            keyword = functionArgs['keyword'] ?? '';
            break;
          }
        }

        if (keyword.isEmpty) {
          if (onUnclearObject != null) {
            onUnclearObject('Object is not clear. Please provide more images.');
          }
          return;
        }

        // Step 2: Use the extracted keyword to get details from shopping URL
        final recognitionResponse = await http.get(
          Uri.parse('$shoppingBaseUrl?keyword=$keyword'),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (recognitionResponse.statusCode == 200) {
          final recognitionResult = jsonDecode(recognitionResponse.body);
          final List<Product> products = (recognitionResult['products'] as List)
              .map((json) => Product.fromJson(json as Map<String, dynamic>))
              .toList();

          onSuccess(keyword, products);
        } else {
          final errorResponse = jsonDecode(recognitionResponse.body);
          throw ServerFailure(
              'Failed to recognize the image: ${errorResponse['error']}');
        }
      } else {
        final errorResponse = jsonDecode(response.body);
        if (errorResponse['error'] == 'object not clear') {
          throw ServerFailure(
              'The object in the image is not clear. Please provide more images.');
        } else {
          throw ServerFailure(
              'Failed to process image: ${errorResponse['error']}');
        }
      }
    } catch (e) {
      if (e is Failure) {
        onError(e);
      } else {
        onError(ServerFailure('Failed to process image: $e'));
      }
    }
  }
}

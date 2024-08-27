import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:valuefinder/core/constants/constants.dart';
import 'package:valuefinder/core/error/failures.dart';
import 'package:valuefinder/core/services/firebase_services/upload_image_api_service.dart';

Future<void> uploadImageToFirebase(
    BuildContext context, XFile file, Function(String?) onImageUploaded) async {
  try {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      String? token = await user.getIdToken();
      if (token != null) {
        final uploadImageApiService = UploadImageApiService(
          baseUrl: uploadImageBaseUrl,
          token: token,
        );
        final uploadResponse =
            await uploadImageApiService.uploadImage(File(file.path));

        if (uploadResponse.statusCode == 200) {
          final responseBody = uploadResponse.body;
          final Map<String, dynamic> responseJson = responseBody is String
              ? jsonDecode(responseBody)
              : responseBody as Map<String, dynamic>;
          final imageUrl = responseJson['url'] as String?;

          onImageUploaded(imageUrl);
        } else {
          // Use ServerFailure for API-related issues
          throw ServerFailure(
              'Error uploading image: ${uploadResponse.statusCode}');
        }
      } else {
        // Use Authentication Failure
        throw ServerFailure('Error obtaining authentication token');
      }
    } else {
      // Use Authentication Failure
      throw ServerFailure('User is not logged in');
    }
  } catch (e) {
    // Handle specific errors based on the type of exception
    if (e is Failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
    }
  }
}

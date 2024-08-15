import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:valuefinder/core/error/failures.dart';
import 'package:valuefinder/core/services/firebase_services/upload_image_to_firebase_service.dart';

Future<void> pickImageFromGallery(BuildContext context,
    Function(File?) onImagePicked, Function(String?) onImageUploaded) async {
  final picker = ImagePicker();
  try {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final image = File(pickedFile.path);
      onImagePicked(image);

      // Upload image to Firebase Storage
      await uploadImageToFirebase(
        context,
        pickedFile,
        (imageUrl) {
          if (imageUrl != null) {
            onImageUploaded(imageUrl);
          } else {
            // Use specific Failure for URL issues
            throw ServerFailure('Failed to get image URL');
          }
        },
      );
    } else {
      // Use GalleryAccessFailure for no image selected
      throw GalleryAccessFailure('No image selected.');
    }
  } catch (e) {
    // Handle specific errors and call onImageUploaded with null to indicate failure
    if (e is Failure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
      onImageUploaded(null);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: ${e.toString()}')),
      );
      onImageUploaded(null);
    }
  }
}

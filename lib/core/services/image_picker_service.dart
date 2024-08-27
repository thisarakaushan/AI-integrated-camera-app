import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img; // Add image package for conversions

import 'package:valuefinder/core/error/failures.dart';
import 'package:valuefinder/core/services/firebase_services/upload_image_to_firebase_service.dart';

Future<void> pickImageFromGallery(BuildContext context,
    Function(File?) onImagePicked, Function(String?) onImageUploaded) async {
  final picker = ImagePicker();
  try {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File image = File(pickedFile.path);

      // Convert HEIC image to JPEG
      if (pickedFile.path.endsWith('.heic') ||
          pickedFile.path.endsWith('.heif')) {
        final originalImage = img.decodeImage(image.readAsBytesSync());
        if (originalImage != null) {
          final convertedImagePath =
              pickedFile.path.replaceAll('.heic', '.jpg');
          image = File(convertedImagePath)
            ..writeAsBytesSync(img.encodeJpg(originalImage));
        } else {
          throw ConversionFailure('Failed to convert image from HEIC.');
        }
      }

      onImagePicked(image);

      // Upload image to Firebase Storage
      await uploadImageToFirebase(
        context,
        XFile(image.path), // Use the possibly converted image
        (imageUrl) {
          if (imageUrl != null) {
            onImageUploaded(imageUrl);
          } else {
            throw ServerFailure('Failed to get image URL');
          }
        },
      );
    } else {
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

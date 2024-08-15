// import 'dart:io';
// import 'dart:typed_data';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:permission_handler/permission_handler.dart';

// class CapturePhoto {
//   Future<void> savePhotoToGallery(String imagePath) async {
//     if (await Permission.storage.request().isGranted) {
//       try {
//         final File imageFile = File(imagePath);
//         if (!await imageFile.exists()) {
//           return;
//         }
//         final Uint8List bytes = await imageFile.readAsBytes();

//         final result = await ImageGallerySaver.saveImage(
//           bytes,
//           quality: 100,
//           name: 'captured_image_${DateTime.now().millisecondsSinceEpoch}',
//         );

//         // Optionally, print the result or handle it if needed
//         print('Image saved to gallery: $result');
//       } catch (e) {
//         print('Error saving image to gallery: $e');
//       }
//     } else {
//       print('Storage permission not granted');
//     }
//   }
// }

import 'dart:io';
import 'dart:typed_data';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dartz/dartz.dart'; // Import dartz for Either and Unit
import 'package:valuefinder/core/error/failures.dart';

class CapturePhoto {
  Future<Either<Failure, Unit>> savePhotoToGallery(String imagePath) async {
    // Check storage permission
    final permissionStatus = await Permission.storage.request();
    if (!permissionStatus.isGranted) {
      return Left(StoragePermissionFailure('Storage permission not granted'));
    }

    try {
      // Check if the file exists
      final File imageFile = File(imagePath);
      if (!await imageFile.exists()) {
        return Left(GalleryAccessFailure('Image file does not exist'));
      }

      // Read the image file as bytes
      final Uint8List bytes = await imageFile.readAsBytes();

      // Save the image to gallery
      final result = await ImageGallerySaver.saveImage(
        bytes,
        quality: 100,
        name: 'captured_image_${DateTime.now().millisecondsSinceEpoch}',
      );

      // Check result and handle errors
      if (result == null || result is Map && result['isSuccess'] != true) {
        return Left(GalleryAccessFailure('Failed to save image to gallery'));
      }

      return const Right(
          unit); // Return success with a singleton instance of Unit
    } catch (e) {
      // Catch and return any other errors
      return Left(GalleryAccessFailure('Error saving image to gallery: $e'));
    }
  }
}

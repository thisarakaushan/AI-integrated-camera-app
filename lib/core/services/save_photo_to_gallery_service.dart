// import 'dart:io';
// import 'dart:typed_data';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:dartz/dartz.dart';
// import 'package:valuefinder/core/error/failures.dart';

// class CapturePhoto {
//   Future<Either<Failure, Unit>> savePhotoToGallery(String imagePath) async {
//     // Check storage permission
//     final permissionStatus = await Permission.storage.request();
//     if (!permissionStatus.isGranted) {
//       return Left(StoragePermissionFailure('Storage permission not granted'));
//     }

//     try {
//       // Check if the file exists
//       final File imageFile = File(imagePath);
//       if (!await imageFile.exists()) {
//         return Left(GalleryAccessFailure('Image file does not exist'));
//       }

//       // Read the image file as bytes
//       final Uint8List bytes = await imageFile.readAsBytes();

//       // Save the image to gallery
//       final result = await ImageGallerySaver.saveImage(
//         bytes,
//         quality: 100,
//         name: 'captured_image_${DateTime.now().millisecondsSinceEpoch}',
//       );

//       // Check result and handle errors
//       if (result == null || result is Map && result['isSuccess'] != true) {
//         return Left(GalleryAccessFailure('Failed to save image to gallery'));
//       }

//       return const Right(
//           unit); // Return success with a singleton instance of Unit
//     } catch (e) {
//       // Catch and return any other errors
//       return Left(GalleryAccessFailure('Error saving image to gallery: $e'));
//     }
//   }
// }
// -------------------------------------------------------------------------------------------------------
 // Future<void> _capturePhoto() async {
  //   // Show capturing progress
  //   setState(() {
  //     _progressState = ProgressState.capturing;
  //   });

  //   try {
  //     await _initializeControllerFuture;
  //     if (_cameraController == null) return;

  //     // Capture photo
  //     final XFile photo = await _cameraController!.takePicture();

  //     // Process the captured photo (cropping, saving, uploading)...

  //     // Load image for cropping
  //     final originalImage =
  //         img.decodeImage(await File(photo.path).readAsBytes());

  //     if (originalImage == null) return;

  //     // Calculate the cropping area based on the lens size and position
  //     final int cropWidth = (originalImage.width * 0.8).toInt();
  //     final int cropHeight = cropWidth; // Assuming the lens is square
  //     final int offsetX = (originalImage.width - cropWidth) ~/ 2;
  //     final int offsetY = (originalImage.height - cropHeight) ~/ 2;

  //     // offset to adjust for the shift
  //     //const double shiftOffsetX = 10.0; // upward shift
  //     const double shiftOffsetY = 200.0; // downward shift

  //     final croppedImage = img.copyCrop(
  //       originalImage,
  //       x: offsetX,
  //       y: (offsetY - shiftOffsetY).toInt(),
  //       width: cropWidth,
  //       height: cropHeight,
  //     );

  //     // Save the cropped image to a file
  //     final croppedImagePath = '${photo.path}_cropped.jpg';
  //     final croppedFile = File(croppedImagePath)
  //       ..writeAsBytesSync(img.encodeJpg(croppedImage));

  //     // Convert the File to XFile
  //     final XFile croppedXFile = XFile(croppedFile.path);

  //     // Save to gallery
  //     final result = await CapturePhoto().savePhotoToGallery(croppedImagePath);
  //     result.fold(
  //       (failure) => ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text(failure.message)),
  //       ),
  //       (_) async {
  //         // Upload the cropped image to Firebase
  //         await uploadImageToFirebase(
  //             // Pass the XFile to the upload function
  //             context,
  //             croppedXFile, (imageUrl) {
  //           _navigateToPhotoCapturePage(imageUrl!);
  //         });
  //       },
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error capturing photo: $e')),
  //     );
  //   } finally {
  //     // Hide progress on error
  //     setState(() {
  //       _progressState = ProgressState.none;
  //     });
  //   }
  // }

// import 'dart:io';
// import 'dart:typed_data';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:dartz/dartz.dart';
// import 'package:valuefinder/core/error/failures.dart';

// class CapturePhoto {
//   Future<Either<Failure, Unit>> savePhotoToGallery(String imagePath) async {
//     // Check storage permission
//     final permissionStatus = await Permission.storage.request();
//     if (!permissionStatus.isGranted) {
//       return Left(StoragePermissionFailure('Storage permission not granted'));
//     }

//     try {
//       // Check if the file exists
//       final File imageFile = File(imagePath);
//       if (!await imageFile.exists()) {
//         return Left(GalleryAccessFailure('Image file does not exist'));
//       }

//       // Read the image file as bytes
//       final Uint8List bytes = await imageFile.readAsBytes();

//       // Save the image to gallery
//       final result = await ImageGallerySaver.saveImage(
//         bytes,
//         quality: 100,
//         name: 'captured_image_${DateTime.now().millisecondsSinceEpoch}',
//       );

//       // Check result and handle errors
//       if (result == null || result is Map && result['isSuccess'] != true) {
//         return Left(GalleryAccessFailure('Failed to save image to gallery'));
//       }

//       return const Right(
//           unit); // Return success with a singleton instance of Unit
//     } catch (e) {
//       // Catch and return any other errors
//       return Left(GalleryAccessFailure('Error saving image to gallery: $e'));
//     }
//   }
// }


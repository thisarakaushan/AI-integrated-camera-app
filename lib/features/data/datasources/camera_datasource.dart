import 'package:dartz/dartz.dart';
import 'package:valuefinder/core/error/failures.dart';
import '../models/camera_image_model.dart';

abstract class CameraDataSource {
  Future<Either<Failure, CameraImageModel>> capturePhoto();
  Future<Either<Failure, CameraImageModel>> pickImage();
}



// import 'package:dartz/dartz.dart';

// class CameraDataSource {
//   Future<Either<Failure, String>> capturePhoto() async {
//     try {
//       // Your camera capture logic here
//       final photoPath = await _capturePhotoFromCamera();
//       return Right(photoPath);
//     } catch (e) {
//       return Left(PhotoCaptureFailure(message: e.toString()));
//     }
//   }

//   Future<String> _capturePhotoFromCamera() async {
//     // Simulate camera capture logic
//     throw Exception("Camera capture error");
//   }
// }
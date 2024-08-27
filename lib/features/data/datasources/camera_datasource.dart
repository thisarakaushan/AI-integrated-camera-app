import 'package:dartz/dartz.dart';
import 'package:valuefinder/core/error/failures.dart';
import '../models/camera_image_model.dart';

abstract class CameraDataSource {
  Future<Either<Failure, CameraImageModel>> capturePhoto();
  Future<Either<Failure, CameraImageModel>> pickImage();
}

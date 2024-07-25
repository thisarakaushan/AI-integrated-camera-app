import 'package:dartz/dartz.dart';
import 'package:valuefinder/core/error/failures.dart';
import 'package:valuefinder/features/domain/entities/camera_image.dart';

abstract class CameraImageRepository {
  //Future<CameraImageEntity> capturePhoto();
  //Future<CameraImageEntity> pickImage();

  Future<Either<Failure, CameraImageEntity>> capturePhoto();
  Future<Either<Failure, CameraImageEntity>> pickImage();
}

import 'package:dartz/dartz.dart';
import 'package:valuefinder/core/error/failures.dart';

import '../entities/camera_image.dart';
import '../repositories/camera_image_repository.dart';

class PickImageUseCase {
  final CameraImageRepository cameraImageRepository;

  PickImageUseCase(this.cameraImageRepository);

  Future<Either<Failure, CameraImageEntity>> call() {
    return cameraImageRepository.pickImage();
  }
}

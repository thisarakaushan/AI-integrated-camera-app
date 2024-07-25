import 'package:dartz/dartz.dart';
import 'package:valuefinder/core/error/failures.dart';
import 'package:valuefinder/features/domain/entities/camera_image.dart';
import '../repositories/camera_image_repository.dart';

class CapturePhotoUseCase {
  final CameraImageRepository cameraImageRepository;

  CapturePhotoUseCase(this.cameraImageRepository);

  // Future<CameraImageEntity> execute() {
  //   return repository.capturePhoto();
  // }

  // Future<CameraImageEntity> call() async {
  //   return await repository.capturePhoto();
  // }

  Future<Either<Failure, CameraImageEntity>> call() {
    return cameraImageRepository.capturePhoto();
  }
}

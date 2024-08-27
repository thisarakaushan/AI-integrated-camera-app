import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
import 'package:valuefinder/core/error/failures.dart';
import 'package:valuefinder/features/domain/entities/camera_image.dart';
import 'package:valuefinder/features/domain/repositories/camera_image_repository.dart';
import '../datasources/camera_datasource.dart';

@LazySingleton(as: CameraImageRepository)
class CameraImageRepositoryImpl implements CameraImageRepository {
  final CameraDataSource dataSource;

  CameraImageRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, CameraImageEntity>> capturePhoto() async {
    try {
      final result = await dataSource.capturePhoto();
      return result.fold(
        (failure) => Left(failure), // failure from data source
        (cameraImageModel) =>
            Right(cameraImageModel), // success from data source
      );
    } catch (e) {
      return Left(PhotoCaptureFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CameraImageEntity>> pickImage() async {
    try {
      final result = await dataSource.pickImage();
      return result.fold(
        (failure) => Left(failure), // failure from data source
        (cameraImageModel) =>
            Right(cameraImageModel), // success from data source
      );
    } catch (e) {
      return Left(ImagePickerFailure(message: e.toString()));
    }
  }
}

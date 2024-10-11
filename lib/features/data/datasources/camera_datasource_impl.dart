import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:valuefinder/core/error/failures.dart';
import 'package:valuefinder/features/data/datasources/camera_datasource.dart';
import 'package:valuefinder/features/data/models/camera_image_model.dart';

class CameraDataSourceImpl implements CameraDataSource {
  final CameraController cameraController;
  final ImagePicker imagePicker;

  CameraDataSourceImpl(this.cameraController, this.imagePicker);

  @override
  Future<Either<Failure, CameraImageModel>> capturePhoto() async {
    try {
      await cameraController.initialize();
      final XFile photo = await cameraController.takePicture();
      return Right(CameraImageModel(path: photo.path));
    } catch (e) {
      return Left(PhotoCaptureFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CameraImageModel>> pickImage() async {
    try {
      final pickedFile =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        return Right(CameraImageModel(path: pickedFile.path));
      } else {
        return const Left(ImagePickerFailure(message: 'No image selected'));
      }
    } catch (e) {
      return Left(ImagePickerFailure(message: e.toString()));
    }
  }
}

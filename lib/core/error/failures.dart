import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

// General Failures
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class PhotoCaptureFailure extends Failure {
  const PhotoCaptureFailure({required String message}) : super(message);
}

class GalleryAccessFailure extends Failure {
  const GalleryAccessFailure(super.message);
}

class StoragePermissionFailure extends Failure {
  const StoragePermissionFailure(super.message);
}

// Specific Failures for Camera App
class CameraInitializationFailure extends Failure {
  const CameraInitializationFailure({required String message}) : super(message);
}

class ImagePickerFailure extends Failure {
  const ImagePickerFailure({required String message}) : super(message);
}

// Custom Failures for Navigation
class ImageNavigationFailure extends Failure {
  const ImageNavigationFailure(super.message);
}

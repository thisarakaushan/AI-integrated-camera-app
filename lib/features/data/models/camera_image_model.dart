import '../../domain/entities/camera_image.dart';

class CameraImageModel extends CameraImageEntity {
  CameraImageModel({required super.path});

  factory CameraImageModel.fromFile(String filePath) {
    return CameraImageModel(path: filePath);
  }

  // From JSON
  factory CameraImageModel.fromJson(Map<String, dynamic> json) {
    return CameraImageModel(
      path: json['path'] as String,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'path': path,
    };
  }
}

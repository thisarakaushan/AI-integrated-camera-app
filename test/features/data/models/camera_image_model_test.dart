import 'package:flutter_test/flutter_test.dart';
import 'package:valuefinder/features/data/models/camera_image_model.dart';
import 'package:valuefinder/features/domain/entities/camera_image.dart';

/**
 * We will test 3 main things
 * 1. The model that we have created equal with entities at the domain layer
 * 2. Does the from Json function return a valid model 
 * 3. Does the to Json function returns the appropriate Json map
 */

void main() {
  final testCameraImageModel = CameraImageModel(path: 'path/to/photo.jpg');

  group('CameraImageModel', () {
    test('should be a subclass of CameraImageEntity', () {
      // Check if CameraImageModel is a subclass of CameraImageEntity
      expect(testCameraImageModel, isA<CameraImageEntity>());
    });

    test('should create a valid model from JSON', () {
      // Arrange
      final Map<String, dynamic> json = {
        'path': 'path/to/photo.jpg',
      };

      // Act
      final result = CameraImageModel.fromJson(json);

      // Assert
      expect(result, isA<CameraImageModel>());
      expect(result.path, 'path/to/photo.jpg');
    });

    test('should convert a model to JSON', () {
      // Arrange
      final expectedJson = {
        'path': 'path/to/photo.jpg',
      };

      // Act
      final result = testCameraImageModel.toJson();

      // Assert
      expect(result, expectedJson);
    });
  });
}

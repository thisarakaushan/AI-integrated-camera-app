import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:valuefinder/core/error/failures.dart';
import 'package:valuefinder/features/domain/entities/camera_image.dart';
import 'package:valuefinder/features/domain/usecases/capture_photo.dart';

import '../../../helpers/test_helper.mocks.dart';

// we want to ensure the repo actually call or not and
// data simply passes unchanged through the usecase
void main() {
  late CapturePhotoUseCase capturePhotoUseCase;
  late MockCameraImageRepository mockCameraImageRepository;

  setUp(() {
    mockCameraImageRepository = MockCameraImageRepository();
    capturePhotoUseCase = CapturePhotoUseCase(mockCameraImageRepository);
  });

  test('should capture the photo and return the path', () async {
    // Arrange
    const CameraImageEntity imageEntity =
        CameraImageEntity(path: 'path/to/photo.jpg');
    when(mockCameraImageRepository.capturePhoto())
        .thenAnswer((_) async => const Right(imageEntity));

    // Act
    final result = await capturePhotoUseCase();

    // Assert
    expect(result, const Right(imageEntity));
    verify(mockCameraImageRepository.capturePhoto());
    verifyNoMoreInteractions(mockCameraImageRepository);
  });

  test('should return failure when capturing photo fails', () async {
    // Arrange
    const failure =
        CameraInitializationFailure(message: 'Failed to initialize camera');
    when(mockCameraImageRepository.capturePhoto())
        .thenAnswer((_) async => const Left(failure));

    // Act
    final result = await capturePhotoUseCase();

    // Assert
    expect(result, const Left(failure));
    verify(mockCameraImageRepository.capturePhoto());
    verifyNoMoreInteractions(mockCameraImageRepository);
  });
}

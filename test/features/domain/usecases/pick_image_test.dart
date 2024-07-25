import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:valuefinder/core/error/failures.dart';
import 'package:valuefinder/features/domain/entities/camera_image.dart';
import 'package:valuefinder/features/domain/usecases/pick_image.dart';

import '../../../helpers/test_helper.mocks.dart';

void main() {
  late PickImageUseCase pickImageUseCase;
  late MockCameraImageRepository mockCameraImageRepository;

  setUp(() {
    mockCameraImageRepository = MockCameraImageRepository();
    pickImageUseCase = PickImageUseCase(mockCameraImageRepository);
  });

  test('should pick the image and return the path', () async {
    // Arrange
    const CameraImageEntity photoEntity =
        CameraImageEntity(path: 'path/to/photo.jpg');
    when(mockCameraImageRepository.pickImage())
        .thenAnswer((_) async => const Right(photoEntity));

    // Act
    final result = await pickImageUseCase();

    // Assert
    expect(result, const Right(photoEntity));
    verify(mockCameraImageRepository.pickImage());
    verifyNoMoreInteractions(mockCameraImageRepository);
  });

  test('should return failure when picking image fails', () async {
    // Arrange
    const failure = ImagePickerFailure(message: 'Failed to pick image');
    when(mockCameraImageRepository.pickImage())
        .thenAnswer((_) async => const Left(failure));

    // Act
    final result = await pickImageUseCase();

    // Assert
    expect(result, const Left(failure));
    verify(mockCameraImageRepository.pickImage());
    verifyNoMoreInteractions(mockCameraImageRepository);
  });
}

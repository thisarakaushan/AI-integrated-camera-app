import 'package:bloc/bloc.dart';
import 'package:valuefinder/features/domain/usecases/capture_photo.dart';
import 'package:valuefinder/features/domain/usecases/pick_image.dart';
import 'package:valuefinder/features/presentation/bloc/camera_event.dart';
import 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final CapturePhotoUseCase capturePhotoUseCase;
  final PickImageUseCase pickImageUseCase;

  CameraBloc({
    required this.capturePhotoUseCase,
    required this.pickImageUseCase,
  }) : super(CameraInitial()) {
    on<CapturePhotoEvent>((event, emit) async {
      emit(CameraLoading());
      final result = await capturePhotoUseCase.call();
      result.fold(
        (failure) => emit(CameraError(message: failure.message)),
        (cameraImage) => emit(CameraLoaded(imagePath: cameraImage.path)),
      );
    });

    on<PickImageEvent>((event, emit) async {
      emit(CameraLoading());
      final result = await pickImageUseCase.call();
      result.fold(
        (failure) => emit(CameraError(message: failure.message)),
        (cameraImage) => emit(CameraLoaded(imagePath: cameraImage.path)),
      );
    });
  }
}

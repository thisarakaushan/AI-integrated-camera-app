import 'package:bloc/bloc.dart';

import 'camera_event.dart';
import 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final CapturePhotoEvent capturePhoto;
  final PickImageEvent pickImage;

  CameraBloc({
    required this.capturePhoto,
    required this.pickImage,
  }) : super(CameraInitial()) {
    on<CapturePhotoEvent>((event, emit) async {
      emit(CameraLoading());
      try {
        final cameraImage = await capturePhoto.execute();
        emit(CameraLoaded(imagePath: cameraImage.path));
      } catch (e) {
        emit(CameraError(message: e.toString()));
      }
    });

    on<PickImageEvent>((event, emit) async {
      emit(CameraLoading());
      try {
        final cameraImage = await pickImage.execute();
        emit(CameraLoaded(imagePath: cameraImage.path));
      } catch (e) {
        emit(CameraError(message: e.toString()));
      }
    });
  }
}


// @injectable
// class CameraBloc extends Bloc<CameraEvent, CameraState> {
//   final CapturePhoto capturePhoto;

//   CameraBloc(this.capturePhoto) : super(CameraInitial());

//   @override
//   Stream<CameraState> mapEventToState(CameraEvent event) async* {
//     if (event is CapturePhotoEvent) {
//       yield CameraLoading();
//       final failureOrPhoto = await capturePhoto();
//       yield failureOrPhoto.fold(
//         (failure) => CameraError(message: failure.message),
//         (photo) => CameraLoaded(photo: photo),
//       );
//     }
//   }
// }
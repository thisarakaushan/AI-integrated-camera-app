import 'package:equatable/equatable.dart';

abstract class CameraEvent extends Equatable {
  const CameraEvent();

  @override
  List<Object> get props => [];
}

class CapturePhotoEvent extends CameraEvent {
  execute() {}
}

class PickImageEvent extends CameraEvent {
  execute() {}
}

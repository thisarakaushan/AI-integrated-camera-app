import 'package:equatable/equatable.dart';

abstract class CameraState extends Equatable {
  const CameraState();

  @override
  List<Object> get props => [];
}

class CameraInitial extends CameraState {}

class CameraLoading extends CameraState {}

class CameraLoaded extends CameraState {
  final String imagePath;

  const CameraLoaded({required this.imagePath});

  @override
  List<Object> get props => [imagePath];
}

class CameraError extends CameraState {
  final String message;

  const CameraError({required this.message});

  @override
  List<Object> get props => [message];
}

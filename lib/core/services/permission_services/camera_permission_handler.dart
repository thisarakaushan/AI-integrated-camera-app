import 'package:permission_handler/permission_handler.dart';
import 'package:valuefinder/core/error/failures.dart';

Future<Failure?> requestCameraPermission() async {
  final status = await Permission.camera.request();
  if (status.isDenied) {
    return CameraInitializationFailure(message: 'Camera permission denied.');
  } else if (status.isPermanentlyDenied) {
    await openAppSettings();
    return CameraInitializationFailure(
        message:
            'Camera permission permanently denied. Please enable it from settings.');
  }
  return null;
}

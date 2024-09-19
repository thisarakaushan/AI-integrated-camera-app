import 'package:permission_handler/permission_handler.dart';

Future<void> requestLocationPermission() async {
  PermissionStatus status = await Permission.location.request();
  if (status.isGranted) {
    // Permission granted, proceed with accessing location
    print('Location permission granted');
  } else if (status.isDenied) {
    // Permission denied
    print('Location permission denied');
  } else if (status.isPermanentlyDenied) {
    // Permissions permanently denied, take the user to app settings
    openAppSettings();
  }
}

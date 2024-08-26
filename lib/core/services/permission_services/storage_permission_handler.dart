import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:valuefinder/core/error/failures.dart';

Future<Failure?> requestStoragePermission() async {
  final deviceInfo = DeviceInfoPlugin();
  final androidInfo = await deviceInfo.androidInfo;
  final sdkInt = androidInfo.version.sdkInt;

  if (sdkInt >= 33) {
    // Android 13 (API level 33) or higher
    final photosPermission = await Permission.photos.request();
    if (photosPermission.isDenied) {
      return StoragePermissionFailure('Photos permission denied.');
    } else if (photosPermission.isPermanentlyDenied) {
      await openAppSettings();
      return StoragePermissionFailure(
          'Photos permission permanently denied. Please enable it from settings.');
    }
  } else if (sdkInt >= 30) {
    // Android 11 (API level 30) to Android 12L (API level 32)
    final status = await Permission.manageExternalStorage.request();
    if (status.isDenied) {
      return StoragePermissionFailure(
          'Manage External Storage permission denied.');
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
      return StoragePermissionFailure(
          'Manage External Storage permission permanently denied. Please enable it from settings.');
    }
  } else {
    // Below Android 11
    final status = await Permission.storage.request();
    if (status.isDenied) {
      return StoragePermissionFailure('Storage permission denied.');
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
      return StoragePermissionFailure(
          'Storage permission permanently denied. Please enable it from settings.');
    }
  }
  return null;
}

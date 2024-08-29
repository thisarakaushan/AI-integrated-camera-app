import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:valuefinder/core/error/failures.dart';

Future<Failure?> requestStoragePermission() async {
  final deviceInfo = DeviceInfoPlugin();
  final androidInfo = await deviceInfo.androidInfo;
  final sdkInt = androidInfo.version.sdkInt;

  if (sdkInt >= 33) {
    // Android 13 (API level 33) or higher
    final photoPermission = await Permission.photos.request();
    if (photoPermission.isDenied) {
      return StoragePermissionFailure(
          'Photo access permission denied for Android version 13.');
    } else if (photoPermission.isPermanentlyDenied) {
      await openAppSettings();
      return StoragePermissionFailure(
          'Photo access permission permanently denied for Android version 13. Please enable it from settings.');
    }
  } else if (sdkInt >= 30) {
    // Android 11 (API level 30) to Android 12L (API level 32)
    final manageStoragePermission =
        await Permission.manageExternalStorage.request();
    if (manageStoragePermission.isDenied) {
      return StoragePermissionFailure(
          'Manage External Storage permission denied.');
    } else if (manageStoragePermission.isPermanentlyDenied) {
      await openAppSettings();
      return StoragePermissionFailure(
          'Manage External Storage permission permanently denied. Please enable it from settings.');
    }
  } else {
    // Below Android 11
    final storagePermission = await Permission.storage.request();
    if (storagePermission.isDenied) {
      return StoragePermissionFailure(
          'Storage permission denied for Android version 11 and below.');
    } else if (storagePermission.isPermanentlyDenied) {
      await openAppSettings();
      return StoragePermissionFailure(
          'Storage permission permanently denied for Android version 11 and below. Please enable it from settings.');
    }
  }
  return null;
}


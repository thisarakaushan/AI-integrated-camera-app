import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:valuefinder/features/data/datasources/camera_datasource.dart';
import 'package:valuefinder/features/data/datasources/camera_datasource_impl.dart';
import 'package:valuefinder/features/data/repositories/camera_image_repository_impl.dart';
import 'package:valuefinder/features/domain/repositories/camera_image_repository.dart';
import 'package:valuefinder/features/domain/usecases/capture_photo.dart';
import 'package:valuefinder/features/domain/usecases/pick_image.dart';
import 'package:valuefinder/features/presentation/bloc/camera_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // External
  sl.registerLazySingleton(() => ImagePicker());

  final cameras = await availableCameras();
  sl.registerLazySingleton(
      () => CameraController(cameras.first, ResolutionPreset.high));

  // Register Data Sources
  sl.registerLazySingleton<CameraDataSource>(
      () => CameraDataSourceImpl(sl(), sl()));

  // Register Repositories
  sl.registerLazySingleton<CameraImageRepository>(
      () => CameraImageRepositoryImpl(sl()));

  // Register Use Cases
  sl.registerLazySingleton(() => CapturePhotoUseCase(sl()));
  sl.registerLazySingleton(() => PickImageUseCase(sl()));

  // Register Blocs
  sl.registerFactory(() => CameraBloc(
        capturePhotoUseCase: sl(),
        pickImageUseCase: sl(),
      ));
}

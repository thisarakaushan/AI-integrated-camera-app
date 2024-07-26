import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:valuefinder/config/di/injection_container.dart';
import 'package:valuefinder/config/routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  final cameras = await availableCameras();
  runApp(MainApp(cameras: cameras));
}

class MainApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const MainApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splashPage,
      onGenerateRoute: (settings) => AppRoutes.generateRoute(settings, cameras),
    );
  }
}

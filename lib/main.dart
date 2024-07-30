import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valuefinder/config/di/injection_container.dart';
import 'package:valuefinder/config/routes/app_routes.dart';
import 'package:valuefinder/features/presentation/bloc/camera_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();

  await Firebase.initializeApp();
  final cameras = await availableCameras();
  runApp(MainApp(cameras: cameras));
}

class MainApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const MainApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<CameraBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splashPage,
        onGenerateRoute: (settings) {
          // Pass cameras as part of the route arguments
          final arguments = settings.name == AppRoutes.splashPage ||
                  settings.name == AppRoutes.mainPage
              ? {'cameras': cameras}
              : settings.arguments;
          return AppRoutes.generateRoute(
            RouteSettings(
              name: settings.name,
              arguments: arguments,
            ),
          );
        },
      ),
    );
  }
}

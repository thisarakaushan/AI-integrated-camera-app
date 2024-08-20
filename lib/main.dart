import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valuefinder/config/di/injection_container.dart';
import 'package:valuefinder/config/routes/app_routes.dart';
import 'package:valuefinder/features/presentation/bloc/camera_bloc.dart';
import 'package:valuefinder/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();

  try {
    // if (Platform.isAndroid) {
    //   await Firebase.initializeApp(
    //     options: const FirebaseOptions(
    //       apiKey: 'AIzaSyAm9ZteqRe39bf8uM2vU9y6P0e-yXdWWWU',
    //       appId: '1:1002412293801:android:ed8759d7a063613652b3b8',
    //       messagingSenderId: '1002412293801',
    //       projectId: 'excelly-startup',
    //     ),
    //   );
    // } else {
    //   await Firebase.initializeApp();
    // }
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Failed to initialize Firebase: $e');
  }

  // Initialize Firebase Analytics
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  // anonymous login
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user = auth.currentUser;

  if (user == null) {
    // If not logged in, sign in anonymously
    try {
      UserCredential userCredential = await auth.signInAnonymously();
      user = userCredential.user;
    } catch (e) {
      print('Failed to sign in anonymously: $e');
    }
  }

  final cameras = await availableCameras();
  runApp(MainApp(cameras: cameras, analytics: analytics));
}

class MainApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  final FirebaseAnalytics analytics;
  const MainApp({
    super.key,
    required this.cameras,
    required this.analytics,
  });

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
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
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

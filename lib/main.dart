import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart'; // Import provider package
import 'package:valuefinder/config/di/injection_container.dart';
import 'package:valuefinder/config/routes/app_routes.dart';
import 'package:valuefinder/features/presentation/bloc/camera_bloc.dart';
import 'package:valuefinder/firebase_options.dart';
import 'core/providers/processing_page_state.dart';
import 'core/providers/recognition_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Failed to initialize Firebase: $e');
  }

  // Initialize Firebase Analytics
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  // Anonymous login
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
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProcessingPageState(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              RecognitionState(), // Add RecognitionState provider
        ),
        BlocProvider(
          create: (_) => sl<CameraBloc>(),
        ),
      ],
      child: MainApp(cameras: cameras, analytics: analytics),
    ),
  );
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
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Use your design's dimensions here
      builder: (context, child) {
        return MaterialApp(
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
        );
      },
    );
  }
}


// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:valuefinder/config/di/injection_container.dart';
// import 'package:valuefinder/config/routes/app_routes.dart';
// import 'package:valuefinder/features/presentation/bloc/camera_bloc.dart';
// import 'package:valuefinder/firebase_options.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await initializeDependencies();

//   try {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.currentPlatform,
//     );
//   } catch (e) {
//     print('Failed to initialize Firebase: $e');
//   }

//   // Initialize Firebase Analytics
//   final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

//   // anonymous login
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   User? user = auth.currentUser;

//   if (user == null) {
//     // If not logged in, sign in anonymously
//     try {
//       UserCredential userCredential = await auth.signInAnonymously();
//       user = userCredential.user;
//     } catch (e) {
//       print('Failed to sign in anonymously: $e');
//     }
//   }

//   final cameras = await availableCameras();
//   runApp(MainApp(cameras: cameras, analytics: analytics));
// }

// class MainApp extends StatelessWidget {
//   final List<CameraDescription> cameras;
//   final FirebaseAnalytics analytics;

//   const MainApp({
//     super.key,
//     required this.cameras,
//     required this.analytics,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(375, 812), // Use your design's dimensions here
//       builder: (context, child) {
//         return MultiBlocProvider(
//           providers: [
//             BlocProvider(
//               create: (_) => sl<CameraBloc>(),
//             ),
//           ],
//           child: MaterialApp(
//             debugShowCheckedModeBanner: false,
//             navigatorObservers: [
//               FirebaseAnalyticsObserver(analytics: analytics),
//             ],
//             initialRoute: AppRoutes.splashPage,
//             onGenerateRoute: (settings) {
//               // Pass cameras as part of the route arguments
//               final arguments = settings.name == AppRoutes.splashPage ||
//                       settings.name == AppRoutes.mainPage
//                   ? {'cameras': cameras}
//                   : settings.arguments;
//               return AppRoutes.generateRoute(
//                 RouteSettings(
//                   name: settings.name,
//                   arguments: arguments,
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }

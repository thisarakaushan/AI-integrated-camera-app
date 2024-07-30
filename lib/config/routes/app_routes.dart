import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:valuefinder/features/presentation/pages/image_info_page.dart';
import 'package:valuefinder/features/presentation/pages/image_recognition_page.dart';
import 'package:valuefinder/features/presentation/pages/main_page.dart';
import 'package:valuefinder/features/presentation/pages/splash_page.dart';
import 'package:valuefinder/features/presentation/pages/photo_capture_page.dart';
import 'package:valuefinder/features/presentation/pages/image_processing_page.dart';

class AppRoutes {
  static const String splashPage = '/';
  static const String mainPage = '/main-page';
  static const String photoCapturePage = '/photo-capture-page';
  static const String imageProcessingPage = '/image-processing-page';
  static const String imageRecognitionPage = '/image-recognition-page';
  static const String imageInfoPage = '/image-info-page'; // shoe info

  static Route<dynamic> generateRoute(RouteSettings settings) {
    print(
        'Navigating to ${settings.name} with arguments: ${settings.arguments}');
    final args = settings.arguments as Map<String, dynamic>?;
    print('Received arguments for ${settings.name}: $args');

    switch (settings.name) {
      case splashPage:
        final cameras = args?['cameras'] as List<CameraDescription>? ?? [];
        return MaterialPageRoute(
          builder: (_) => SplashPage(cameras: cameras),
        );
      case mainPage:
        final cameras = args?['cameras'] as List<CameraDescription>? ?? [];
        return MaterialPageRoute(
          builder: (_) => MainPage(cameras: cameras),
        );
      case photoCapturePage:
        print('getting routes in photo capture page');
        // No arguments expected for this route
        return MaterialPageRoute(
          builder: (_) => PhotoCapturePage(),
        );
      case imageProcessingPage:
        print('getting routes in image processing page');
        if (args != null && args.containsKey('imagePath')) {
          final imagePath = args['imagePath'] as String;
          return MaterialPageRoute(
            builder: (_) => ImageProcessingPage(imagePath: imagePath),
          );
        }
        return _errorRoute(
            'Missing or invalid arguments for ImageProcessingPage');
      case imageRecognitionPage:
        if (args != null &&
            args.containsKey('imagePath') &&
            args.containsKey('identifiedObject')) {
          final imagePath = args['imagePath'] as String;
          final identifiedObject = args['identifiedObject'] as String;
          return MaterialPageRoute(
            builder: (_) => ImageRecognitionPage(
              imagePath: imagePath,
              identifiedObject: identifiedObject,
            ),
          );
        }
        return _errorRoute(
            'Missing or invalid arguments for ImageRecognitionPage');
      case imageInfoPage:
        if (args != null &&
            args.containsKey('imageInfoPath') &&
            args.containsKey('description') &&
            args.containsKey('platforms')) {
          final imageInfoPath = args['imageInfoPath'] as String;
          final description = args['description'] as String;
          final platforms = args['platforms'] as List<Map<String, String>>;
          return MaterialPageRoute(
            builder: (_) => ImageInfoPage(
              imageInfoPath: imageInfoPath,
              description: description,
              platforms: platforms,
            ),
          );
        }
        return _errorRoute('Missing or invalid arguments for ImageInfoPage');
      default:
        return _errorRoute('No route defined for ${settings.name}');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(child: Text(message)),
      ),
    );
  }
}

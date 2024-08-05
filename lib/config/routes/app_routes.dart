import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:valuefinder/features/data/models/product.dart';
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
        if (args != null && args.containsKey('imageUrl')) {
          final imageUrl = args['imageUrl'] as String;
          return MaterialPageRoute(
            builder: (_) => ImageProcessingPage(imageUrl: imageUrl),
          );
        }
        return _errorRoute(
            'Missing or invalid arguments for ImageProcessingPage');
      // In AppRoutes
      case imageRecognitionPage:
        if (args != null &&
            args.containsKey('imageUrl') &&
            args.containsKey('identifiedObject')) {
          final imageUrl = args['imageUrl'] as String;
          final identifiedObject = args['identifiedObject'] as String;
          return MaterialPageRoute(
            builder: (_) => ImageRecognitionPage(
              imageUrl: imageUrl,
              identifiedObject: identifiedObject,
            ),
          );
        }
        return _errorRoute(
            'Missing or invalid arguments for ImageRecognitionPage');
      case imageInfoPage:
        if (args != null &&
            args.containsKey('imageUrl') &&
            args.containsKey('description')) {
          final imageUrl = args['imageUrl'] as String;
          final description = args['description'] as String;
          return MaterialPageRoute(
            builder: (_) => ImageInfoPage(
              imageUrl: imageUrl,
              description: description,
              platforms: const [],
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

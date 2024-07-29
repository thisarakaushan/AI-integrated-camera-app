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

  static Route<dynamic> generateRoute(
      RouteSettings settings, List<CameraDescription> cameras) {
    switch (settings.name) {
      case splashPage:
        return MaterialPageRoute(
            builder: (_) => SplashPage(
                  cameras: cameras,
                ));
      case mainPage:
        return MaterialPageRoute(
            builder: (_) => MainPage(
                  cameras: cameras,
                ));
      case photoCapturePage:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => PhotoCapturePage(
                  imagePath: args['imagePath'] as String,
                ));
      case imageProcessingPage:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => ImageProcessingPage(
                  imagePath: args['imagePath'] as String,
                ));
      case imageRecognitionPage:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ImageRecognitionPage(
            imagePath: args['imagePath'] as String,
            identifiedObject: args['identifiedObject'] as String,
          ),
        );
      case imageInfoPage: // Add the route for the new page
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => ImageInfoPage(
                  imageInfoPath: args['imageInfoPath'] as String,
                  description: args['description'] as String,
                ));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}

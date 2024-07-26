import 'package:flutter/material.dart';
import 'package:valuefinder/features/presentation/pages/main_page.dart';
import 'package:valuefinder/features/presentation/pages/splash_page.dart';
import 'package:camera/camera.dart';

class AppRoutes {
  static const String splashPage = '/';
  static const String mainPage = '/main-page';

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
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}

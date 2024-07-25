import 'package:flutter/material.dart';
import 'package:valuefinder/features/presentation/pages/main_page.dart';
import 'package:valuefinder/features/presentation/pages/splash_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String main = '/main';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
            builder: (_) => const SplashPage(
                  cameras: [],
                ));
      case main:
        return MaterialPageRoute(
            builder: (_) => const MainPage(
                  cameras: [],
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

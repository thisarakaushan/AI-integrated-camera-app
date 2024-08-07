import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:valuefinder/features/data/models/product.dart';
import 'package:valuefinder/features/presentation/pages/image_info_page.dart';
import 'package:valuefinder/features/presentation/pages/image_recognition_page.dart';
import 'package:valuefinder/features/presentation/pages/main_page.dart';
import 'package:valuefinder/features/presentation/pages/recent_searches_page.dart';
import 'package:valuefinder/features/presentation/pages/splash_page.dart';
import 'package:valuefinder/features/presentation/pages/photo_capture_page.dart';
import 'package:valuefinder/features/presentation/pages/image_processing_page.dart';
import 'package:valuefinder/features/presentation/widgets/final_details_page.dart';

class AppRoutes {
  static const String splashPage = '/';
  static const String mainPage = '/main-page';
  static const String recentSearchesPage = '/recentSearches';
  static const String photoCapturePage = '/photo-capture-page';
  static const String imageProcessingPage = '/image-processing-page';
  static const String imageRecognitionPage = '/image-recognition-page';
  static const String imageInfoPage = '/image-info-page';
  static const String detailsPage = '/details-page';

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
      case imageRecognitionPage:
        if (args != null &&
            args.containsKey('imageUrl') &&
            args.containsKey('identifiedObject') &&
            args.containsKey('products')) {
          final imageUrl = args['imageUrl'] as String;
          final identifiedObject = args['identifiedObject'] as String;
          final productsJson = args['products'] as List<dynamic>;

          // Ensure each item in productsJson is a Map<String, dynamic>
          final products = productsJson
              .map((json) => Product.fromJson(json as Map<String, dynamic>))
              .toList();

          return MaterialPageRoute(
            builder: (_) => ImageRecognitionPage(
              imageUrl: imageUrl,
              identifiedObject: identifiedObject,
              products: products,
            ),
          );
        }
        return _errorRoute(
            'Missing or invalid arguments for ImageRecognitionPage');
      case imageInfoPage:
        if (args != null &&
            args.containsKey('imageUrl') &&
            args.containsKey('description') &&
            args.containsKey('products')) {
          final imageUrl = args['imageUrl'] as String;
          final description = args['description'] as String;
          final productsJson = args['products'] as List<dynamic>;

          print('Navigating to ImageInfoPage with productsJson: $productsJson');

          final products = productsJson
              .map((json) {
                try {
                  return Product.fromJson(json as Map<String, dynamic>);
                } catch (e) {
                  print('Error parsing product: $json, Error: $e');
                  return null;
                }
              })
              .where((product) => product != null)
              .cast<Product>()
              .toList();

          return MaterialPageRoute(
            builder: (_) => ImageInfoPage(
              imageUrl: imageUrl,
              description: description,
              products: products,
            ),
          );
        }
        return _errorRoute('Missing or invalid arguments for ImageInfoPage');
      case detailsPage:
        if (args != null && args.containsKey('product')) {
          final productJson = args['product'] as Map<String, dynamic>;

          try {
            final product = Product.fromJson(productJson);
            return MaterialPageRoute(
              builder: (_) => DetailsPage(product: product),
            );
          } catch (e) {
            print(
                'Error parsing product for DetailsPage: $productJson, Error: $e');
            return _errorRoute('Invalid product data for DetailsPage');
          }
        }
        return _errorRoute('Missing or invalid arguments for DetailsPage');
      case recentSearchesPage:
        // No arguments expected for this route
        return MaterialPageRoute(
          builder: (_) => RecentSearchesPage(),
        );
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

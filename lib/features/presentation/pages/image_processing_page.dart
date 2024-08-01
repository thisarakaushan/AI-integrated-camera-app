import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:valuefinder/core/services/product_service.dart';
import 'package:valuefinder/features/presentation/widgets/animated_image_widget.dart';
import 'package:valuefinder/features/presentation/widgets/image_processing_page_text_widget.dart';
import 'package:valuefinder/features/presentation/widgets/top_row_widget.dart';
import 'package:valuefinder/config/routes/app_routes.dart';

class ImageProcessingPage extends StatefulWidget {
  final String imagePath;

  const ImageProcessingPage({super.key, required this.imagePath});

  @override
  _ImageProcessingPageState createState() => _ImageProcessingPageState();
}

class _ImageProcessingPageState extends State<ImageProcessingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    // Simulate some processing and then navigate
    _processImage();
    Future.delayed(const Duration(seconds: 3), _navigateToImageRecognitionPage);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // final response = await http.post(
  //       Uri.parse('https://shopping-s4r2ozb5wq-uc.a.run.app'),
  //           body: jsonEncode({
  //             'image':
  //                 base64Encode(await File(widget.imagePath).readAsBytes()),
  //           }),
  //           headers: {
  //         'Content-Type': 'application/json',
  //       }

  // Image processing method

  // Future<void> _processImage() async {
  //   try {
  //     final imageBytes = await File(widget.imagePath).readAsBytes();
  //     final encodedImage = base64Encode(imageBytes);

  //     // Send image to backend for processing
  //     final response = await http.post(
  //       Uri.parse('https://shopping-s4r2ozb5wq-uc.a.run.app'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({'image': encodedImage}),
  //     );

  //     if (response.statusCode == 200) {
  //       final result = jsonDecode(response.body);
  //       final String identifiedObject = result['object']; // e.g., "Adidas shoe"

  //       // Print debug information
  //       print(
  //           'Navigating to ${AppRoutes.imageRecognitionPage} with arguments: {imagePath: ${widget.imagePath}, identifiedObject: ${identifiedObject}}');

  //       // Fetch products related to the identified object
  //       final ProductResponse = await fetchProducts(identifiedObject);
  //       final products = ProductResponse.products ?? [];

  //       // print debug info
  //       print('Identified object: $identifiedObject');
  //       print('Products: $products');

  //       // Navigate to the ImageRecognitionPage with the identified object
  //       if (mounted) {
  //         Navigator.pushNamed(
  //           context,
  //           AppRoutes.imageRecognitionPage,
  //           arguments: {
  //             'imagePath': widget.imagePath,
  //             'identifiedObject': identifiedObject,
  //             'products': products,
  //           },
  //         );
  //       }
  //     } else {
  //       throw Exception('Failed to process image');
  //     }
  //   } catch (e) {
  //     // Handle any errors here
  //     print('Error processing image: $e');
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to process image: $e')),
  //       );
  //     }
  //   }
  // }

  Future<void> _processImage() async {
    try {
      final response = await http.post(
        Uri.parse('https://shopping-s4r2ozb5wq-uc.a.run.app'),
        headers: {
          'Content-Type': 'application/json', // Adjust if needed
        },
        body: jsonEncode({
          'image': base64Encode(await File(widget.imagePath).readAsBytes()),
        }),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final String identifiedObject = result['object']; // e.g., "Adidas shoe"

        if (mounted) {
          Navigator.pushNamed(
            context,
            AppRoutes.imageRecognitionPage,
            arguments: {
              'imagePath': widget.imagePath,
              'identifiedObject': identifiedObject,
            },
          );
        }
      } else {
        throw Exception(
            'Failed to process image with status code: ${response.statusCode}');
      }
    } catch (e) {
      // Print the detailed error message
      print('Error processing image: $e');
      // Optionally, display an error message to the user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to process image: $e')),
        );
      }
    }
  }

  void _navigateToImageRecognitionPage() {
    Navigator.pushNamed(
      context,
      AppRoutes.imageRecognitionPage,
      arguments: {
        'imagePath': widget.imagePath,
        'identifiedObject':
            'Default Object Name', // temporarily set to a default for testing
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            TopRowWidget(onMenuPressed: () {}, onEditPressed: () {}), // top row
            const Spacer(),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  File(widget.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            AnimatedImageWidget(
              controller: _controller,
              imagePath: 'assets/main_image.png',
              height: 131,
              width: 131,
            ),
            const SizedBox(height: 20),
            const ImageProcessingPageTextWidget(), // use the image processing page text widget
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

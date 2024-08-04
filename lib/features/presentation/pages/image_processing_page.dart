import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:valuefinder/core/error/failures.dart';
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

    _processImage();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _processImage() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;

      if (user == null) {
        throw PhotoCaptureFailure(message: 'No user is currently signed in.');
      }

      String? token = await user.getIdToken();
      if (token == null) {
        throw PhotoCaptureFailure(
            message: 'Failed to retrieve Firebase ID token.');
      }

      final response = await http.get(
        Uri.parse('https://shopping-s4r2ozb5wq-uc.a.run.app'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('API Response: ${response.body}'); // Debugging line

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        print('Parsed Result: $result'); // Debugging line

        final String identifiedObject =
            result['object'] ?? 'Default Object Name';
        print('Object identified: $identifiedObject'); // Debugging line

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
      } else if (response.statusCode == 400) {
        final result = jsonDecode(response.body);
        if (result['error'] == 'object not clear') {
          throw ServerFailure(
              'The object in the image is not clear. Please provide more images.');
        } else {
          throw ServerFailure('Failed to process image: ${result['error']}');
        }
      } else {
        throw ServerFailure(
            'Failed to process image with status code: ${response.statusCode}. Response body: ${response.body}');
      }
    } catch (e) {
      if (e is Failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message)),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to process image: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            TopRowWidget(onMenuPressed: () {}, onEditPressed: () {}),
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
            const ImageProcessingPageTextWidget(),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

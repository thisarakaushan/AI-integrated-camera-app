import 'dart:async';
import 'package:flutter/material.dart';
import 'package:valuefinder/config/routes/app_routes.dart';
import 'package:valuefinder/features/data/models/product.dart';
import 'package:valuefinder/features/presentation/widgets/main_page_widgets/animated_image_widget.dart';
import 'package:valuefinder/features/presentation/widgets/common_widgets/processing_recognition_page_text_widget.dart';
import 'package:valuefinder/features/presentation/widgets/common_widgets/top_row_widget.dart';
import 'package:valuefinder/features/presentation/widgets/photo_capture_page_widgets/capture_camera_lens_widget.dart';

class ImageRecognitionPage extends StatefulWidget {
  final String imageUrl;
  final String identifiedObject;
  final List<Product> products;

  const ImageRecognitionPage({
    super.key,
    required this.imageUrl,
    required this.identifiedObject,
    required this.products,
  });

  @override
  _ImageRecognitionPageState createState() => _ImageRecognitionPageState();
}

class _ImageRecognitionPageState extends State<ImageRecognitionPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    // Set up the timer to navigate after 4 seconds
    _timer = Timer(const Duration(seconds: 4), _navigateToImageInfoPage);
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _navigateToImageInfoPage() {
    if (widget.identifiedObject.isNotEmpty) {
      Navigator.pushNamed(
        context,
        AppRoutes.imageInfoPage,
        arguments: {
          'imageUrl': widget.imageUrl,
          'description': widget.identifiedObject,
          'products':
              widget.products.map((product) => product.toJson()).toList(),
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Identified object is not available.')),
      );
    }
  }

  void _navigateToMainPage() {
    Navigator.pushReplacementNamed(context, AppRoutes.mainPage);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final lensSize =
            constraints.maxWidth * 0.8; // Adjusted size for responsiveness
        final borderRadius = lensSize * 0.1;
        final textSize = constraints.maxWidth * 0.05; // 5% of screen width

        return Scaffold(
          backgroundColor: const Color(0xFF051338),
          body: SafeArea(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 5),
                TopRowWidget(onCameraPressed: _navigateToMainPage),
                const SizedBox(height: 5),
                Container(
                  width: lensSize,
                  height: lensSize,
                  decoration: BoxDecoration(
                    // border: Border.all(color: Colors.white, width: 2),
                    // borderRadius: BorderRadius.circular(borderRadius),
                    border: Border.all(color: Colors.transparent),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: LensBorderPainter(
                            focusRect: Rect.fromLTWH(
                              0,
                              0,
                              lensSize,
                              lensSize,
                            ),
                          ),
                        ),
                      ),
                      ClipRRect(
                        //borderRadius: BorderRadius.circular(borderRadius),
                        child: Image.network(
                          widget.imageUrl,
                          fit: BoxFit.cover,
                          width: lensSize,
                          height: lensSize,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                'Image not available',
                                style: TextStyle(
                                    color: Colors.white, fontSize: textSize),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.identifiedObject.isNotEmpty
                      ? widget.identifiedObject
                      : 'Object not identified',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: textSize,
                  ),
                ),
                const SizedBox(height: 5),
                AnimatedImageWidget(
                  controller: _controller,
                  imagePath: 'assets/page_images/main_image.png',
                  height: constraints.maxWidth * 0.6,
                  width: constraints.maxWidth * 0.6,
                ),
                const SizedBox(height: 5),
                const ProcessingAndRecognitionPageTextWidget(),
                const SizedBox(height: 50),
              ],
            ),
          ),
        );
      },
    );
  }
}

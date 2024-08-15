import 'dart:async';
import 'package:flutter/material.dart';
import 'package:valuefinder/config/routes/app_routes.dart';
import 'package:valuefinder/config/routes/slide_transition_route.dart';
import 'package:valuefinder/features/data/models/product.dart';
import 'package:valuefinder/features/presentation/pages/recent_searches_page.dart';
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
  bool _isRecentSearchesPageOpen = false; // Track if RecentSearchesPage is open

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    // Set up the timer to navigate after 4 seconds, but check the flag first
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!_isRecentSearchesPageOpen) {
        _navigateToImageInfoPage();
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _navigateToImageInfoPage() {
    if (_isRecentSearchesPageOpen) {
      return; // Avoid navigation if RecentSearchesPage is open
    }

    if (!_isRecentSearchesPageOpen) {
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
  }

  void _navigateToRecentSearchesPage() {
    setState(() {
      _isRecentSearchesPageOpen = true; // Set flag to true
    });

    Navigator.push(
      context,
      SlideTransitionRoute(page: const RecentSearchesPage()),
    ).then((_) {
      // Reset flag after Recent Searches Page is closed
      setState(() {
        _isRecentSearchesPageOpen = false;
      });
    });
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TopRowWidget(
                    onMenuPressed: _navigateToRecentSearchesPage,
                    onEditPressed: _navigateToMainPage),
                const SizedBox(height: 10),
                Container(
                  width: lensSize,
                  height: lensSize,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(borderRadius),
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
                        borderRadius: BorderRadius.circular(borderRadius),
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
                  imagePath: 'assets/main_image.png',
                  height: constraints.maxWidth * 0.6,
                  width: constraints.maxWidth * 0.6,
                ),
                const SizedBox(height: 5),
                const ProcessingAndRecognitionPageTextWidget(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}

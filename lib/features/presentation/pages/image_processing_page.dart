import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:valuefinder/config/routes/slide_transition_route.dart';
import 'package:valuefinder/core/services/image_process_service.dart';
import 'package:valuefinder/features/presentation/pages/recent_searches_page.dart';
import 'package:valuefinder/features/presentation/widgets/main_page_widgets/animated_image_widget.dart';
import 'package:valuefinder/features/presentation/widgets/common_widgets/processing_recognition_page_text_widget.dart';
import 'package:valuefinder/features/presentation/widgets/common_widgets/top_row_widget.dart';
import 'package:valuefinder/config/routes/app_routes.dart';
import 'package:valuefinder/features/presentation/widgets/photo_capture_page_widgets/capture_camera_lens_widget.dart';

class ImageProcessingPage extends StatefulWidget {
  final String imageUrl;
  final Rect? focusRect; // Added to specify the focused object area

  const ImageProcessingPage(
      {super.key, required this.imageUrl, this.focusRect});

  @override
  _ImageProcessingPageState createState() => _ImageProcessingPageState();
}

class _ImageProcessingPageState extends State<ImageProcessingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isRecentSearchesPageOpen = false; // Track if RecentSearchesPage is open

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    // Process the image but handle interruptions from RecentSearchesPage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _processImage();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _processImage() {
    final service = ImageProcessingService(
      imageUrl: widget.imageUrl,
      auth: FirebaseAuth.instance,
    );

    service.processImage(
      (keyword, products) {
        if (!_isRecentSearchesPageOpen) {
          if (mounted) {
            Navigator.pushNamed(
              context,
              AppRoutes.imageRecognitionPage,
              arguments: {
                'imageUrl': widget.imageUrl,
                'identifiedObject': keyword,
                'products':
                    products.map((product) => product.toJson()).toList(),
              },
            );
          }
        }
      },
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.message)),
          );
        }
      },
    );
  }

  void _navigateToRecentSearchesPage() {
    setState(() {
      _isRecentSearchesPageOpen = true; // Set flag to true
    });

    Navigator.push(
      context,
      SlideTransitionRoute(page: const RecentSearchesPage()),
    ).then((_) {
      // Reset flag to false after Recent Searches Page is closed
      setState(() {
        _isRecentSearchesPageOpen = false;
      });

      // restart image processing here if needed
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _processImage();
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
        final lensSize = constraints.maxWidth * 0.88;
        final borderRadius = lensSize * 0.1;

        return Scaffold(
          backgroundColor: const Color(0xFF051338),
          body: SafeArea(
            child: Column(
              children: [
                TopRowWidget(
                  onMenuPressed: _navigateToRecentSearchesPage,
                  onEditPressed: _navigateToMainPage,
                ),
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
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                      : null,
                                ),
                              );
                            }
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text('Failed to load image',
                                  style: TextStyle(color: Colors.red)),
                            );
                          },
                        ),
                      ),
                    ],
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

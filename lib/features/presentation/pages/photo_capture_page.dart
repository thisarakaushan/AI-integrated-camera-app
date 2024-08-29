import 'dart:async';

import 'package:flutter/material.dart';
import 'package:valuefinder/config/routes/app_routes.dart';
import 'package:valuefinder/core/error/failures.dart';
import 'package:valuefinder/features/presentation/widgets/main_page_widgets/animated_image_widget.dart';
import 'package:valuefinder/features/presentation/widgets/photo_capture_page_widgets/capture_camera_lens_widget.dart';
import 'package:valuefinder/features/presentation/widgets/photo_capture_page_widgets/photo_capture_page_text_widget.dart';
import 'package:valuefinder/features/presentation/widgets/common_widgets/top_row_widget.dart';

class PhotoCapturePage extends StatefulWidget {
  final String? imageUrl;
  final Rect? focusRect;

  const PhotoCapturePage({super.key, this.imageUrl, this.focusRect});

  @override
  _PhotoCapturePageState createState() => _PhotoCapturePageState();
}

class _PhotoCapturePageState extends State<PhotoCapturePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool imageLoaded = false;
  double? imageAspectRatio;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    if (widget.imageUrl != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadImageAspectRatio(widget.imageUrl!);
      });
    }
  }

  Future<void> _loadImageAspectRatio(String imageUrl) async {
    final image = NetworkImage(imageUrl);
    final completer = Completer<void>();
    image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((info, _) {
        setState(() {
          imageAspectRatio = info.image.width / info.image.height;
          imageLoaded = true;
        });
        completer.complete();
        _attemptNavigationToProcessingPage();
      }),
    );
    await completer.future;
  }

  void _attemptNavigationToProcessingPage() {
    if (imageLoaded) {
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          _navigateToProcessingPage(widget.imageUrl!);
        }
      });
    }
  }

  Future<void> _navigateToProcessingPage(String imageUrl) async {
    if (imageUrl.isNotEmpty) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.imageProcessingPage,
        arguments: {'imageUrl': imageUrl},
      );
    } else {
      throw const ImageNavigationFailure('No valid image URL provided.');
    }
  }

  void _navigateToMainPage() {
    Navigator.pushReplacementNamed(context, AppRoutes.mainPage);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final lensWidth = constraints.maxWidth * 0.8;
        final lensHeight = imageAspectRatio != null
            ? lensWidth / imageAspectRatio!
            : lensWidth;

        final borderRadius = lensWidth * 0.1;
        final fixedLensTopSpacing = 10.0; // Space from the top row widget
        final lensContainerHeight = constraints.maxHeight -
            (fixedLensTopSpacing + 120); // Adjust space for other widgets

        // Calculate lens height based on aspect ratio to fit vertically
        final adjustedLensHeight = lensAspectRatioAdjustment(
          lensWidth,
          lensHeight,
          lensContainerHeight,
        );

        return Scaffold(
          backgroundColor: const Color(0xFF051338),
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(height: fixedLensTopSpacing),
                TopRowWidget(
                  onCameraPressed: _navigateToMainPage,
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Container(
                    width: lensWidth,
                    height: adjustedLensHeight,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Positioned.fill(
                          child: CustomPaint(
                            painter: LensBorderPainter(
                              focusRect: widget.focusRect ??
                                  Rect.fromLTWH(
                                      0, 0, lensWidth, adjustedLensHeight),
                            ),
                          ),
                        ),
                        widget.imageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child: Image.network(
                                  widget.imageUrl!,
                                  fit: BoxFit.cover,
                                  width: lensWidth,
                                  height: adjustedLensHeight,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
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
                              )
                            : const Center(
                                child: Text('No image available'),
                              ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                PhotoCapturePageTextWidget(),
                SizedBox(height: 10),
                AnimatedImageWidget(
                  controller: _controller,
                  imagePath: 'assets/page_images/main_image.png',
                  height: 60.0, // Fixed height
                  width: 60.0, // Fixed width
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  double lensAspectRatioAdjustment(
    double lensWidth,
    double lensHeight,
    double lensContainerHeight,
  ) {
    // Ensure the lens height does not exceed the available space
    final aspectRatio = lensWidth / lensHeight;
    if (lensHeight > lensContainerHeight) {
      return lensContainerHeight;
    } else if (lensHeight < lensContainerHeight &&
        lensWidth / lensHeight > aspectRatio) {
      return lensWidth / aspectRatio;
    }
    return lensHeight;
  }
}

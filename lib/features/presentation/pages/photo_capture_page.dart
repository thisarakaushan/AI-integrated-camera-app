import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valuefinder/config/routes/app_routes.dart';
import 'package:valuefinder/core/error/failures.dart';
import '../../../core/providers/processing_page_state.dart';
import '../../../core/utils/widget_constants.dart';
import '../widgets/common_widgets/animated_image_widget.dart';
import '../widgets/common_widgets/lens_widget.dart';
import '../widgets/photo_capture_page_widgets/photo_capture_page_text_widget.dart';
import '../widgets/common_widgets/top_row_widget.dart';

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
  Timer? _navigationTimer;

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

  @override
  void dispose() {
    _controller.dispose();
    // Cancel the timer if it's still running
    _navigationTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadImageAspectRatio(String imageUrl) async {
    final image = NetworkImage(imageUrl);
    final completer = Completer<void>();
    image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((info, _) {
        if (mounted) {
          setState(() {
            imageAspectRatio = info.image.width / info.image.height;
            imageLoaded = true;
          });
          completer.complete();
          _attemptNavigationToProcessingPage();
        }
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
      final processingState =
          Provider.of<ProcessingPageState>(context, listen: false);

      // Update both text content values
      processingState.updateText('Processing your image...',
          'We\'re finding the best information for you');

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
        final double animatedImageSize = WidgetsConstant.width * 25;

        return Scaffold(
          backgroundColor: const Color(0xFF051338),
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(height: WidgetsConstant.height * 3),
                TopRowWidget(
                  onCameraPressed: _navigateToMainPage,
                ),
                SizedBox(height: WidgetsConstant.height * 4),
                Expanded(
                  child: SizedBox(
                    width: lensWidth,
                    height: adjustedLensHeight,
                    child: Stack(
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20), 
                          child: Image.network(
                            widget.imageUrl ?? '',
                            fit: BoxFit.cover,
                            width: lensWidth,
                            height: adjustedLensHeight,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Stack(
                                  children: [
                                    child, // Display the image partially loaded
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.center,
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
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Text('Failed to load image',
                                    style: TextStyle(color: Colors.red)),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: WidgetsConstant.height * 15),
                PhotoCapturePageTextWidget(),
                SizedBox(height: WidgetsConstant.height * 10),
                AnimatedImageWidget(
                  controller: _controller,
                  imagePath: 'assets/page_images/main_image.png',
                  height: animatedImageSize,
                  width: animatedImageSize,
                ),
                SizedBox(height: WidgetsConstant.height * 5),
              ],
            ),
          ),
        );
      },
    );
  }
}

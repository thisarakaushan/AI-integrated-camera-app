import 'package:flutter/material.dart';
import 'package:valuefinder/config/routes/app_routes.dart';
import 'package:valuefinder/core/error/failures.dart';
import 'package:valuefinder/features/presentation/widgets/main_page_widgets/animated_image_widget.dart';
import 'package:valuefinder/features/presentation/widgets/photo_capture_page_widgets/capture_camera_lens_widget.dart';
import 'package:valuefinder/features/presentation/widgets/photo_capture_page_widgets/photo_capture_page_text_widget.dart';
import 'package:valuefinder/features/presentation/widgets/common_widgets/top_row_widget.dart';

class PhotoCapturePage extends StatefulWidget {
  final String? imageUrl; // accept the imageUrl parameter from main page
  final Rect? focusRect; // Added to specify the focused object area

  const PhotoCapturePage({super.key, this.imageUrl, this.focusRect});

  @override
  _PhotoCapturePageState createState() => _PhotoCapturePageState();
}

class _PhotoCapturePageState extends State<PhotoCapturePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool imageLoaded = false; // Flag to track if the image is displayed

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    if (widget.imageUrl != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          imageLoaded = true;
        });
        // Automatically navigate to the processing page after the image is loaded
        _attemptNavigationToProcessingPage();
      });
    }
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
        final lensSize = constraints.maxWidth * 0.8;
        final borderRadius = lensSize * 0.1;

        return Scaffold(
          backgroundColor: const Color(0xFF051338),
          body: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 5),
                TopRowWidget(
                  onCameraPressed: _navigateToMainPage,
                ),
                const SizedBox(height: 10),
                Container(
                  width: lensSize,
                  height: lensSize,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: LensBorderPainter(
                            focusRect: widget.focusRect ??
                                Rect.fromLTWH(0, 0, lensSize, lensSize),
                          ),
                        ),
                      ),
                      widget.imageUrl != null
                          ? ClipRect(
                              child: Image.network(
                                widget.imageUrl!,
                                fit: BoxFit.cover,
                                width: lensSize,
                                height: lensSize,
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
                const SizedBox(height: 200),
                PhotoCapturePageTextWidget(),
                const SizedBox(height: 20),
                AnimatedImageWidget(
                  controller: _controller,
                  imagePath: 'assets/page_images/main_image.png',
                  height: constraints.maxWidth * 0.2,
                  width: constraints.maxWidth * 0.2,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}

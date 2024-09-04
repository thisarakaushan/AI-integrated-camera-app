import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:valuefinder/core/services/image_process_service.dart';
import '../../../core/utils/widget_constants.dart';
import '../widgets/common_widgets/animated_image_widget.dart';
import '../widgets/common_widgets/processing_recognition_page_text_widget.dart';
import '../widgets/common_widgets/top_row_widget.dart';
import 'package:valuefinder/config/routes/app_routes.dart';
import '../widgets/common_widgets/lens_widget.dart';
// Import for Completer
import 'dart:async';

class ImageProcessingPage extends StatefulWidget {
  final String imageUrl;
  final Rect? focusRect;

  const ImageProcessingPage(
      {super.key, required this.imageUrl, this.focusRect});

  @override
  _ImageProcessingPageState createState() => _ImageProcessingPageState();
}

class _ImageProcessingPageState extends State<ImageProcessingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double? imageAspectRatio;
  bool imageLoaded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    _loadImageAspectRatio(widget.imageUrl).then((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _processImage();
      });
    });
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
      }),
    );
    await completer.future;
  }

  void _processImage() {
    final service = ImageProcessingService(
      imageUrl: widget.imageUrl,
      auth: FirebaseAuth.instance,
    );

    service.processImage(
      (keyword, products) {
        if (mounted) {
          Navigator.pushNamed(
            context,
            AppRoutes.imageRecognitionPage,
            arguments: {
              'imageUrl': widget.imageUrl,
              'identifiedObject': keyword,
              'products': products.map((product) => product.toJson()).toList(),
            },
          );
        }
      },
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.message)),
          );
        }
      },
      (message) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );

          Future.delayed(const Duration(seconds: 4), () {
            if (mounted) {
              _navigateToMainPage();
            }
          });
        }
      },
    );
  }

  void _navigateToMainPage() {
    Navigator.pushReplacementNamed(context, AppRoutes.mainPage);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double lensAspectRatioAdjustment(
      double lensWidth, double lensHeight, double lensContainerHeight) {
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
        final lensHeight = lensWidth / (imageAspectRatio ?? 1);
        final adjustedLensHeight = lensAspectRatioAdjustment(
            lensWidth, lensHeight, constraints.maxHeight * 0.6);

        final double animatedImageSize = WidgetsConstant.width * 20;

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
                SizedBox(
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
                      ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: Image.network(
                          widget.imageUrl,
                          fit: BoxFit.cover,
                          width: lensWidth,
                          height: adjustedLensHeight,
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
                Spacer(),
                ProcessingAndRecognitionPageTextWidget(),
                SizedBox(height: WidgetsConstant.height * 10),
                AnimatedImageWidget(
                  controller: _controller,
                  imagePath: 'assets/page_images/main_image.png',
                  height: animatedImageSize,
                  width: animatedImageSize,
                ),
                SizedBox(height: WidgetsConstant.height * 10),
              ],
            ),
          ),
        );
      },
    );
  }
}

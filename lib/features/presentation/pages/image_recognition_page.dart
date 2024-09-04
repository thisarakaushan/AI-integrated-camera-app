import 'dart:async';
import 'package:flutter/material.dart';
import 'package:valuefinder/config/routes/app_routes.dart';
import 'package:valuefinder/features/data/models/product.dart';
import '../../../core/utils/widget_constants.dart';
import '../widgets/common_widgets/animated_image_widget.dart';
import '../widgets/common_widgets/processing_recognition_page_text_widget.dart';
import '../widgets/common_widgets/top_row_widget.dart';
import '../widgets/common_widgets/lens_widget.dart';

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
  double? imageAspectRatio;
  bool imageLoaded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    // Load image aspect ratio
    _loadImageAspectRatio(widget.imageUrl).then((_) {
      // Set up the timer to navigate after 4 seconds
      _timer = Timer(const Duration(seconds: 4), _navigateToImageInfoPage);
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
  void dispose() {
    _controller.dispose();
    _timer.cancel();
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

        final double textSize = WidgetsConstant.textFieldHeight * 0.13;
        final double animatedImageSize = WidgetsConstant.width * 20;

        return Scaffold(
          backgroundColor: const Color(0xFF051338),
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(height: WidgetsConstant.height * 3),
                TopRowWidget(onCameraPressed: _navigateToMainPage),
                SizedBox(height: WidgetsConstant.height * 4),
                Container(
                  width: lensWidth,
                  height: adjustedLensHeight,
                  decoration: BoxDecoration(
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
                              lensWidth,
                              adjustedLensHeight,
                            ),
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
                SizedBox(height: WidgetsConstant.height * 5),
                Text(
                  widget.identifiedObject.isNotEmpty
                      ? widget.identifiedObject
                      : 'Object not identified',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: textSize,
                  ),
                ),
                Spacer(),
                const ProcessingAndRecognitionPageTextWidget(),
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

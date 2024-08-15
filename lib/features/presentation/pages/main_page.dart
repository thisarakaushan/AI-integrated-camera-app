import 'dart:io';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:valuefinder/config/routes/app_routes.dart';
import 'package:valuefinder/config/routes/slide_transition_route.dart';
import 'package:valuefinder/core/services/image_picker_service.dart';
import 'package:valuefinder/features/presentation/pages/recent_searches_page.dart';
import 'package:valuefinder/features/presentation/widgets/main_page_widgets/camera_lens_widget.dart';
import 'package:valuefinder/features/presentation/widgets/main_page_widgets/photo_capture_button_widget.dart';
import 'package:valuefinder/features/presentation/widgets/main_page_widgets/animated_image_widget.dart';
import 'package:valuefinder/features/presentation/widgets/main_page_widgets/gallery_button_widget.dart';
import 'package:valuefinder/features/presentation/widgets/main_page_widgets/main_page_text_widget.dart';

import 'package:valuefinder/features/presentation/widgets/common_widgets/top_row_widget.dart';

class MainPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const MainPage({super.key, required this.cameras});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  File? image; // Variable to store picked image
  Timer? _navigationTimer; // Timer for automatic navigation
  bool _isRecentSearchesPageOpen = false; // Track if RecentSearchesPage is open

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();

    // Set up a timer for automatic navigation
    _startNavigationTimer();
    // Initial navigation without picking an image
    // Set up a timer for automatic navigation
    // _navigationTimer = Timer(const Duration(seconds: 8), () {
    //   if (mounted && !_isRecentSearchesPageOpen) {
    //     // Navigate to PhotoCapturePage if gallery button wasn't clicked
    //     _navigateToPhotoCapturePage();
    //   }
    // });
  }

  void _startNavigationTimer() {
    _navigationTimer = Timer(const Duration(seconds: 8), () {
      if (mounted && !_isRecentSearchesPageOpen) {
        _navigateToPhotoCapturePage();
      }
    });
  }

  void _navigateToPhotoCapturePage({String? imageUrl}) {
    if (imageUrl != null) {
      Navigator.pushNamed(
        context,
        AppRoutes.photoCapturePage,
        arguments: {'imageUrl': imageUrl},
      );
    } else {
      Navigator.pushNamed(
        context,
        AppRoutes.photoCapturePage,
      );
    }
  }

  Future<void> _pickImageFromGallery() async {
    _navigationTimer?.cancel(); // Cancel the automatic navigation timer

    try {
      await pickImageFromGallery(
        context,
        (pickedImage) {
          if (pickedImage != null) {
            setState(() {
              image = pickedImage;
            });
          }
        },
        (imageUrl) {
          // Use Future.delayed to navigate after a short delay
          Future.delayed(const Duration(seconds: 2), () {
            if (imageUrl != null) {
              _navigateToPhotoCapturePage(imageUrl: imageUrl);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to get image URL')),
              );
              _navigateToPhotoCapturePage();
            }
          });
        },
      );
    } catch (e) {
      // handle specific error and show message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: ${e.toString()}')),
      );
      // Navigate to PhotoCapturePage after a short delay
      Future.delayed(const Duration(seconds: 2), () {
        _navigateToPhotoCapturePage();
      });
    }
  }

  void _navigateToRecentSearchesPage() {
    setState(() {
      _isRecentSearchesPageOpen = true;
    });

    Navigator.push(
      context,
      SlideTransitionRoute(
        page: RecentSearchesPage(
          onClose: () {
            setState(() {
              _isRecentSearchesPageOpen = false;
            });
            // Re-enable automatic navigation after closing the RecentSearchesPage
            _startNavigationTimer();
          },
        ),
      ),
    );
  }

  void _navigateToMainPage() {
    Navigator.pushReplacementNamed(context, AppRoutes.mainPage);
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose animation controller
    _navigationTimer?.cancel(); // Cancel the automatic navigation timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double lensSize = size.width * 0.8; // Adjusted size for square lens
    final double animatedImageSize = size.width * 0.6;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                TopRowWidget(
                  onMenuPressed: _navigateToRecentSearchesPage,
                  onEditPressed: _navigateToMainPage,
                ),
                const Spacer(),
                // camera lens
                Center(
                  child: CustomPaint(
                    size: Size(lensSize, lensSize),
                    painter: LensBorderPainter(),
                  ),
                ),
                const SizedBox(height: 5),
                AnimatedImageWidget(
                  controller: _controller,
                  imagePath: 'assets/main_image.png',
                  height: animatedImageSize,
                  width: animatedImageSize,
                ),
                const SizedBox(height: 5),
                const MainPageTextWidget(),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PhotoCaptureButtonWidget(
                      onCapturePressed: () {
                        // Handle photo capture button press
                        // Implement your photo capture logic here
                      },
                    ),
                    const SizedBox(width: 20), // Space between buttons
                    GalleryButtonWidget(
                      onGalleryPressed: _pickImageFromGallery,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

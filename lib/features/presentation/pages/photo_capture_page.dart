import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:valuefinder/config/routes/app_routes.dart';
import 'package:valuefinder/config/routes/slide_transition_route.dart';
import 'package:valuefinder/core/services/auth_service_anonymous.dart';
import 'package:valuefinder/core/services/capture_photo_service.dart';
import 'package:valuefinder/features/presentation/pages/recent_searches_page.dart';
import 'package:valuefinder/features/presentation/widgets/animated_image_widget.dart';
import 'package:valuefinder/features/presentation/widgets/photo_capture_page_text_widget.dart';
import 'package:valuefinder/features/presentation/widgets/top_row_widget.dart';

class PhotoCapturePage extends StatefulWidget {
  final String? imageUrl; // accept the imageUrl parameter from main page

  const PhotoCapturePage({
    super.key,
    this.imageUrl,
  });

  @override
  _PhotoCapturePageState createState() => _PhotoCapturePageState();
}

class _PhotoCapturePageState extends State<PhotoCapturePage>
    with SingleTickerProviderStateMixin {
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  late AnimationController _controller;
  Timer? _timer; // Timer? to avoid late initialization
  final AnonymousAuthService _authService = AnonymousAuthService();
  bool imageLoaded = false; // Flag to track if the image is displayed
  bool _isRecentSearchesPageOpen = false; // Track if RecentSearchesPage is open

  Future<void> _navigateToProcessingPage(String imageUrl) async {
    print(
        'Navigating to ${AppRoutes.imageProcessingPage} with imageUrl: $imageUrl');
    if (mounted) {
      // Ensure that the current state is appropriate before navigation
      if (imageUrl.isNotEmpty) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.imageProcessingPage,
          arguments: {'imageUrl': imageUrl},
        );
      } else {
        print('No valid image URL provided.');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    print('Received imageUrl: ${widget.imageUrl}');

    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    if (widget.imageUrl != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          imageLoaded = true;
        });
        // Handle recent searches scenario
        if (!_isRecentSearchesPageOpen) {
          Future.delayed(const Duration(seconds: 1), () {
            if (imageLoaded) {
              _navigateToProcessingPage(widget.imageUrl!);
            }
          });
        }
      });
    } else {
      _initializeCamera();
      _authenticateAndCapturePhoto();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      _cameraController = CameraController(
        cameras.first,
        ResolutionPreset.high,
      );
      _initializeControllerFuture = _cameraController!.initialize();
      setState(() {}); // Trigger a rebuild to reflect the changes
    } catch (e) {
      // Handle any errors that occur during camera initialization
      print('Error initializing camera: $e');
      _initializeControllerFuture = Future.error(e);
    }
  }

  Future<void> _authenticateAndCapturePhoto() async {
    User? user = await _authService.signInAnonymously();
    if (user != null) {
      // Sign in successful
      _timer = Timer(const Duration(seconds: 2), () {
        if (!_isRecentSearchesPageOpen) {
          _capturePhoto();
        }
      }); // Adjust timing as needed
    } else {
      // Sign in failed
      print('User authentication failed');
    }
  }

  Future<void> _capturePhoto() async {
    if (widget.imageUrl != null) {
      print(
          'Inside photo capture method and Received imageUrl: ${widget.imageUrl}');
      // Skip photo capture and navigation if imageUrl is provided
      return;
    }

    try {
      await _initializeControllerFuture;
      if (_cameraController == null ||
          !_cameraController!.value.isInitialized) {
        throw Exception('Camera not initialized');
      }
      final image = await _cameraController!.takePicture();

      // Save the captured photo to the gallery
      final capturePhoto = CapturePhoto();
      await capturePhoto.saveAndUploadPhoto(image.path, (String imageUrlJson) {
        // Decode the JSON-encoded URL
        final Map<String, dynamic> imageUrlMap = jsonDecode(imageUrlJson);
        final String imageUrl = imageUrlMap['url'];

        print('Image saved and uploaded');
        print(
            'Navigating to ${AppRoutes.imageProcessingPage} with imageUrl: $imageUrl');

        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.imageProcessingPage,
            arguments: {'imageUrl': imageUrl},
          );
        }
      });
    } catch (e) {
      // Handle any errors that occur during capture
      print('Error capturing photo: $e');
    }
  }

  void _navigateToMainPage() {
    Navigator.pushReplacementNamed(context, AppRoutes.mainPage);
  }

//   void _navigateToRecentSearchesPage() {
//   setState(() {
//     _isRecentSearchesPageOpen = true;
//   });

//   Navigator.push(
//     context,
//     SlideTransitionRoute(page: const RecentSearchesPage()),
//   ).then((_) {
//     setState(() {
//       _isRecentSearchesPageOpen = false;
//     });

//     // Only proceed if image is loaded and the camera is initialized
//     if (imageLoaded && _cameraController != null && _cameraController!.value.isInitialized) {
//       // Ensure that the image URL is still valid and navigate if needed
//       if (widget.imageUrl != null) {
//         _navigateToProcessingPage(widget.imageUrl!);
//       } else {
//         _capturePhoto(); // Adjust this if you want to handle the photo capture again
//       }
//     }
//   });
// }

  void _navigateToRecentSearchesPage() {
    // Set flag to true when RecentSearchesPage is opened
    setState(() {
      _isRecentSearchesPageOpen = true;
    });

    Navigator.push(
      context,
      SlideTransitionRoute(page: const RecentSearchesPage()),
    ).then((_) {
      // Reset flag when RecentSearchesPage is closed
      setState(() {
        _isRecentSearchesPageOpen = false;
      });

      // Continue photo capture or camera initialization if needed
      if (!imageLoaded &&
          _cameraController != null &&
          _cameraController!.value.isInitialized) {
        _capturePhoto(); // Adjust based on your logic
      }
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _controller.dispose();
    _timer?.cancel(); // Ensure _timer is only canceled if initialized
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print('Received imageUrl in PhotoCapturePage: ${widget.imageUrl}');
    return Scaffold(
      backgroundColor: const Color(0xFF051338),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            TopRowWidget(
              onMenuPressed: _navigateToRecentSearchesPage,
              onEditPressed: _navigateToMainPage,
            ),
            const Spacer(),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: widget.imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox(
                          width: size.width * 0.8, // Adjust the width
                          height: size.height * 0.3, // Adjust the height
                          child: Image.network(
                            widget.imageUrl!,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
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
                        ),
                      )
                    : FutureBuilder<void>(
                        future: _initializeControllerFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (_cameraController != null &&
                                _cameraController!.value.isInitialized) {
                              return CameraPreview(_cameraController!);
                            } else {
                              return const Center(
                                  child: Text('Error initializing camera'));
                            }
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                        },
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
            const PhotoCapturePageTextWidget(), // Use the photo capture page text widget
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

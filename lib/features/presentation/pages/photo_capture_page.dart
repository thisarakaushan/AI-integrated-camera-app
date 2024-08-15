import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:valuefinder/config/routes/app_routes.dart';
import 'package:valuefinder/config/routes/slide_transition_route.dart';
import 'package:valuefinder/core/services/firebase_services/upload_image_to_firebase_service.dart';
import 'package:valuefinder/core/services/save_photo_to_gallery_service.dart';
import 'package:valuefinder/features/presentation/pages/recent_searches_page.dart';
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
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  late AnimationController _controller;
  Timer? _timer; // Timer? to avoid late initialization
  bool imageLoaded = false; // Flag to track if the image is displayed
  bool _isRecentSearchesPageOpen = false; // Track if RecentSearchesPage is open

  Future<void> _navigateToProcessingPage(String imageUrl) async {
    //print('Navigating to ${AppRoutes.imageProcessingPage} with imageUrl: $imageUrl');
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
    //print('Received imageUrl: ${widget.imageUrl}');

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
          Future.delayed(const Duration(seconds: 5), () {
            if (imageLoaded) {
              Future.delayed(const Duration(seconds: 2), () {
                _navigateToProcessingPage(widget.imageUrl!);
              });
            }
          });
        }
      });
    } else {
      _initializeCamera();
      //_authenticateAndCapturePhoto();
      _timer = Timer(const Duration(seconds: 2), () {
        if (!_isRecentSearchesPageOpen) {
          _capturePhoto();
        }
      });
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
      _initializeControllerFuture = Future.error(e);
    }
  }

  Future<void> _capturePhoto() async {
    if (widget.imageUrl != null) {
      // Skip photo capture and navigation if imageUrl is provided
      return;
    }

    try {
      await _initializeControllerFuture;
      if (_cameraController == null ||
          !_cameraController!.value.isInitialized) {
        throw Exception('Camera not initialized');
      }
      final XFile image = await _cameraController!.takePicture();

      // Save the captured photo to the gallery
      final capturePhotoService = CapturePhoto();
      await capturePhotoService.savePhotoToGallery(image.path);

      // Upload the captured photo to Firebase
      uploadImageToFirebase(context, image, (String? imageUrl) {
        if (imageUrl != null) {
          _navigateToProcessingPage(imageUrl);
        } else {
          print('Failed to upload image');
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final lensSize = constraints.maxWidth * 0.8;
        final borderRadius = lensSize * 0.1;

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
                              child: Align(
                                alignment: Alignment.topLeft,
                                widthFactor: lensSize /
                                    (widget.focusRect?.width ?? lensSize),
                                heightFactor: lensSize /
                                    (widget.focusRect?.height ?? lensSize),
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
                              ),
                            )
                          : FutureBuilder<void>(
                              future: _initializeControllerFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (_cameraController!.value.isInitialized) {
                                    return CameraPreview(_cameraController!);
                                  } else {
                                    return const Center(
                                        child:
                                            Text('Error initializing camera'));
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
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                AnimatedImageWidget(
                  controller: _controller,
                  imagePath: 'assets/main_image.png',
                  height: constraints.maxWidth * 0.6,
                  width: constraints.maxWidth * 0.6,
                ),
                const SizedBox(height: 10),
                PhotoCapturePageTextWidget(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}

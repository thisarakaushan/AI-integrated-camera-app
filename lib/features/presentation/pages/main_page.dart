import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:valuefinder/config/routes/app_routes.dart';
import 'package:valuefinder/config/routes/slide_transition_route.dart';
import 'package:valuefinder/core/services/firebase_services/upload_image_to_firebase_service.dart';
import 'package:valuefinder/core/services/image_picker_service.dart';
import 'package:valuefinder/core/services/save_photo_to_gallery_service.dart';
import 'package:valuefinder/features/presentation/pages/recent_searches_page.dart';
import 'package:valuefinder/features/presentation/widgets/main_page_widgets/photo_capture_button_widget.dart';
import 'package:valuefinder/features/presentation/widgets/main_page_widgets/animated_image_widget.dart';
import 'package:valuefinder/features/presentation/widgets/main_page_widgets/gallery_button_widget.dart';
import 'package:valuefinder/features/presentation/widgets/main_page_widgets/main_page_text_widget.dart';

import 'package:valuefinder/features/presentation/widgets/common_widgets/top_row_widget.dart';
import 'package:valuefinder/features/presentation/widgets/photo_capture_page_widgets/capture_camera_lens_widget.dart';

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
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  bool _isRecentSearchesPageOpen = false; // Track if RecentSearchesPage is open

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();

    // Initialize camera controller
    _cameraController = CameraController(
      widget.cameras[0], // Assuming the first camera is used
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    _initializeControllerFuture = _cameraController!.initialize();
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose animation controller
    _cameraController?.dispose(); // Dispose camera controller
    super.dispose();
  }

  // Method to navigate to PhotoCapturePage with the imageUrl
  void _navigateToPhotoCapturePage(String imageUrl) {
    Navigator.pushNamed(
      context,
      AppRoutes.photoCapturePage,
      arguments: {'imageUrl': imageUrl},
    );
  }

  // Capture photo method
  // Future<void> _capturePhoto() async {
  //   try {
  //     await _initializeControllerFuture;
  //     if (_cameraController == null) return;

  //     // Capture photo
  //     final XFile photo = await _cameraController!.takePicture();

  //     // Save to gallery
  //     final result = await CapturePhoto().savePhotoToGallery(photo.path);
  //     result.fold(
  //       (failure) => ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text(failure.message)),
  //       ),
  //       (_) async {
  //         // Upload to Firebase
  //         await uploadImageToFirebase(context, photo, (imageUrl) {
  //           _navigateToPhotoCapturePage(imageUrl!);
  //         });
  //       },
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error capturing photo: $e')),
  //     );
  //   }
  // }
  Future<void> _capturePhoto() async {
    try {
      await _initializeControllerFuture;
      if (_cameraController == null) return;

      // Capture photo
      final XFile photo = await _cameraController!.takePicture();

      // Load image for cropping
      final originalImage =
          img.decodeImage(await File(photo.path).readAsBytes());

      if (originalImage == null) return;

      // Calculate the cropping area based on the lens size and position
      final int cropWidth = (originalImage.width * 0.8).toInt();
      final int cropHeight = cropWidth; // Assuming the lens is square
      final int offsetX = (originalImage.width - cropWidth) ~/ 2;
      final int offsetY = (originalImage.height - cropHeight) ~/ 2;

      // offset to adjust for the shift
      //const double shiftOffsetX = 10.0; // upward shift
      const double shiftOffsetY = 200.0; // downward shift

      final croppedImage = img.copyCrop(
        originalImage,
        x: offsetX,
        y: (offsetY - shiftOffsetY).toInt(),
        width: cropWidth,
        height: cropHeight,
      );

      // Save the cropped image to a file
      final croppedImagePath = '${photo.path}_cropped.jpg';
      final croppedFile = File(croppedImagePath)
        ..writeAsBytesSync(img.encodeJpg(croppedImage));

      // Convert the File to XFile
      final XFile croppedXFile = XFile(croppedFile.path);

      // Save to gallery
      final result = await CapturePhoto().savePhotoToGallery(croppedImagePath);
      result.fold(
        (failure) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        ),
        (_) async {
          // Upload the cropped image to Firebase
          await uploadImageToFirebase(
              context, croppedXFile, // Pass the XFile to the upload function
              (imageUrl) {
            _navigateToPhotoCapturePage(imageUrl!);
          });
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error capturing photo: $e')),
      );
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
          },
        ),
      ),
    );
  }

  // Pick image from gallery method
  Future<void> _pickImageFromGallery() async {
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
          if (imageUrl != null) {
            _navigateToPhotoCapturePage(imageUrl);
          } else {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(content: Text('Failed to get image URL')),
            // );
            print(
                'Failed to get image url because user didn\'t select any image from gallery');
          }
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: ${e.toString()}')),
      );
    }
  }

  void _navigateToMainPage() {
    Navigator.pushReplacementNamed(context, AppRoutes.mainPage);
  }

  // @override
  // Widget build(BuildContext context) {
  //   final size = MediaQuery.of(context).size;
  //   final double lensSize = size.width * 0.8; // Adjusted size for square lens
  //   final double animatedImageSize = size.width * 0.6;

  //   return Scaffold(
  //     backgroundColor: Colors.black,
  //     body: Stack(
  //       children: [
  //         SafeArea(
  //           child: Column(
  //             children: [
  //               const SizedBox(height: 20),
  //               TopRowWidget(
  //                 onMenuPressed: _navigateToRecentSearchesPage,
  //                 onEditPressed: _navigateToMainPage,
  //               ),
  //               const Spacer(),
  //               Center(
  //                 child: Container(
  //                   width: lensSize,
  //                   height: lensSize,
  //                   decoration: BoxDecoration(
  //                     border: Border.all(color: Colors.transparent),
  //                     borderRadius: BorderRadius.circular(10),
  //                   ),
  //                   child: Stack(
  //                     children: [
  //                       FutureBuilder<void>(
  //                         future: _initializeControllerFuture,
  //                         builder: (context, snapshot) {
  //                           if (snapshot.connectionState ==
  //                               ConnectionState.done) {
  //                             return ClipRRect(
  //                               borderRadius: BorderRadius.circular(10),
  //                               child: FittedBox(
  //                                 fit: BoxFit.cover,
  //                                 child: SizedBox(
  //                                   width: lensSize,
  //                                   height: lensSize,
  //                                   child: CameraPreview(_cameraController!),
  //                                 ),
  //                               ),
  //                             );
  //                           } else if (snapshot.hasError) {
  //                             return Center(
  //                               child: Text('Error: ${snapshot.error}'),
  //                             );
  //                           } else {
  //                             return Container();
  //                           }
  //                         },
  //                       ),
  //                       // Draw the custom lens border
  //                       CustomPaint(
  //                         painter: LensBorderPainter(
  //                           focusRect: Rect.fromLTWH(0, 0, lensSize, lensSize),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(height: 5),
  //               AnimatedImageWidget(
  //                 controller: _controller,
  //                 imagePath: 'assets/main_image.png',
  //                 height: animatedImageSize,
  //                 width: animatedImageSize,
  //               ),
  //               const SizedBox(height: 5),
  //               const MainPageTextWidget(),
  //               const SizedBox(height: 10),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   PhotoCaptureButtonWidget(
  //                     onCapturePressed: _capturePhoto,
  //                   ),
  //                   const SizedBox(width: 20),
  //                   GalleryButtonWidget(
  //                     onGalleryPressed: _pickImageFromGallery,
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 30),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double lensSize = size.width * 0.8; // Adjusted size for square lens
    final double animatedImageSize = size.width * 0.6;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview as background
          Positioned.fill(
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final previewAspectRatio =
                      _cameraController!.value.aspectRatio;
                  return AspectRatio(
                    aspectRatio: previewAspectRatio,
                    child: CameraPreview(_cameraController!),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
          // Overlay the UI components on top of the camera preview
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                TopRowWidget(
                  onMenuPressed: _navigateToRecentSearchesPage,
                  onEditPressed: _navigateToMainPage,
                ),
                const Spacer(),
                Center(
                  child: Container(
                    width: lensSize,
                    height: lensSize,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        // Draw the custom lens border
                        CustomPaint(
                          painter: LensBorderPainter(
                            focusRect: Rect.fromLTWH(0, 0, lensSize, lensSize),
                          ),
                        ),
                      ],
                    ),
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
                      onCapturePressed: _capturePhoto,
                    ),
                    const SizedBox(width: 20),
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




  // import 'dart:io';
  // import 'dart:async';
  // import 'package:camera/camera.dart';
  // import 'package:flutter/material.dart';
  // import 'package:valuefinder/config/routes/app_routes.dart';
  // import 'package:valuefinder/config/routes/slide_transition_route.dart';
  // import 'package:valuefinder/core/services/image_picker_service.dart';
  // import 'package:valuefinder/features/presentation/pages/recent_searches_page.dart';
  // import 'package:valuefinder/features/presentation/widgets/main_page_widgets/camera_lens_widget.dart';
  // import 'package:valuefinder/features/presentation/widgets/main_page_widgets/photo_capture_button_widget.dart';
  // import 'package:valuefinder/features/presentation/widgets/main_page_widgets/animated_image_widget.dart';
  // import 'package:valuefinder/features/presentation/widgets/main_page_widgets/gallery_button_widget.dart';
  // import 'package:valuefinder/features/presentation/widgets/main_page_widgets/main_page_text_widget.dart';

  // import 'package:valuefinder/features/presentation/widgets/common_widgets/top_row_widget.dart';

  // class MainPage extends StatefulWidget {
  //   final List<CameraDescription> cameras;
  //   const MainPage({super.key, required this.cameras});

  //   @override
  //   State<MainPage> createState() => _MainPageState();
  // }

  // class _MainPageState extends State<MainPage>
  //     with SingleTickerProviderStateMixin {
  //   late AnimationController _controller;
  //   File? image; // Variable to store picked image
  //   Timer? _navigationTimer; // Timer for automatic navigation
  //   bool _isRecentSearchesPageOpen = false; // Track if RecentSearchesPage is open

  //   @override
  //   void initState() {
  //     super.initState();
  //     _controller = AnimationController(
  //       duration: const Duration(seconds: 5),
  //       vsync: this,
  //     )..repeat();

  //     // Set up a timer for automatic navigation
  //     _startNavigationTimer();
  //     // Initial navigation without picking an image
  //     // Set up a timer for automatic navigation
  //     // _navigationTimer = Timer(const Duration(seconds: 8), () {
  //     //   if (mounted && !_isRecentSearchesPageOpen) {
  //     //     // Navigate to PhotoCapturePage if gallery button wasn't clicked
  //     //     _navigateToPhotoCapturePage();
  //     //   }
  //     // });
  //   }

  //   void _startNavigationTimer() {
  //     _navigationTimer = Timer(const Duration(seconds: 8), () {
  //       if (mounted && !_isRecentSearchesPageOpen) {
  //         _navigateToPhotoCapturePage();
  //       }
  //     });
  //   }

  //   void _navigateToPhotoCapturePage({String? imageUrl}) {
  //     if (imageUrl != null) {
  //       Navigator.pushNamed(
  //         context,
  //         AppRoutes.photoCapturePage,
  //         arguments: {'imageUrl': imageUrl},
  //       );
  //     } else {
  //       Navigator.pushNamed(
  //         context,
  //         AppRoutes.photoCapturePage,
  //       );
  //     }
  //   }

  //   Future<void> _pickImageFromGallery() async {
  //     _navigationTimer?.cancel(); // Cancel the automatic navigation timer

  //     try {
  //       await pickImageFromGallery(
  //         context,
  //         (pickedImage) {
  //           if (pickedImage != null) {
  //             setState(() {
  //               image = pickedImage;
  //             });
  //           }
  //         },
  //         (imageUrl) {
  //           // Use Future.delayed to navigate after a short delay
  //           Future.delayed(const Duration(seconds: 2), () {
  //             if (imageUrl != null) {
  //               _navigateToPhotoCapturePage(imageUrl: imageUrl);
  //             } else {
  //               ScaffoldMessenger.of(context).showSnackBar(
  //                 const SnackBar(content: Text('Failed to get image URL')),
  //               );
  //               _navigateToPhotoCapturePage();
  //             }
  //           });
  //         },
  //       );
  //     } catch (e) {
  //       // handle specific error and show message
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Error picking image: ${e.toString()}')),
  //       );
  //       // Navigate to PhotoCapturePage after a short delay
  //       Future.delayed(const Duration(seconds: 2), () {
  //         _navigateToPhotoCapturePage();
  //       });
  //     }
  //   }

  //   void _navigateToRecentSearchesPage() {
  //     setState(() {
  //       _isRecentSearchesPageOpen = true;
  //     });

  //     Navigator.push(
  //       context,
  //       SlideTransitionRoute(
  //         page: RecentSearchesPage(
  //           onClose: () {
  //             setState(() {
  //               _isRecentSearchesPageOpen = false;
  //             });
  //             // Re-enable automatic navigation after closing the RecentSearchesPage
  //             _startNavigationTimer();
  //           },
  //         ),
  //       ),
  //     );
  //   }

  //   void _navigateToMainPage() {
  //     Navigator.pushReplacementNamed(context, AppRoutes.mainPage);
  //   }

  //   @override
  //   void dispose() {
  //     _controller.dispose(); // Dispose animation controller
  //     _navigationTimer?.cancel(); // Cancel the automatic navigation timer
  //     super.dispose();
  //   }

  //   @override
  //   Widget build(BuildContext context) {
  //     final size = MediaQuery.of(context).size;
  //     final double lensSize = size.width * 0.8; // Adjusted size for square lens
  //     final double animatedImageSize = size.width * 0.6;

  //     return Scaffold(
  //       backgroundColor: Colors.black,
  //       body: Stack(
  //         children: [
  //           SafeArea(
  //             child: Column(
  //               children: [
  //                 const SizedBox(height: 20),
  //                 TopRowWidget(
  //                   onMenuPressed: _navigateToRecentSearchesPage,
  //                   onEditPressed: _navigateToMainPage,
  //                 ),
  //                 const Spacer(),
  //                 // camera lens
  //                 Center(
  //                   child: CustomPaint(
  //                     size: Size(lensSize, lensSize),
  //                     painter: LensBorderPainter(),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 5),
  //                 AnimatedImageWidget(
  //                   controller: _controller,
  //                   imagePath: 'assets/main_image.png',
  //                   height: animatedImageSize,
  //                   width: animatedImageSize,
  //                 ),
  //                 const SizedBox(height: 5),
  //                 const MainPageTextWidget(),
  //                 const SizedBox(height: 10),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     PhotoCaptureButtonWidget(
  //                       onCapturePressed: () {
  //                         // Handle photo capture button press
  //                         // Implement your photo capture logic here
  //                       },
  //                     ),
  //                     const SizedBox(width: 20), // Space between buttons
  //                     GalleryButtonWidget(
  //                       onGalleryPressed: _pickImageFromGallery,
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 30),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  // }

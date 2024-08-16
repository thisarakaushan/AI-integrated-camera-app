import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:valuefinder/config/routes/app_routes.dart';
import 'package:valuefinder/core/services/firebase_services/upload_image_to_firebase_service.dart';
import 'package:valuefinder/core/services/image_picker_service.dart';
import 'package:valuefinder/core/services/save_photo_to_gallery_service.dart';
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

  // Method to navigate to PhotoCapturePage with the imageUrl
  void _navigateToPhotoCapturePage(String imageUrl) {
    Navigator.pushNamed(
      context,
      AppRoutes.photoCapturePage,
      arguments: {'imageUrl': imageUrl},
    );
  }

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

  void _navigateToMainPage() async {
    if (_cameraController != null) {
      await _cameraController?.dispose(); // Dispose of the camera controller
    }
    Navigator.pushReplacementNamed(context, AppRoutes.mainPage);
  }

  @override
  void dispose() {
    _cameraController?.dispose(); // Dispose camera controller
    _controller.dispose(); // Dispose animation controller
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
          // Camera preview as background
          Positioned.fill(
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (_cameraController != null &&
                      _cameraController!.value.isInitialized) {
                    final previewAspectRatio =
                        _cameraController!.value.aspectRatio;
                    return AspectRatio(
                      aspectRatio: previewAspectRatio,
                      child: CameraPreview(_cameraController!),
                    );
                  } else {
                    return Center(
                      child: Text('Camera not initialized'),
                    );
                  }
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
                const SizedBox(height: 5),
                TopRowWidget(
                  onCameraPressed: _navigateToMainPage,
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
                  imagePath: 'assets/page_images/main_image.png',
                  height: animatedImageSize,
                  width: animatedImageSize,
                ),
                const SizedBox(height: 5),
                const MainPageTextWidget(),
                const SizedBox(height: 15),
                Row(
                  children: [
                    // Spacer to push GalleryButtonWidget to the left
                    Spacer(flex: 1),
                    // GalleryButtonWidget on the left
                    GalleryButtonWidget(
                      onGalleryPressed: _pickImageFromGallery,
                    ),
                    // Spacer to push PhotoCaptureButtonWidget to the center
                    Spacer(flex: 1),
                    // PhotoCaptureButtonWidget in the center
                    PhotoCaptureButtonWidget(
                      onCapturePressed: _capturePhoto,
                    ),
                    // Spacer to push GalleryButtonWidget to the right
                    Spacer(flex: 3),
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

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:valuefinder/config/routes/app_routes.dart';
import 'package:valuefinder/features/presentation/widgets/animated_image_widget.dart';
import 'package:valuefinder/features/presentation/widgets/photo_capture_page_text_widget.dart';
import 'package:valuefinder/features/presentation/widgets/top_row_widget.dart';

class PhotoCapturePage extends StatefulWidget {
  const PhotoCapturePage({super.key, required String imagePath});

  @override
  _PhotoCapturePageState createState() => _PhotoCapturePageState();
}

class _PhotoCapturePageState extends State<PhotoCapturePage>
    with SingleTickerProviderStateMixin {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  late AnimationController _controller;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();
    _timer = Timer(
        const Duration(seconds: 2), _capturePhoto); // Adjust timing as needed
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(
      cameras.first,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _cameraController.initialize();
  }

  Future<void> _capturePhoto() async {
    try {
      await _initializeControllerFuture;
      final image = await _cameraController.takePicture();
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.imageProcessingPage,
          arguments: image.path,
        );
      }
    } catch (e) {
      // Handle any errors that occur during capture
      print(e);
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            TopRowWidget(onMenuPressed: () {}, onEditPressed: () {}), // top row
            const Spacer(),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return CameraPreview(_cameraController);
                    } else {
                      return const Center(child: CircularProgressIndicator());
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
            const PhotoCapturePageTextWidget(), // use the photo capture page text widget
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:valuefinder/config/routes/app_routes.dart';
// import 'package:valuefinder/core/api/upload_image_api_service.dart';
import 'package:valuefinder/features/presentation/widgets/animated_image_widget.dart';
import 'package:valuefinder/features/presentation/widgets/photo_capture_page_text_widget.dart';
import 'package:valuefinder/features/presentation/widgets/top_row_widget.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class PhotoCapturePage extends StatefulWidget {
  const PhotoCapturePage({super.key});

  @override
  _PhotoCapturePageState createState() => _PhotoCapturePageState();
}

class _PhotoCapturePageState extends State<PhotoCapturePage>
    with SingleTickerProviderStateMixin {
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
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

  Future<void> _capturePhoto() async {
    try {
      await _initializeControllerFuture;
      if (_cameraController == null ||
          !_cameraController!.value.isInitialized) {
        throw Exception('Camera not initialized');
      }
      final image = await _cameraController!.takePicture();

      // save the captured photo to the gallery
      final capturePhoto = CapturePhoto();
      await capturePhoto.saveAndUploadPhoto(image.path);
      print('Image saved and Uploaded');

      if (mounted) {
        print(
            'Navigating to ${AppRoutes.imageProcessingPage} with arguments: ${image.path}');
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.imageProcessingPage,
          arguments: {'imagePath': image.path},
        );
      }
    } catch (e) {
      // Handle any errors that occur during capture
      print('Error capturing photo: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
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
                      if (_cameraController != null &&
                          _cameraController!.value.isInitialized) {
                        return CameraPreview(_cameraController!);
                      } else {
                        return const Center(
                            child: Text('Error initializing camera'));
                      }
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
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

class CapturePhoto {
  // Method to save the captured photo to the gallery and upload it to the server
  Future<void> saveAndUploadPhoto(String imagePath) async {
    print('Call save photo method');

    // check for permissions
    if (await Permission.storage.request().isGranted) {
      try {
        // Read the file from the given path
        final File imageFile = File(imagePath);
        if (!await imageFile.exists()) {
          print('File does not exist at $imagePath');
          return;
        }
        final Uint8List bytes = await imageFile.readAsBytes();

        // Save the image to the gallery
        final result = await ImageGallerySaver.saveImage(
          bytes,
          quality: 100,
          name: 'captured_image_${DateTime.now().millisecondsSinceEpoch}',
        );

        print('Image saved to gallery: $result');

        // Obtain the token
        // final FirebaseAuth _auth = FirebaseAuth.instance;
        // User? user = _auth.currentUser;
        // String? token = await user?.getIdToken();

        // if (token == null) {
        //   print('Error obtaining token');
        //   return;
        // }

        // upload image to server
        // final uploadImageApiService = UploadImageApiService(
        //   baseUrl: 'https://uploadimage-s4r2ozb5wq-uc.a.run.app',
        //   token:
        //       'eyJhbGciOiJSUzI1NiIsImtpZCI6IjBjYjQyNzQyYWU1OGY0ZGE0NjdiY2RhZWE0Yjk1YTI5ZmJhMGM1ZjkiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vZXhjZWxseS1zdGFydHVwIiwiYXVkIjoiZXhjZWxseS1zdGFydHVwIiwiYXV0aF90aW1lIjoxNzIyMzQzOTI3LCJ1c2VyX2lkIjoiWTlPeWtGczgxbWU3TDJzeXMyeWpVVDNYSXFDMyIsInN1YiI6Ilk5T3lrRnM4MW1lN0wyc3lzMnlqVVQzWElxQzMiLCJpYXQiOjE3MjIzNDM5MjcsImV4cCI6MTcyMjM0NzUyNywiZW1haWwiOiJuaWxhbnRoYUBleGNlbGx5LmlvIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7ImVtYWlsIjpbIm5pbGFudGhhQGV4Y2VsbHkuaW8iXX0sInNpZ25faW5fcHJvdmlkZXIiOiJwYXNzd29yZCJ9fQ.gkI_1ul4pVhdYZ62u7KwVDazE_bryQIuNe0izpVuS9unz4qFQeZkcIXFnN5AUZ9GjjgiXUwez1gjJQfM9ipuOyVKQbrYKI7aFXwLvVhPqUSNekFGBjz8UCwp5ojeg2aIbgv8-NhKnFEaYfRVw_EAJ_LdQW9JXM11QbnWtHpAgU4WjvIgw248tvwlkIpjDt3QrEQdfHnvXjg3L52TqU7IiyIJPeRrRxErXzzRGoU1oD_cXiup1gm_j1JSJBbuWa7Afr90S9V8cgQ-CXzCNlSGLTiA8ay3g5YOPY5aLESxh9gGWArKYr05glvoZtyakftL0xDKip3NvhvkFMp6ASgHmg',
        // );
        // final uploadResponse =
        //     await uploadImageApiService.uploadImage(imageFile);

        // print(
        //     'uploadResponse : ${uploadResponse.statusCode} ${uploadResponse.body}');
      } catch (e) {
        print('Error saving image to gallery: $e');
      }
    } else {
      print('Storage permission not granted');
    }
  }
}

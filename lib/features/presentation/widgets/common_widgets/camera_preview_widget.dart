import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraPreviewWidget extends StatelessWidget {
  final CameraController cameraController;
  final Size size;

  const CameraPreviewWidget({
    super.key,
    required this.cameraController,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: cameraController.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SizedBox(
            width: size.width * 0.8, // Relative width to screen size
            height: size.height * 0.3, // Relative height to screen size
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20), // Rounded corners
              child: AspectRatio(
                aspectRatio: cameraController.value.aspectRatio,
                child: CameraPreview(cameraController),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(color: Colors.red),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

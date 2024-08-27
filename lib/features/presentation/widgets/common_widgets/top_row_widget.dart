import 'package:flutter/material.dart';

class TopRowWidget extends StatelessWidget {
  final VoidCallback onCameraPressed;

  const TopRowWidget({
    super.key,
    required this.onCameraPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the icon size based on screen width
    final double iconSize = MediaQuery.of(context).size.width * 0.07;

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.end, // Align the camera icon to the end
      children: [
        IconButton(
          icon: Icon(Icons.camera_alt,
              color: Colors.white,
              size: iconSize), // Use the responsive icon size
          onPressed: onCameraPressed,
        ),
      ],
    );
  }
}

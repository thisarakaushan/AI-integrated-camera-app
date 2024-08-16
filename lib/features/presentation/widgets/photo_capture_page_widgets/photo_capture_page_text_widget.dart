import 'package:flutter/material.dart';

class PhotoCapturePageTextWidget extends StatelessWidget {
  const PhotoCapturePageTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double textSize = size.width * 0.04; // 5% of screen width
    final double spacing = size.height * 0.01; // 1% of screen height

    return Column(
      children: [
        SizedBox(height: spacing), // Dynamic space based on screen height
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: const [
              Color(0xff2753cf),
              Color(0xffc882ff),
              Color(0xff46edfe),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            'Analyzing your image...',
            style: TextStyle(
              color: Colors.white,
              fontSize: textSize,
            ),
          ),
        ),
        Text(
          'Please wait a moment',
          style: TextStyle(
            color: Color(0xff46edfe),
            fontSize: textSize,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class ProcessingAndRecognitionPageTextWidget extends StatelessWidget {
  const ProcessingAndRecognitionPageTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double textSize = size.width * 0.04; // 5% of screen width
    final double spacing = size.height * 0.01; // 1% of screen height

    return Column(
      children: [
        SizedBox(height: spacing), // Use dynamic spacing
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              Color(0xff2753cf),
              Color(0xffc882ff),
              Color(0xff46edfe),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            'Processing...',
            style: TextStyle(color: Colors.white, fontSize: textSize),
          ),
        ),
        SizedBox(height: spacing), // Use dynamic spacing
        Text(
          'We\'re finding the best information for you',
          style: TextStyle(color: Color(0xff46edfe), fontSize: textSize),
        ),
      ],
    );
  }
}

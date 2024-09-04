import 'package:flutter/material.dart';
import 'package:valuefinder/core/utils/widget_constants.dart';

class PhotoCapturePageTextWidget extends StatelessWidget {
  const PhotoCapturePageTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final double textSize = WidgetsConstant.textFieldHeight * 0.1;

    return Column(
      children: [
        SizedBox(height: WidgetsConstant.height * 1),
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

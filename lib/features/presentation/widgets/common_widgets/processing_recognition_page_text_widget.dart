import 'package:flutter/material.dart';

import '../../../../core/utils/widget_constants.dart';

class ProcessingAndRecognitionPageTextWidget extends StatelessWidget {
  const ProcessingAndRecognitionPageTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final double textSize = WidgetsConstant.textFieldHeight * 0.1;

    return Column(
      children: [
        SizedBox(height: WidgetsConstant.height * 1),
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
        SizedBox(height: WidgetsConstant.height * 1),
        Text(
          'We\'re finding the best information for you',
          style: TextStyle(color: Color(0xff46edfe), fontSize: textSize),
        ),
      ],
    );
  }
}

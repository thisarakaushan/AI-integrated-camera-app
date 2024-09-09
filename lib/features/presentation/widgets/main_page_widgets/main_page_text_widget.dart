import 'package:flutter/material.dart';

import '../../../../core/utils/widget_constants.dart';

class MainPageTextWidget extends StatelessWidget {
  const MainPageTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final double textSize = WidgetsConstant.textFieldHeight * 0.1;

    return Column(
      children: [
        SizedBox(height: WidgetsConstant.height * 1),
        // Stack to layer the text and its outline
        Stack(
          children: [
            // Black outline text
            Positioned(
              left: 1.0,
              top: 1.0,
              child: Text(
                'What are you looking at?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: textSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Main text
            Text(
              'What are you looking at?',
              style: TextStyle(
                color: Colors.white,
                fontSize: textSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: WidgetsConstant.height * 1),
        Stack(
          children: [
            // Black outline text
            Positioned(
              left: 1.0,
              top: 1.0,
              child: Text(
                'Focus your camera on anything around you',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: textSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Main text
            Text(
              'Focus your camera on anything around you',
              style: TextStyle(
                color: Colors.white,
                fontSize: textSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class MainPageTextWidget extends StatelessWidget {
  const MainPageTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double textSize = size.width * 0.04; // 5% of screen width

    return Column(
      children: [
        const SizedBox(height: 5),
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
        const SizedBox(height: 5),
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

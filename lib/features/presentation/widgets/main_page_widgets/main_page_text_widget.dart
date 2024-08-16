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
            'What are you looking at?',
            style: TextStyle(color: Colors.white, fontSize: textSize),
          ),
        ),
        Text(
          'Focus your camera on anything around you',
          style: TextStyle(color: Color(0xff46edfe), fontSize: textSize),
        ),
      ],
    );
  }
}

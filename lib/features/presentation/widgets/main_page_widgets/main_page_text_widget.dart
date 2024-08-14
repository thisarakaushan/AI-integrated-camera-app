import 'package:flutter/material.dart';

class MainPageTextWidget extends StatelessWidget {
  const MainPageTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: const Text(
            'What are you looking at?',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        const Text(
          'Focus your camera on anything around you',
          style: TextStyle(color: Color(0xff46edfe), fontSize: 16),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:valuefinder/features/presentation/widgets/animated_image_widget.dart';

class InfoPageAnimatedImageWidget extends StatelessWidget {
  final AnimationController controller;
  final String imagePath;

  const InfoPageAnimatedImageWidget({
    super.key,
    required this.controller,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF051338), // Background color
        gradient: const LinearGradient(
          colors: [
            Color(0xff2753cf),
            Color(0xffc882ff),
            Color(0xff46edfe),
          ],
        ),
        border: Border.all(
          width: 2,
          color: Colors.transparent, // Transparent to let gradient show
        ),
      ),
      child: Center(
        child: AnimatedImageWidget(
          controller: controller,
          imagePath: imagePath,
          height: 33,
          width: 33,
        ),
      ),
    );
  }
}

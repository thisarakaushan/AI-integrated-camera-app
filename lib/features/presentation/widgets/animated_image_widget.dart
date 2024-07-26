import 'package:flutter/material.dart';

class AnimatedImageWidget extends StatelessWidget {
  final AnimationController controller;
  final String imagePath;

  const AnimatedImageWidget({
    super.key,
    required this.controller,
    required this.imagePath, required int height, required int width,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      child: Image.asset(
        imagePath,
        height: 131,
        width: 131,
      ),
      builder: (context, child) {
        return Transform.rotate(
          angle: controller.value * 2.0 * 3.141592653589793,
          child: child,
        );
      },
    );
  }
}

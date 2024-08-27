import 'package:flutter/material.dart';

class AnimatedImageWidget extends StatelessWidget {
  final AnimationController controller;
  final String imagePath;
  final double height;
  final double width;

  const AnimatedImageWidget({
    super.key,
    required this.controller,
    required this.imagePath,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      child: Image.asset(
        imagePath,
        height: height,
        width: width,
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

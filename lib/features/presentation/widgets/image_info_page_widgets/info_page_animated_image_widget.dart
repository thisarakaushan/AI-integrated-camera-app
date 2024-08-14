import 'package:flutter/material.dart';
import 'package:valuefinder/features/presentation/widgets/splash_page_widgets/animated_image_widget.dart';

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
        gradient: const LinearGradient(
          colors: [
            Color(0xff2753cf),
            Color(0xffc882ff),
            Color(0xff46edfe),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.transparent,
          width: 1, // Adjust the width of the gradient border as needed
        ),
      ),
      child: Center(
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                const Color(0xff0e235a), // Background color inside the circle
          ),
          child: Center(
            child: AnimatedImageWidget(
              controller: controller,
              imagePath: imagePath,
              height: 33,
              width: 33,
            ),
          ),
        ),
      ),
    );
  }
}

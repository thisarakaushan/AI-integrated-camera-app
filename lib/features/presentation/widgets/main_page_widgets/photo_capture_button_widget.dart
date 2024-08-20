import 'package:flutter/material.dart';

class PhotoCaptureButtonWidget extends StatelessWidget {
  final VoidCallback onCapturePressed;

  const PhotoCaptureButtonWidget({super.key, required this.onCapturePressed});

  @override
  Widget build(BuildContext context) {
    final double buttonSize =
        MediaQuery.of(context).size.width * 0.17; // 20% of screen width

    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(buttonSize / 2), // Circular border radius
        gradient: const LinearGradient(
          colors: [Color(0xff2753cf), Color(0xffc882ff), Color(0xff46edfe)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xff0e235a),
            borderRadius:
                BorderRadius.circular(buttonSize / 2), // Circular border radius
          ),
          child: ElevatedButton(
            onPressed: onCapturePressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    buttonSize / 2), // Circular border radius
              ),
              padding: EdgeInsets.zero,
              shadowColor: Colors.transparent,
            ),
            child: Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: buttonSize * 0.5, // Icon size relative to button size
            ),
          ),
        ),
      ),
    );
  }
}

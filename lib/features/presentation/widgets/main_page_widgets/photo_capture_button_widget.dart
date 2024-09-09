import 'package:flutter/material.dart';

import '../../../../core/utils/widget_constants.dart';

class PhotoCaptureButtonWidget extends StatelessWidget {
  //final VoidCallback onCapturePressed;
  final void Function()? onCapturePressed;

  const PhotoCaptureButtonWidget({super.key, required this.onCapturePressed});

  @override
  Widget build(BuildContext context) {
    final double buttonSize = WidgetsConstant.width * 18;

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
              size: buttonSize * 0.4, // Icon size relative to button size
            ),
          ),
        ),
      ),
    );
  }
}

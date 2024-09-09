import 'package:flutter/material.dart';
import 'package:valuefinder/core/utils/widget_constants.dart';

class TopRowWidget extends StatelessWidget {
  final VoidCallback onCameraPressed;

  const TopRowWidget({
    super.key,
    required this.onCameraPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the icon size based on screen width
    final double iconSize = WidgetsConstant.width * 8;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: Icon(Icons.camera_alt, color: Colors.white, size: iconSize),
          onPressed: onCameraPressed,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class LensBorderPainter extends CustomPainter {
  final Rect focusRect;

  LensBorderPainter({required this.focusRect});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Draw the lens border
    final borderRadius = focusRect.width * 0.1;

    // Top left corner
    canvas.drawLine(Offset(focusRect.left, focusRect.top + borderRadius),
        Offset(focusRect.left, focusRect.top), paint);
    canvas.drawLine(Offset(focusRect.left, focusRect.top),
        Offset(focusRect.left + borderRadius, focusRect.top), paint);

    // Top right corner
    canvas.drawLine(Offset(focusRect.right - borderRadius, focusRect.top),
        Offset(focusRect.right, focusRect.top), paint);
    canvas.drawLine(Offset(focusRect.right, focusRect.top),
        Offset(focusRect.right, focusRect.top + borderRadius), paint);

    // Bottom left corner
    canvas.drawLine(Offset(focusRect.left, focusRect.bottom - borderRadius),
        Offset(focusRect.left, focusRect.bottom), paint);
    canvas.drawLine(Offset(focusRect.left, focusRect.bottom),
        Offset(focusRect.left + borderRadius, focusRect.bottom), paint);

    // Bottom right corner
    canvas.drawLine(Offset(focusRect.right - borderRadius, focusRect.bottom),
        Offset(focusRect.right, focusRect.bottom), paint);
    canvas.drawLine(Offset(focusRect.right, focusRect.bottom),
        Offset(focusRect.right, focusRect.bottom - borderRadius), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

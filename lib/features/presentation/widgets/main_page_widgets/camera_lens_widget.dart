import 'package:flutter/material.dart';

class LensBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final cornerLength = size.width * 0.1;

    // Top left corner
    canvas.drawLine(Offset(0, cornerLength), Offset(0, 0), paint);
    canvas.drawLine(Offset(0, 0), Offset(cornerLength, 0), paint);

    // Top right corner
    canvas.drawLine(
        Offset(size.width - cornerLength, 0), Offset(size.width, 0), paint);
    canvas.drawLine(
        Offset(size.width, 0), Offset(size.width, cornerLength), paint);

    // Bottom left corner
    canvas.drawLine(
        Offset(0, size.height), Offset(0, size.height - cornerLength), paint);
    canvas.drawLine(
        Offset(0, size.height), Offset(cornerLength, size.height), paint);

    // Bottom right corner
    canvas.drawLine(Offset(size.width, size.height - cornerLength),
        Offset(size.width, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height),
        Offset(size.width - cornerLength, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

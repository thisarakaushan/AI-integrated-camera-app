import 'package:flutter/material.dart';

class LensBorderPainter extends CustomPainter {
  final Rect focusRect;

  LensBorderPainter({required this.focusRect});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0 // Make the stroke a bit thicker
      ..style = PaintingStyle.stroke;

    final double cornerLength = 15.0; // Define the length of each corner
    final double cornerRadius = 20.0; // Define the radius of the corner's curve

    // Top left corner
    canvas.drawLine(
        Offset(focusRect.left + cornerRadius, focusRect.top),
        Offset(focusRect.left + cornerRadius + cornerLength, focusRect.top),
        paint); // Top horizontal line
    canvas.drawLine(
        Offset(focusRect.left, focusRect.top + cornerRadius),
        Offset(focusRect.left, focusRect.top + cornerRadius + cornerLength),
        paint); // Left vertical line

    // Top right corner
    canvas.drawLine(
        Offset(focusRect.right - cornerRadius, focusRect.top),
        Offset(focusRect.right - cornerRadius - cornerLength, focusRect.top),
        paint); // Top horizontal line
    canvas.drawLine(
        Offset(focusRect.right, focusRect.top + cornerRadius),
        Offset(focusRect.right, focusRect.top + cornerRadius + cornerLength),
        paint); // Right vertical line

    // Bottom left corner
    canvas.drawLine(
        Offset(focusRect.left + cornerRadius, focusRect.bottom),
        Offset(focusRect.left + cornerRadius + cornerLength, focusRect.bottom),
        paint); // Bottom horizontal line
    canvas.drawLine(
        Offset(focusRect.left, focusRect.bottom - cornerRadius),
        Offset(focusRect.left, focusRect.bottom - cornerRadius - cornerLength),
        paint); // Left vertical line

    // Bottom right corner
    canvas.drawLine(
        Offset(focusRect.right - cornerRadius, focusRect.bottom),
        Offset(focusRect.right - cornerRadius - cornerLength, focusRect.bottom),
        paint); // Bottom horizontal line
    canvas.drawLine(
        Offset(focusRect.right, focusRect.bottom - cornerRadius),
        Offset(focusRect.right, focusRect.bottom - cornerRadius - cornerLength),
        paint); // Right vertical line

    // Drawing the rounded arcs for the corners
    final arcPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Top left arc
    canvas.drawArc(
      Rect.fromCircle(
          center: Offset(
              focusRect.left + cornerRadius, focusRect.top + cornerRadius),
          radius: cornerRadius),
      3.14, // Starting angle (180 degrees)
      1.57, // Sweep angle (90 degrees)
      false,
      arcPaint,
    );

    // Top right arc
    canvas.drawArc(
      Rect.fromCircle(
          center: Offset(
              focusRect.right - cornerRadius, focusRect.top + cornerRadius),
          radius: cornerRadius),
      4.71, // Starting angle (270 degrees)
      1.57, // Sweep angle (90 degrees)
      false,
      arcPaint,
    );

    // Bottom left arc
    canvas.drawArc(
      Rect.fromCircle(
          center: Offset(
              focusRect.left + cornerRadius, focusRect.bottom - cornerRadius),
          radius: cornerRadius),
      1.57, // Starting angle (90 degrees)
      1.57, // Sweep angle (90 degrees)
      false,
      arcPaint,
    );

    // Bottom right arc
    canvas.drawArc(
      Rect.fromCircle(
          center: Offset(
              focusRect.right - cornerRadius, focusRect.bottom - cornerRadius),
          radius: cornerRadius),
      0.0, // Starting angle (0 degrees)
      1.57, // Sweep angle (90 degrees)
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}


// import 'package:flutter/material.dart';

// class LensBorderPainter extends CustomPainter {
//   final Rect focusRect;

//   LensBorderPainter({required this.focusRect});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.white
//       ..strokeWidth = 2.0
//       ..style = PaintingStyle.stroke;

//     // Draw the lens border
//     final borderRadius = focusRect.width * 0.1;

//     // Top left corner
//     canvas.drawLine(Offset(focusRect.left, focusRect.top + borderRadius),
//         Offset(focusRect.left, focusRect.top), paint);
//     canvas.drawLine(Offset(focusRect.left, focusRect.top),
//         Offset(focusRect.left + borderRadius, focusRect.top), paint);

//     // Top right corner
//     canvas.drawLine(Offset(focusRect.right - borderRadius, focusRect.top),
//         Offset(focusRect.right, focusRect.top), paint);
//     canvas.drawLine(Offset(focusRect.right, focusRect.top),
//         Offset(focusRect.right, focusRect.top + borderRadius), paint);

//     // Bottom left corner
//     canvas.drawLine(Offset(focusRect.left, focusRect.bottom - borderRadius),
//         Offset(focusRect.left, focusRect.bottom), paint);
//     canvas.drawLine(Offset(focusRect.left, focusRect.bottom),
//         Offset(focusRect.left + borderRadius, focusRect.bottom), paint);

//     // Bottom right corner
//     canvas.drawLine(Offset(focusRect.right - borderRadius, focusRect.bottom),
//         Offset(focusRect.right, focusRect.bottom), paint);
//     canvas.drawLine(Offset(focusRect.right, focusRect.bottom),
//         Offset(focusRect.right, focusRect.bottom - borderRadius), paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }

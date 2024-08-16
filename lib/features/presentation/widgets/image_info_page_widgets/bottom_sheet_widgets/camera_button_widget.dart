import 'package:flutter/material.dart';

class CameraButtonWidget extends StatelessWidget {
  final VoidCallback onNavigateToMainPage;

  const CameraButtonWidget({
    super.key,
    required this.onNavigateToMainPage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onNavigateToMainPage,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF051338),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF2753CF),
              Color(0xFFC882FF),
              Color(0xFF46EDFE),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: const Icon(
          Icons.camera_alt,
          color: Colors.white,
        ),
      ),
    );
  }
}

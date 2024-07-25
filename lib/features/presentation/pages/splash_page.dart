import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'main_page.dart';

class SplashPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const SplashPage({super.key, required this.cameras});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(
          seconds: 30), // Adjust the duration to change rotation speed
      vsync: this,
    )..repeat();

    Timer(const Duration(seconds: 10), () {
      _controller.stop();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MainPage(cameras: widget.cameras),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF051338), // Background color for the splash screen
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          child: Image.asset(
            'assets/splash_image.png', // Replace with your splash image asset
            width: 357, // Adjust width as needed
            height: 357, // Adjust height as needed
            fit: BoxFit.contain, // Maintain aspect ratio
          ),
          builder: (context, child) {
            return Transform.rotate(
              angle: _controller.value *
                  2.0 *
                  3.141592653589793, // Rotate 360 degrees
              child: child,
            );
          },
        ),
      ),
    );
  }
}

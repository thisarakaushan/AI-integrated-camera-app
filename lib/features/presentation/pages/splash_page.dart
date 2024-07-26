import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
// Import the new StartButtonWidget
import 'package:valuefinder/features/presentation/widgets/start_button_widget.dart';

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
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    // Auto navigation after 10 sec

    // Timer(const Duration(seconds: 10), () {
    //   _controller.stop();
    //   Navigator.of(context).pushReplacementNamed(
    //     '/main-page', // Use named route for navigation
    //     arguments: widget.cameras, // Pass cameras as arguments
    //   );
    // });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToMainPage() {
    Navigator.of(context).pushReplacementNamed(
      '/main-page', // Use named route for navigation
      arguments: widget.cameras, // Pass cameras as arguments
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF051338),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              child: Image.asset(
                'assets/splash_image.png',
                width: 357,
                height: 357,
                fit: BoxFit.contain,
              ),
              builder: (context, child) {
                return Transform.rotate(
                  angle: _controller.value * 2.0 * 3.141592653589793,
                  child: child,
                );
              },
            ),
            const SizedBox(height: 20), // Space between image and text
            const Text(
              'Your own',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w600), // Semi-bold weight
            ),
            const SizedBox(height: 5),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  Color(0xff2753cf),
                  Color(0xffc882ff),
                  Color(0xff46edfe),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: const Text(
                'AI assistance',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w600), // Semi-bold weight
              ),
            ),
            const SizedBox(
              height: 20,
            ), // space between text and button
            StartButtonWidget(
                onPressed: _navigateToMainPage), // Add the StartButtonWidget
          ],
        ),
      ),
    );
  }
}

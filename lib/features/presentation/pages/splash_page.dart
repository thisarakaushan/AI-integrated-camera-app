import 'dart:async';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:valuefinder/config/routes/app_routes.dart';
import 'package:valuefinder/core/error/failures.dart';

import '../../../core/utils/widget_constants.dart';

class SplashPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const SplashPage({super.key, required this.cameras});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String androidVersion = "Fetching Android version...";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    // Start app initialization
    _initializeApp();
    _getDeviceInfo();
  }

  Future<void> _getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    print('Android version: ${androidInfo.version.release}');
    print('Android SDK: ${androidInfo.version.sdkInt}');

    setState(() {
      androidVersion =
          'Android ${androidInfo.version.release} (SDK ${androidInfo.version.sdkInt})';
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _initializeApp() async {
    try {
      // Delay for 2 seconds to show the splash image
      await Future.delayed(const Duration(seconds: 2));

      // Initialization is complete, navigate to the main page
      _navigateToMainPage();
    } catch (error) {
      // Handle any errors that occur during initialization
      _handleFailure(error);
    }
  }

  void _navigateToMainPage() {
    Navigator.of(context).pushReplacementNamed(
      AppRoutes.mainPage,
      arguments: widget.cameras,
    );
  }

  void _handleFailure(Object failure) {
    if (failure is Failure) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(failure.message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _initializeApp();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else {
      print('Unexpected error: $failure');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double imageSize = WidgetsConstant.width * 90;

    return Scaffold(
      backgroundColor: const Color(0xFF051338),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              child: Image.asset(
                'assets/page_images/splash_image.png',
                width: imageSize,
                height: imageSize,
                fit: BoxFit.contain,
              ),
              builder: (context, child) {
                return Transform.rotate(
                  angle: _controller.value * 2.0 * 3.141592653589793,
                  child: child,
                );
              },
            ),
            SizedBox(height: WidgetsConstant.height * 2),
            const Text(
              'Your own',
              style: TextStyle(
                color: Colors.white,
                fontSize: WidgetsConstant.textFieldHeight * 0.30,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: WidgetsConstant.height * 0.5),
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
              child: Text(
                'AI assistance',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: WidgetsConstant.textFieldHeight * 0.30,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: WidgetsConstant.height * 4),
          ],
        ),
      ),
    );
  }
}

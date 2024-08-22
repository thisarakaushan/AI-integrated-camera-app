import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:valuefinder/config/routes/app_routes.dart';
import 'package:valuefinder/core/error/failures.dart';

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

    // Start app initialization
    _initializeApp();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Load resources that depend on the context (like MediaQuery)
    _loadResources();
  }

  Future<void> _initializeApp() async {
    try {
      // Check for necessary permissions
      await _checkPermissions();

      // Delay for 3 seconds to show the splash image
      // await Future.delayed(const Duration(seconds: 2));

      // Initialization is complete, navigate to the main page
      _navigateToMainPage();
    } catch (error) {
      // Handle any errors that occur during initialization
      _handleFailure(error);
    }
  }

  Future<void> _loadResources() async {
    await precacheImage(
        const AssetImage('assets/page_images/splash_image.png'), context);
    await precacheImage(
        const AssetImage('assets/page_images/main_image.png'), context);
    await precacheImage(
        const AssetImage('assets/page_images/info_page_image.png'), context);
  }

  Future<void> _checkPermissions() async {
    final storagePermissionStatus = await _requestStoragePermission();
    if (storagePermissionStatus is Failure) {
      throw storagePermissionStatus;
    }

    final cameraPermissionStatus = await _requestCameraPermission();
    if (cameraPermissionStatus is Failure) {
      throw cameraPermissionStatus;
    }
  }

  Future<Failure?> _requestStoragePermission() async {
    final status = await Permission.storage.request();
    if (status.isDenied) {
      return StoragePermissionFailure('Storage permission denied.');
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
      return StoragePermissionFailure(
          'Storage permission permanently denied. Please enable it from settings.');
    }
    return null;
  }

  Future<Failure?> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isDenied) {
      return CameraInitializationFailure(message: 'Camera permission denied.');
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
      return CameraInitializationFailure(
          message:
              'Camera permission permanently denied. Please enable it from settings.');
    }
    return null;
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
    final size = MediaQuery.of(context).size;
    final double imageSize = size.width * 0.9;

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
            SizedBox(height: size.height * 0.02),
            const Text(
              'Your own',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: size.height * 0.01),
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
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.04),
          ],
        ),
      ),
    );
  }
}






// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:valuefinder/config/routes/app_routes.dart';

// class SplashPage extends StatefulWidget {
//   final List<CameraDescription> cameras;
//   const SplashPage({super.key, required this.cameras});

//   @override
//   State<SplashPage> createState() => _SplashPageState();
// }

// class _SplashPageState extends State<SplashPage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   Timer? _timer; // Timer to implement automatic navigation

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 30),
//       vsync: this,
//     )..repeat();

//     // Navigate to the main page after 2 seconds
//     _timer = Timer(const Duration(seconds: 2), _navigateToMainPage);
//   }

//   void _navigateToMainPage() {
//     Navigator.of(context).pushReplacementNamed(
//       AppRoutes.mainPage,
//       arguments: widget.cameras,
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     _timer?.cancel(); // Cancel the timer if the widget is disposed
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final double imageSize =
//         size.width * 0.9; // Adjust image size relative to screen width
//     final double textSize =
//         size.width * 0.2; // Adjust text size relative to screen width

//     return Scaffold(
//       backgroundColor: const Color(0xFF051338),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             AnimatedBuilder(
//               animation: _controller,
//               child: Image.asset(
//                 'assets/page_images/splash_image.png',
//                 width: imageSize,
//                 height: imageSize,
//                 fit: BoxFit.contain,
//               ),
//               builder: (context, child) {
//                 return Transform.rotate(
//                   angle: _controller.value * 2.0 * 3.141592653589793,
//                   child: child,
//                 );
//               },
//             ),
//             SizedBox(height: size.height * 0.02),
//             Text(
//               'Your own',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 36,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             SizedBox(
//                 height: size.height *
//                     0.01), // Space between elements, relative to screen height
//             ShaderMask(
//               shaderCallback: (bounds) => const LinearGradient(
//                 colors: [
//                   Color(0xff2753cf),
//                   Color(0xffc882ff),
//                   Color(0xff46edfe),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ).createShader(bounds),
//               child: Text(
//                 'AI assistance',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 36,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//             SizedBox(height: size.height * 0.04),
//             //StartButtonWidget(onPressed: _onStartButtonPressed),
//           ],
//         ),
//       ),
//     );
//   }
// }


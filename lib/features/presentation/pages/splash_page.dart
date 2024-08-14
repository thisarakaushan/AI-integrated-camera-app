import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:valuefinder/config/routes/app_routes.dart';
import 'package:valuefinder/features/presentation/widgets/splash_page_widgets/start_button_widget.dart';

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToMainPage() {
    Navigator.of(context).pushReplacementNamed(
      AppRoutes.mainPage, // Use AppRoutes.mainPage
      arguments: widget.cameras,
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
            const SizedBox(height: 20),
            const Text(
              'Your own',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w600),
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
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 20),
            StartButtonWidget(onPressed: _navigateToMainPage),
          ],
        ),
      ),
    );
  }
}

// authenticate navigation

// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:valuefinder/config/routes/app_routes.dart';
// import 'package:valuefinder/features/presentation/widgets/start_button_widget.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class SplashPage extends StatefulWidget {
//   final List<CameraDescription> cameras;
//   const SplashPage({super.key, required this.cameras});

//   @override
//   State<SplashPage> createState() => _SplashPageState();
// }

// class _SplashPageState extends State<SplashPage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 30),
//       vsync: this,
//     )..repeat();

//     // Authenticate and navigate after a short delay
//     Future.delayed(const Duration(seconds: 2), () async {
//       await _authenticateAndNavigate();
//     });
//   }

//   Future<void> _authenticateAndNavigate() async {
//     try {
//       User? user = _auth.currentUser;
//       if (user == null) {
//         // Sign in anonymously if no user is currently signed in
//         UserCredential userCredential = await _auth.signInAnonymously();
//         user = userCredential.user;
//       }
      
//       // Proceed to the main page
//       Navigator.of(context).pushReplacementNamed(
//         AppRoutes.mainPage,
//         arguments: widget.cameras,
//       );
//     } catch (e) {
//       // Handle authentication errors
//       print('Authentication failed: $e');
//       // Optionally show an error message or retry authentication
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF051338),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             AnimatedBuilder(
//               animation: _controller,
//               child: Image.asset(
//                 'assets/splash_image.png',
//                 width: 357,
//                 height: 357,
//                 fit: BoxFit.contain,
//               ),
//               builder: (context, child) {
//                 return Transform.rotate(
//                   angle: _controller.value * 2.0 * 3.141592653589793,
//                   child: child,
//                 );
//               },
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Your own',
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 36,
//                   fontWeight: FontWeight.w600),
//             ),
//             const SizedBox(height: 5),
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
//               child: const Text(
//                 'AI assistance',
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 36,
//                     fontWeight: FontWeight.w600),
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Remove the button if you handle navigation automatically
//             // StartButtonWidget(onPressed: _navigateToMainPage),
//           ],
//         ),
//       ),
//     );
//   }
// }

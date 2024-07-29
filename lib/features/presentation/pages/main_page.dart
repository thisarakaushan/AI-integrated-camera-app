// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:valuefinder/config/routes/app_routes.dart';
// import 'package:valuefinder/features/presentation/bloc/camera_bloc.dart';
// import 'package:valuefinder/features/presentation/bloc/camera_state.dart';
// import 'package:valuefinder/features/presentation/widgets/animated_image_widget.dart';
// import 'package:valuefinder/features/presentation/widgets/gallery_button_widget.dart';
// import 'package:valuefinder/features/presentation/widgets/main_page_text_widget.dart';
// import 'package:valuefinder/features/presentation/widgets/top_row_widget.dart';

// class MainPage extends StatefulWidget {
//   final List<CameraDescription> cameras;
//   const MainPage({super.key, required this.cameras});

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage>
//     with SingleTickerProviderStateMixin {
//   late CameraController cameraController;
//   late Future<void> cameraValue;
//   late AnimationController _controller;
//   late Timer _timer;

//   @override
//   void initState() {
//     super.initState();
//     startCamera(0);
//     _controller = AnimationController(
//       duration: const Duration(seconds: 30), // Adjust duration as needed
//       vsync: this,
//     )..repeat();
//     _startTimer(); // start the timer to navigate to PhotoCapturePage
//   }

//   void startCamera(int camera) {
//     cameraController = CameraController(
//       widget.cameras[camera],
//       ResolutionPreset.high,
//       enableAudio: false,
//     );
//     cameraValue = cameraController.initialize();
//   }

//   void _startTimer() {
//     _timer = Timer(const Duration(seconds: 2), _navigateToPhotoCapturePage);
//   }

//   void _navigateToPhotoCapturePage() async {
//     await cameraController.takePicture().then((XFile file) {
//       if (mounted) {
//         Navigator.pushNamed(
//           context,
//           AppRoutes.photoCapturePage,
//           arguments: file.path,
//         );
//       }
//     });
//   }

//   @override
//   void dispose() {
//     cameraController.dispose();
//     _controller.dispose(); // Dispose animation controller
//     _timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           // Removed CameraPreviewWidget from here
//           SafeArea(
//             child: Column(
//               children: [
//                 const SizedBox(height: 20),
//                 TopRowWidget(
//                     onMenuPressed: () {}, onEditPressed: () {}), // top row
//                 const Spacer(),
//                 // Lens frame without camera preview
//                 Container(
//                   width: size.width * 0.8,
//                   height: size.height * 0.3,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.white, width: 2),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: const Center(
//                     child: Text(
//                       '',
//                       style: TextStyle(color: Colors.white, fontSize: 16),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 5),
//                 AnimatedImageWidget(
//                   controller: _controller,
//                   imagePath: 'assets/main_image.png',
//                   height: 131,
//                   width: 131,
//                 ),
//                 const MainPageTextWidget(), // use the main page text widget
//                 const Spacer(),
//                 const GalleryButtonWidget(), // Use the gallery button widget
//                 const SizedBox(height: 20),
//                 BlocBuilder<CameraBloc, CameraState>(
//                   builder: (context, state) {
//                     if (state is CameraLoaded) {
//                       return Image.file(File(state.imagePath));
//                     } else if (state is CameraLoading) {
//                       return const CircularProgressIndicator();
//                     } else if (state is CameraError) {
//                       return Text(state.message,
//                           style: const TextStyle(color: Colors.red));
//                     } else {
//                       return const SizedBox.shrink();
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:valuefinder/config/routes/app_routes.dart';
import 'package:valuefinder/features/presentation/widgets/animated_image_widget.dart';
import 'package:valuefinder/features/presentation/widgets/gallery_button_widget.dart';
import 'package:valuefinder/features/presentation/widgets/main_page_text_widget.dart';
import 'package:valuefinder/features/presentation/widgets/top_row_widget.dart';

class MainPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const MainPage({super.key, required this.cameras});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  File? _image; // variable to store picked image

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 30), // Adjust duration as needed
      vsync: this,
    )..repeat();
    _navigateToPhotoCapturePage(); // Navigate to PhotoCapturePage
  }

  void _navigateToPhotoCapturePage() {
    // Navigate to PhotoCapturePage immediately after MainPage loads
    Future.delayed(Duration.zero, () {
      Navigator.pushNamed(
        context,
        AppRoutes.photoCapturePage,
      );
    });
  }

  // method to pick image from gallery
  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });

        Navigator.pushNamed(
          context,
          AppRoutes.imageProcessingPage,
          arguments: {'imagePath': _image!.path},
        );
      } else {
        // Handle the case where the user cancels the picker
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image selected.')),
        );
      }
    } catch (e) {
      // Handle any errors during image picking
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            TopRowWidget(onMenuPressed: () {}, onEditPressed: () {}), // top row
            const Spacer(),
            // Lens frame without camera preview
            Container(
              width: size.width * 0.8,
              height: size.height * 0.3,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  '',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 5),
            AnimatedImageWidget(
              controller: _controller,
              imagePath: 'assets/main_image.png',
              height: 131,
              width: 131,
            ),
            const MainPageTextWidget(), // use the main page text widget
            const Spacer(),
            GalleryButtonWidget(
                onGalleryPressed:
                    _pickImageFromGallery), // Use the gallery button widget and pass the method
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

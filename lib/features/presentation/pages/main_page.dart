import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:valuefinder/features/presentation/bloc/camera_bloc.dart';
import 'package:valuefinder/features/presentation/bloc/camera_state.dart';
import 'package:valuefinder/features/presentation/widgets/camera_preview_widget.dart';
import 'package:valuefinder/features/presentation/widgets/animated_image_widget.dart';
import 'package:valuefinder/features/presentation/widgets/gallery_button_widget.dart';

class MainPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const MainPage({super.key, required this.cameras});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late CameraController cameraController;
  late Future<void> cameraValue;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    startCamera(0);
    _controller = AnimationController(
      duration: const Duration(seconds: 30), // Adjust duration as needed
      vsync: this,
    )..repeat();
  }

  void startCamera(int camera) {
    cameraController = CameraController(
      widget.cameras[camera],
      ResolutionPreset.high,
      enableAudio: false,
    );
    cameraValue = cameraController.initialize();
  }

  @override
  void dispose() {
    cameraController.dispose();
    _controller.dispose(); // Dispose animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // CameraPreviewWidget(
          //   cameraController: cameraController,
          //   size: size,
          //   cameraValue: cameraValue,
          // ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  width: size.width * 0.8,
                  height: size.height * 0.3,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CameraPreviewWidget(
                      cameraController: cameraController,
                      size: size,
                      cameraValue: cameraValue,
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
                    'What are you looking at?',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const Text(
                  'Focus your camera on anything around you',
                  style: TextStyle(color: Color(0xff46edfe), fontSize: 16),
                ),
                const Spacer(),
                const GalleryButtonWidget(), // Use the gallery button widget
                const SizedBox(height: 20),
                BlocBuilder<CameraBloc, CameraState>(
                  builder: (context, state) {
                    if (state is CameraLoaded) {
                      return Image.file(File(state.imagePath));
                    } else if (state is CameraLoading) {
                      return const CircularProgressIndicator();
                    } else if (state is CameraError) {
                      return Text(state.message,
                          style: const TextStyle(color: Colors.red));
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

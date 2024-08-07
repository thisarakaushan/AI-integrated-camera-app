import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:valuefinder/config/routes/app_routes.dart';
import 'package:valuefinder/config/routes/slide_transition_route.dart';
import 'package:valuefinder/core/services/upload_image_api_service.dart';
import 'package:valuefinder/features/presentation/pages/recent_searches_page.dart';
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
  File? image; // Variable to store picked image

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
    _navigateToPhotoCapturePage();
  }

  void _navigateToPhotoCapturePage() {
    print('Navigating to PhotoCapturePage'); // Debug log
    Future.delayed(const Duration(seconds: 5), () {
      print('Navigating after sec'); // Debug log
      Navigator.pushNamed(
        context,
        AppRoutes.photoCapturePage,
      );
    });
  }

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (mounted) {
        if (pickedFile != null) {
          setState(() {
            image = File(pickedFile.path);
          });

          // Upload image to Firebase Storage
          await _uploadImageToFirebase(pickedFile);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No image selected.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<void> _uploadImageToFirebase(XFile file) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      if (user != null) {
        String? token = await user.getIdToken();
        if (token != null) {
          final uploadImageApiService = UploadImageApiService(
            baseUrl: 'https://uploadimage-s4r2ozb5wq-uc.a.run.app',
            token: token,
          );
          final uploadResponse =
              await uploadImageApiService.uploadImage(File(file.path));

          if (uploadResponse.statusCode == 200) {
            final responseBody = uploadResponse.body;
            final Map<String, dynamic> responseJson = responseBody is String
                ? jsonDecode(responseBody)
                : responseBody as Map<String, dynamic>;
            final imageUrl = responseJson['url'] as String;

            print('Navigating to ImageProcessingPage with URL: $imageUrl');
            Navigator.pushNamed(
              context,
              AppRoutes.imageProcessingPage,
              arguments: {'imageUrl': imageUrl},
            );
          } else {
            print('Error uploading image: ${uploadResponse.statusCode}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Error uploading image: ${uploadResponse.statusCode}'),
              ),
            );
          }
        } else {
          print('Error obtaining token');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error obtaining authentication token'),
            ),
          );
        }
      } else {
        print('User is not logged in or user object is null');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User is not logged in')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $e')),
        );
      }
    }
  }

  void _navigateToRecentSearchesPage() {
    Navigator.push(
      context,
      SlideTransitionRoute(page: const RecentSearchesPage()),
    );
  }

  void _navigateToMainPage() {
    Navigator.pushReplacementNamed(context, AppRoutes.mainPage);
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if RecentSearchesPage is active
    final isRecentSearchesPageActive =
        ModalRoute.of(context)?.isActive ?? false;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                TopRowWidget(
                  onMenuPressed: _navigateToRecentSearchesPage,
                  onEditPressed: _navigateToMainPage,
                ),
                const Spacer(),
                // Lens frame without camera preview
                Container(
                  width: size.width * 0.8,
                  height: size.height * 0.3,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
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
                const MainPageTextWidget(),
                const Spacer(),
                GalleryButtonWidget(
                  onGalleryPressed: _pickImageFromGallery,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:valuefinder/core/helpers/bottom_sheet_helpers.dart'; // Import the helper file
import 'package:valuefinder/features/presentation/widgets/botton_sheet_widget.dart'; // Import the new widget file
import 'package:valuefinder/features/presentation/widgets/info_page_animated_image_widget.dart';
import 'package:valuefinder/features/presentation/widgets/top_row_widget.dart';
import 'package:valuefinder/features/presentation/widgets/platform_grid_view.dart'; // Import the new grid view widget file
import 'package:valuefinder/config/routes/app_routes.dart';

class ImageInfoPage extends StatefulWidget {
  final String imageUrl;
  final String description;
  final List<Map<String, String>> platforms;

  const ImageInfoPage({
    super.key,
    required this.imageUrl,
    required this.description,
    required this.platforms,
  });

  @override
  _ImageInfoPageState createState() => _ImageInfoPageState();
}

class _ImageInfoPageState extends State<ImageInfoPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Navigation to main page
  void _navigateToMainPage() {
    Navigator.pushReplacementNamed(context, AppRoutes.mainPage);
  }

  // Handle send message action
  void _handleSendMessage() {
    // Add your send message logic here
  }

  // Handle platform tap
  void _onPlatformTap(String name, String imageUrl, String price) {
    showDetailsBottomSheet(
      context,
      widget.imageUrl,
      widget.description,
      name,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0e235a),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TopRowWidget(onMenuPressed: () {}, onEditPressed: () {}),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: InfoPageAnimatedImageWidget(
                      controller: _controller,
                      imagePath: 'assets/info_page_image.png',
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 159,
                    height: 125,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.description,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),
            PlatformGridView(
              platforms: widget.platforms,
              onPlatformTap: _onPlatformTap,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'If you require specific assistance with these shoes, such as prices or sizes, please inform me!',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            const Spacer(),
            BottomSheetWidget(
              onNavigateToMainPage: _navigateToMainPage,
              onSendMessage: _handleSendMessage,
            ),
          ],
        ),
      ),
    );
  }
}

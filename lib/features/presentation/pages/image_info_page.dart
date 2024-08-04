import 'dart:io';
import 'package:flutter/material.dart';
import 'package:valuefinder/features/presentation/widgets/final_details_page.dart';
import 'package:valuefinder/features/presentation/widgets/info_page_animated_image_widget.dart';
import 'package:valuefinder/features/presentation/widgets/top_row_widget.dart';
import 'package:valuefinder/config/routes/app_routes.dart';

class ImageInfoPage extends StatefulWidget {
  final String imageInfoPath;
  final String description;
  final List<Map<String, String>> platforms;

  const ImageInfoPage({
    super.key,
    required this.imageInfoPath,
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

  // Show Bottom Sheet with DetailsPage
  void _showDetailsBottomSheet(String platformName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DetailsPage(
          platformName: platformName,
          imageInfoPath: widget.imageInfoPath,
          description: widget.description,
        );
      },
    );
  }

  // Navigation to main page
  void _navigateToMainPage() {
    Navigator.pushReplacementNamed(context, AppRoutes.mainPage);
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
            // Row to position animated image as a bullet point
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
                  // Use SizedBox to control the exact size
                  SizedBox(
                    width: 159, // Set the width to 159
                    height: 125, // Set the height to 125
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(widget.imageInfoPath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Description
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
            // Details Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                height: 315,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: widget.platforms.length,
                  itemBuilder: (context, index) {
                    final platform = widget.platforms[index];
                    return GestureDetector(
                      onTap: () => _showDetailsBottomSheet(platform['name']!),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              platform['imageUrl']!,
                              height: 40,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              platform['name']!,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              platform['price']!,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Size: ${platform['size']}',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Additional Description
            // Additional Description
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
            // Bottom Camera Button and Chat Bar
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  // Camera Button
                  GestureDetector(
                    onTap: _navigateToMainPage,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(
                            0xFF051338), // Camera icon background color
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
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(10),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF051338),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: const TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Type message...',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 4,
                          top: 2,
                          child: GestureDetector(
                            onTap: () {
                              // Handle send message action
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF2753CF),
                                    Color(0xFFC882FF),
                                    Color(0xFF46EDFE),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Transform.rotate(
                                angle: -3.14 /
                                    2, // Rotate icon to be oriented upwards
                                child: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

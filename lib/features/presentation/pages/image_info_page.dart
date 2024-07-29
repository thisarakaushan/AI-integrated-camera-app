// lib/features/presentation/widgets/image_info_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:valuefinder/features/presentation/widgets/final_details_page.dart';
import 'package:valuefinder/features/presentation/widgets/info_page_animated_image_widget.dart';
import 'package:valuefinder/features/presentation/widgets/top_row_widget.dart';

class ImageInfoPage extends StatefulWidget {
  final String imageInfoPath;
  final String description;

  const ImageInfoPage({
    super.key,
    required this.imageInfoPath,
    required this.description,
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
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // navigation to details platform
  void _navigateToDetailsPage(String platformName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetailsPage(
          platformName: platformName,
          imageInfoPath: widget.imageInfoPath,
          description: widget.description,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TopRowWidget(onMenuPressed: () {}, onEditPressed: () {}), // top row
            const SizedBox(height: 10),
            // Animated Image inside a circular container - animated image widget
            Center(
              child: InfoPageAnimatedImageWidget(
                controller: _controller,
                imagePath: 'assets/info_page_image.png',
              ),
            ),
            const SizedBox(height: 20),
            // Shoe Image
            Container(
              width: 159,
              height: 125,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(widget.imageInfoPath),
                  fit: BoxFit.cover,
                ),
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
            Container(
              width: 295,
              height: 315,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  // eBay
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _navigateToDetailsPage('eBay'),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text('eBay', style: TextStyle(fontSize: 14)),
                        ),
                      ),
                    ),
                  ),
                  // AliExpress
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _navigateToDetailsPage('AliExpress'),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text('AliExpress',
                              style: TextStyle(fontSize: 14)),
                        ),
                      ),
                    ),
                  ),
                  // Amazon
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _navigateToDetailsPage('Amazon'),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text('Amazon', style: TextStyle(fontSize: 14)),
                        ),
                      ),
                    ),
                  ),
                  // Alibaba
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _navigateToDetailsPage('Alibaba'),
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child:
                              Text('Alibaba', style: TextStyle(fontSize: 14)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Additional Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Additional details or information can go here.',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

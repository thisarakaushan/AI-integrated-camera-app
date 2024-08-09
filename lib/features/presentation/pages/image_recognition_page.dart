import 'dart:async';
import 'package:flutter/material.dart';
import 'package:valuefinder/config/routes/app_routes.dart';
import 'package:valuefinder/config/routes/slide_transition_route.dart';
import 'package:valuefinder/features/data/models/product.dart';
import 'package:valuefinder/features/presentation/pages/recent_searches_page.dart';
import 'package:valuefinder/features/presentation/widgets/animated_image_widget.dart';
import 'package:valuefinder/features/presentation/widgets/image_processing_page_text_widget.dart';
import 'package:valuefinder/features/presentation/widgets/top_row_widget.dart';

class ImageRecognitionPage extends StatefulWidget {
  final String imageUrl;
  final String identifiedObject;
  final List<Product> products;

  const ImageRecognitionPage({
    super.key,
    required this.imageUrl,
    required this.identifiedObject,
    required this.products,
  });

  @override
  _ImageRecognitionPageState createState() => _ImageRecognitionPageState();
}

class _ImageRecognitionPageState extends State<ImageRecognitionPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Timer _timer;
  bool _isRecentSearchesPageOpen = false; // Track if RecentSearchesPage is open

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    // Set up the timer to navigate after 4 seconds, but check the flag first
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!_isRecentSearchesPageOpen) {
        _navigateToImageInfoPage();
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _navigateToImageInfoPage() {
    if (_isRecentSearchesPageOpen) {
      return; // Avoid navigation if RecentSearchesPage is open
    }

    if (!_isRecentSearchesPageOpen) {
      if (widget.identifiedObject.isNotEmpty) {
        Navigator.pushNamed(
          context,
          AppRoutes.imageInfoPage,
          arguments: {
            'imageUrl': widget.imageUrl,
            'description': widget.identifiedObject,
            'products':
                widget.products.map((product) => product.toJson()).toList(),
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Identified object is not available.')),
        );
      }
    }
  }

  void _navigateToRecentSearchesPage() {
    setState(() {
      _isRecentSearchesPageOpen = true; // Set flag to true
    });

    Navigator.push(
      context,
      SlideTransitionRoute(page: const RecentSearchesPage()),
    ).then((_) {
      // Reset flag after Recent Searches Page is closed
      setState(() {
        _isRecentSearchesPageOpen = false;
      });
    });
  }

  void _navigateToMainPage() {
    Navigator.pushReplacementNamed(context, AppRoutes.mainPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF051338),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            TopRowWidget(
                onMenuPressed: _navigateToRecentSearchesPage,
                onEditPressed: _navigateToMainPage),
            const Spacer(),
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Text(
                        'Image not available',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.identifiedObject.isNotEmpty
                  ? widget.identifiedObject
                  : 'Object not identified',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            AnimatedImageWidget(
              controller: _controller,
              imagePath: 'assets/main_image.png',
              height: 131,
              width: 131,
            ),
            const SizedBox(height: 20),
            const ImageProcessingPageTextWidget(),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

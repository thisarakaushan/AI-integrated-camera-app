import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:valuefinder/config/routes/slide_transition_route.dart';
import 'package:valuefinder/core/error/failures.dart';
import 'package:valuefinder/features/data/models/product.dart';
import 'package:valuefinder/features/presentation/pages/recent_searches_page.dart';
import 'package:valuefinder/features/presentation/widgets/animated_image_widget.dart';
import 'package:valuefinder/features/presentation/widgets/image_processing_page_text_widget.dart';
import 'package:valuefinder/features/presentation/widgets/top_row_widget.dart';
import 'package:valuefinder/config/routes/app_routes.dart';

class ImageProcessingPage extends StatefulWidget {
  final String imageUrl;

  const ImageProcessingPage({super.key, required this.imageUrl});

  @override
  _ImageProcessingPageState createState() => _ImageProcessingPageState();
}

class _ImageProcessingPageState extends State<ImageProcessingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isRecentSearchesPageOpen = false; // Track if RecentSearchesPage is open

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    // Process the image but handle interruptions from RecentSearchesPage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _processImage();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _processImage() async {
    try {
      print(
          'Is Recent Searches Page Open: $_isRecentSearchesPageOpen'); // Debug log
      if (_isRecentSearchesPageOpen) {
        return; // Avoid processing if RecentSearchesPage is open
      }

      final FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;

      if (user == null) {
        throw PhotoCaptureFailure(message: 'No user is currently signed in.');
      }

      String? token = await user.getIdToken();
      if (token == null) {
        throw PhotoCaptureFailure(
            message: 'Failed to retrieve Firebase ID token.');
      }

      print('Image URL: ${widget.imageUrl}'); // Debug log

      // Step 1: Send image URL to initial endpoint
      final response = await http.post(
        Uri.parse('https://createnewthread-s4r2ozb5wq-uc.a.run.app'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'url': widget.imageUrl}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final String runId = result['runId'] ?? '';
        final String threadId = result['threadId'] ?? '';
        final List toolCalls = result['toolCalls'] ?? [];

        print('Result: $result');

        // Extract the keyword from toolCalls
        String keyword = '';
        for (var call in toolCalls) {
          if (call['type'] == 'function') {
            final functionArgs = jsonDecode(call['function']['arguments']);
            keyword = functionArgs['keyword'] ?? '';
            break;
          }
        }
        print('Extracted Keyword: $keyword');

        if (keyword.isEmpty) {
          throw ServerFailure(
              'Object is not clear. Please provide more images.');
        }

        // Step 2: Use the extracted keyword to get details from shopping URL
        final recognitionResponse = await http.get(
          Uri.parse(
              'https://shopping-s4r2ozb5wq-uc.a.run.app?keyword=$keyword'),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (recognitionResponse.statusCode == 200) {
          final recognitionResult = jsonDecode(recognitionResponse.body);
          print('Recognition result: $recognitionResult');

          // Extract product data
          final List<Product> products = (recognitionResult['products'] as List)
              .map((json) => Product.fromJson(json as Map<String, dynamic>))
              .toList();

          // navigate to imagerecognition page with products
          if (!_isRecentSearchesPageOpen) {
            if (mounted) {
              Navigator.pushNamed(
                context,
                AppRoutes.imageRecognitionPage,
                arguments: {
                  'imageUrl': widget.imageUrl,
                  'identifiedObject': keyword,
                  'products':
                      products.map((product) => product.toJson()).toList(),
                },
              );
            }
          }
        } else {
          final errorResponse = jsonDecode(recognitionResponse.body);
          throw ServerFailure(
              'Failed to recognize the image: ${errorResponse['error']}');
        }
      } else {
        final errorResponse = jsonDecode(response.body);
        if (errorResponse['error'] == 'object not clear') {
          throw ServerFailure(
              'The object in the image is not clear. Please provide more images.');
        } else {
          throw ServerFailure(
              'Failed to process image: ${errorResponse['error']}');
        }
      }
    } catch (e) {
      if (e is Failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message)),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to process image: $e')),
          );
        }
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
      // Reset flag to false after Recent Searches Page is closed
      setState(() {
        _isRecentSearchesPageOpen = false;
      });

      // restart image processing here if needed
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _processImage();
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
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Text('Failed to load image',
                          style: TextStyle(color: Colors.red)),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
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

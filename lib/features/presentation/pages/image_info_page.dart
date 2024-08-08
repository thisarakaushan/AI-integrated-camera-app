import 'package:flutter/material.dart';
import 'package:valuefinder/config/routes/slide_transition_route.dart';
import 'package:valuefinder/features/presentation/pages/recent_searches_page.dart';
import 'package:valuefinder/features/presentation/widgets/botton_sheet_widget.dart';
import 'package:valuefinder/features/presentation/widgets/info_page_animated_image_widget.dart';
import 'package:valuefinder/features/presentation/widgets/platform_grid_view.dart';
import 'package:valuefinder/features/presentation/widgets/top_row_widget.dart';
import 'package:valuefinder/config/routes/app_routes.dart';
import 'package:valuefinder/features/data/models/product.dart';
import 'package:valuefinder/features/presentation/pages/final_details_page.dart';

class ImageInfoPage extends StatefulWidget {
  final String imageUrl;
  final String description;
  final List<Product> products; // Updated to use Product model

  const ImageInfoPage({
    super.key,
    required this.imageUrl,
    required this.description,
    required this.products,
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
      duration: const Duration(seconds: 2), // Add duration for animation
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
  void _onPlatformTap(Product product) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return DetailsPage(
            product: product, // Adjust as needed
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0); // Start position of the slide
          const end = Offset.zero; // End position of the slide
          const curve = Curves.easeInOut; // Animation curve

          var tween = Tween(begin: begin, end: end);
          var offsetAnimation =
              animation.drive(tween.chain(CurveTween(curve: curve)));

          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  void _navigateToRecentSearchesPage() {
    Navigator.push(
      context,
      SlideTransitionRoute(page: const RecentSearchesPage()),
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
            TopRowWidget(
                onMenuPressed: _navigateToRecentSearchesPage,
                onEditPressed: _navigateToMainPage),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 35,
                    height: 35,
                    child: InfoPageAnimatedImageWidget(
                      controller: _controller,
                      imagePath: 'assets/info_page_image.png',
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 130,
                    height: 100,
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
              products: widget.products, // Updated to use Product model
              onProductTap: _onPlatformTap, // Updated to use Product model
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'If you require specific assistance with these ${widget.description}, such as price or sizes, please inform me!',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 5),
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

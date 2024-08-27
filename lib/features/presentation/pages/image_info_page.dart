import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/image_info_page_widgets/platform_grid_view.dart';
import '../widgets/common_widgets/top_row_widget.dart';
import 'package:valuefinder/config/routes/app_routes.dart';
import 'package:valuefinder/features/data/models/product.dart';

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
      duration: const Duration(seconds: 2), // Duration for animation
    );
  }

  // Navigation to main page
  void _navigateToMainPage() {
    Navigator.pushReplacementNamed(context, AppRoutes.mainPage);
  }

  Future<void> _onPlatformTap(Product product) async {
    final uri = Uri.parse(product.link);

    // Attempt to open the link using the specific app (if installed)
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // If the app is not available, open the link in the browser
      await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0e235a),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            TopRowWidget(onCameraPressed: _navigateToMainPage),
            const SizedBox(height: 5),
            // Centered Main Image
            Center(
              child: Container(
                width: 155,
                height: 130,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white, // White border color
                    width: 1, // Border thickness
                  ),
                  borderRadius: BorderRadius.circular(7), // Same as the image
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Centered Object Name
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  widget.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            // Separator line
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(
                color: Colors.grey, // Adjust color as needed
                thickness: 1, // Adjust thickness as needed
              ),
            ),
            const SizedBox(height: 10),
            // Product grid view
            PlatformGridView(
              products: widget.products, // Updated to use Product model
              onProductTap: _onPlatformTap, // Updated to use Product model
            ),
            //const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

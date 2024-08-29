import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/image_info_page_widgets/platform_grid_view.dart';
import '../widgets/common_widgets/top_row_widget.dart';
import 'package:valuefinder/config/routes/app_routes.dart';
import 'package:valuefinder/features/data/models/product.dart';

class ImageInfoPage extends StatefulWidget {
  final String imageUrl;
  final String description;
  final List<Product> products;

  const ImageInfoPage({
    super.key,
    required this.imageUrl,
    required this.description,
    required this.products,
  });

  @override
  _ImageInfoPageState createState() => _ImageInfoPageState();
}

class _ImageInfoPageState extends State<ImageInfoPage> {
  double? imageAspectRatio;

  @override
  void initState() {
    super.initState();
    _loadImageAspectRatio(widget.imageUrl);
  }

  Future<void> _loadImageAspectRatio(String imageUrl) async {
    final image = NetworkImage(imageUrl);
    final completer = Completer<void>();
    image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((info, _) {
        setState(() {
          imageAspectRatio = info.image.width / info.image.height;
        });
        completer.complete();
      }),
    );
    await completer.future;
  }

  void _navigateToMainPage() {
    Navigator.pushReplacementNamed(context, AppRoutes.mainPage);
  }

  Future<void> _onPlatformTap(Product product) async {
    final uri = Uri.parse(product.link);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final containerWidth = screenWidth * 0.4;
    final containerHeight = containerWidth / (imageAspectRatio ?? 1.0);

    return Scaffold(
      backgroundColor: const Color(0xff0e235a),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.01),
            TopRowWidget(onCameraPressed: _navigateToMainPage),
            SizedBox(height: screenHeight * 0.01),
            Center(
              child: Container(
                width: containerWidth,
                height: containerHeight,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Image.network(
                      widget.imageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Text(
                  widget.description,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.045,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Divider(
                color: Colors.grey,
                thickness: 1,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              child: PlatformGridView(
                products: widget.products,
                onProductTap: _onPlatformTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:valuefinder/core/utils/widget_constants.dart';
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
    final containerWidth = WidgetsConstant.width * 40;
    final containerHeight = containerWidth / (imageAspectRatio ?? 1.0);

    return Scaffold(
      backgroundColor: const Color(0xff0e235a),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: WidgetsConstant.height * 3),
            TopRowWidget(onCameraPressed: _navigateToMainPage),
            SizedBox(height: WidgetsConstant.height * 4),
            // Main image container with subtle shadow for separation
            Center(
              child: Container(
                width: containerWidth,
                height: containerHeight,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 4), // Shadow position
                    ),
                  ],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
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
            SizedBox(height: WidgetsConstant.height * 3),
            // Description with padding and alignment
            Center(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: WidgetsConstant.width * 5),
                child: Text(
                  widget.description,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: WidgetsConstant.textFieldHeight * 0.12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: WidgetsConstant.height * 3),
            // New layout for gridview separation: add padding and rounded corners
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xff1a2b5e),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                padding: EdgeInsets.only(
                  top: WidgetsConstant.height * 3,
                  // left: WidgetsConstant.width * 2,
                  // right: WidgetsConstant.width * 2,
                ),
                child: PlatformGridView(
                  products: widget.products,
                  onProductTap: _onPlatformTap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// class ImageInfoPage extends StatefulWidget {
//   final String imageUrl;
//   final String description;
//   final List<Product> products;

//   const ImageInfoPage({
//     super.key,
//     required this.imageUrl,
//     required this.description,
//     required this.products,
//   });

//   @override
//   _ImageInfoPageState createState() => _ImageInfoPageState();
// }

// class _ImageInfoPageState extends State<ImageInfoPage> {
//   double? imageAspectRatio;

//   @override
//   void initState() {
//     super.initState();
//     _loadImageAspectRatio(widget.imageUrl);
//   }

//   Future<void> _loadImageAspectRatio(String imageUrl) async {
//     final image = NetworkImage(imageUrl);
//     final completer = Completer<void>();
//     image.resolve(const ImageConfiguration()).addListener(
//       ImageStreamListener((info, _) {
//         setState(() {
//           imageAspectRatio = info.image.width / info.image.height;
//         });
//         completer.complete();
//       }),
//     );
//     await completer.future;
//   }

//   void _navigateToMainPage() {
//     Navigator.pushReplacementNamed(context, AppRoutes.mainPage);
//   }

//   Future<void> _onPlatformTap(Product product) async {
//     final uri = Uri.parse(product.link);

//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final containerWidth = WidgetsConstant.width * 40;
//     final containerHeight = containerWidth / (imageAspectRatio ?? 1.0);

//     return Scaffold(
//       backgroundColor: const Color(0xff0e235a),
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: WidgetsConstant.height * 3),
//             TopRowWidget(onCameraPressed: _navigateToMainPage),
//             SizedBox(height: WidgetsConstant.height * 4),
//             Center(
//               child: Container(
//                 width: containerWidth,
//                 height: containerHeight,
//                 decoration: BoxDecoration(
//                   border: Border.all(
//                     color: Colors.white,
//                     width: 1,
//                   ),
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(15),
//                   child: FittedBox(
//                     fit: BoxFit.contain,
//                     child: Image.network(
//                       widget.imageUrl,
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: WidgetsConstant.height * 3),
//             Center(
//               child: Padding(
//                 padding:
//                     EdgeInsets.symmetric(horizontal: WidgetsConstant.width * 5),
//                 child: Text(
//                   widget.description,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: WidgetsConstant.textFieldHeight * 0.12,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ),
//             SizedBox(height: WidgetsConstant.height * 2),
//             Padding(
//               padding:
//                   EdgeInsets.symmetric(horizontal: WidgetsConstant.width * 5),
//               child: Divider(
//                 color: Colors.grey[700],
//                 thickness: 1.5,
//               ),
//             ),
//             SizedBox(height: WidgetsConstant.height * 3),
//             Expanded(
//               child: PlatformGridView(
//                 products: widget.products,
//                 onProductTap: _onPlatformTap,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

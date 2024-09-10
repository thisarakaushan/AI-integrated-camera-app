import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:valuefinder/core/utils/widget_constants.dart';
import 'package:valuefinder/features/data/models/product.dart';

class PlatformGridView extends StatelessWidget {
  final List<Product> products;
  final void Function(Product) onProductTap;

  const PlatformGridView({
    super.key,
    required this.products,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the screen height using ScreenUtil
    final screenHeight = 1.sh;

    // Calculate the available height for the GridView
    final adjustedHeight =
        screenHeight - (kToolbarHeight + ScreenUtil().statusBarHeight);

    // Calculate the item height based on screen height
    final itemHeight = WidgetsConstant.height * 40;

    // Define the horizontal padding for each product box
    final horizontalPadding = WidgetsConstant.width * 1;
    final verticalPadding = WidgetsConstant.width * 1.5;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: WidgetsConstant.width * 5),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xff1a2b5e),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
                bottom: Radius.circular(1),
              ),
            ),
            child: SizedBox(
              height: adjustedHeight,
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: verticalPadding,
                  childAspectRatio:
                      (constraints.maxWidth - 4 * horizontalPadding) /
                          itemHeight,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];

                  // Check if the product price contains the "used" tag
                  final isUsed = product.price.toLowerCase().contains('used');

                  return GestureDetector(
                    onTap: () => onProductTap(product),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: verticalPadding),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(WidgetsConstant.width * 5),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.all(WidgetsConstant.width * 2),
                              child: Stack(
                                children: [
                                  Container(
                                    width: WidgetsConstant.width * 32,
                                    height: WidgetsConstant.height * 33,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: WidgetsConstant.width * 0.05,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        product.imageUrl,
                                        fit: BoxFit.contain,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else {
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  // Conditionally show the "Used" tag if it's a used product
                                  if (isUsed)
                                    Positioned(
                                      bottom: WidgetsConstant.height * 25,
                                      left: WidgetsConstant.width * 25,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: WidgetsConstant.width * 2,
                                          vertical:
                                              WidgetsConstant.height * 0.5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                        ),
                                        child: Text(
                                          'Used', // Display the "Used" tag
                                          style: TextStyle(
                                            fontSize:
                                                WidgetsConstant.height * 2,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(width: WidgetsConstant.width * 0.1),
                            Container(
                              width: 0.8,
                              height: WidgetsConstant.height * 37,
                              color: Colors.grey,
                            ),
                            SizedBox(width: WidgetsConstant.width * 0.5),
                            Expanded(
                              child: Padding(
                                padding:
                                    EdgeInsets.all(WidgetsConstant.width * 2),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      product.source,
                                      style: TextStyle(
                                        fontSize:
                                            WidgetsConstant.textFieldHeight *
                                                0.11,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    SizedBox(
                                        height: WidgetsConstant.height * 2),
                                    Text(
                                      product.title,
                                      style: TextStyle(
                                        fontSize:
                                            WidgetsConstant.textFieldHeight *
                                                0.09,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                    SizedBox(
                                        height: WidgetsConstant.height * 0.5),
                                    Text(
                                      product.rating != null
                                          ? 'Rating: ${product.rating} (${product.ratingCount} reviews)'
                                          : 'No ratings available',
                                      style: TextStyle(
                                        fontSize:
                                            WidgetsConstant.textFieldHeight *
                                                0.09,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(
                                        height: WidgetsConstant.height * 0.5),
                                    Text(
                                      product.price,
                                      style: TextStyle(
                                        fontSize:
                                            WidgetsConstant.textFieldHeight *
                                                0.09,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                        height: WidgetsConstant.height * 0.5),
                                    Text(
                                      product.delivery,
                                      style: TextStyle(
                                        fontSize:
                                            WidgetsConstant.textFieldHeight *
                                                0.09,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

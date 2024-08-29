import 'package:flutter/material.dart';
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
    // Determine the width and height of the screen
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate the item height based on screen height
    final itemHeight = WidgetsConstant.height * 45;

    // Define the horizontal padding for each product box
    final horizontalPadding = screenWidth * 0.015;
    final verticalPadding = screenWidth * 0.015;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 37, 61, 121),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
                bottom: Radius.circular(1),
              ),
            ),
            child: SizedBox(
              height: screenHeight -
                  (kToolbarHeight + MediaQuery.of(context).padding.top),
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
                              BorderRadius.circular(screenWidth * 0.025),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(screenWidth * 0.02),
                              child: Stack(
                                children: [
                                  Container(
                                    width: screenWidth * 0.25,
                                    height: screenWidth * 0.25,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                      child: Image.network(
                                        product.imageUrl,
                                        fit: BoxFit.cover,
                                        // Circular Progress Indicator
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
                                  Positioned(
                                    bottom: screenHeight * 0.093,
                                    left: screenWidth * 0.17,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.01,
                                          vertical: screenHeight * 0.002),
                                      color: Colors.blue,
                                      child: Text(
                                        'New', // Placeholder for the status text
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.03,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 5),
                            Container(
                              width: 1,
                              height: WidgetsConstant.height * 40,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(screenWidth * 0.02),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      product.source,
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    SizedBox(height: screenHeight * 0.005),
                                    Text(
                                      product.title,
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.035,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                    SizedBox(height: screenHeight * 0.005),
                                    Text(
                                      product.rating != null
                                          ? 'Rating: ${product.rating} (${product.ratingCount} reviews)'
                                          : 'No ratings available',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.035,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.005),
                                    Text(
                                      product.price,
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.035,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.005),
                                    Text(
                                      product.delivery,
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.035,
                                        color: Colors.grey,
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

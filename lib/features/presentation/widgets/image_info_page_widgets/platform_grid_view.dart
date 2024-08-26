import 'package:flutter/material.dart';
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
    final itemHeight = screenHeight * 0.18;

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
              // Height of the item box
              // height: screenHeight -
              //     (kToolbarHeight + MediaQuery.of(context).padding.top),
              height: itemHeight * 3.43,
              child: GridView.builder(
                // Smooth the scroller
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
                              color:
                                  Colors.black.withOpacity(0.5), // Shadow color
                              spreadRadius: 2, // How much the shadow spreads
                              blurRadius: 5, // The blur radius of the shadow
                              offset: const Offset(
                                  0, 3), // The offset of the shadow
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
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: screenHeight * 0.095,
                                    left: screenWidth * 0.16,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.02,
                                          vertical: screenHeight * 0.003),
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
                            // Sepearate line
                            const SizedBox(width: 5),
                            Container(
                              width: 1,
                              height: screenHeight * 0.15,
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
                                        fontSize: screenWidth * 0.035,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.005),
                                    Text(
                                      product.title,
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
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



// import 'package:flutter/material.dart';
// import 'package:valuefinder/features/data/models/product.dart';

// class PlatformGridView extends StatelessWidget {
//   final List<Product> products;
//   final void Function(Product) onProductTap;

//   const PlatformGridView({
//     super.key,
//     required this.products,
//     required this.onProductTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final double gridItemHeight = constraints.maxWidth * 0.2;
//         final int crossAxisCount = products.length <= 2 ? products.length : 2;

//         return Padding(
//           padding:
//               EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.05),
//           child: Container(
//             width: double.infinity,
//             height: gridItemHeight * 2 + 30, // Adjust for layout spacing
//             decoration: BoxDecoration(
//               color: Color(0xff0e235a),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: GridView.builder(
//               padding: const EdgeInsets.all(15),
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: crossAxisCount,
//                 crossAxisSpacing: 10,
//                 mainAxisSpacing: 10,
//               ),
//               itemCount: products.length,
//               itemBuilder: (context, index) {
//                 final product = products[index];
//                 return GestureDetector(
//                   onTap: () => onProductTap(product),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Image.network(
//                           product.imageUrl,
//                           height: gridItemHeight * 0.9, // Responsive image size
//                         ),
//                         const SizedBox(height: 10),
//                         Text(
//                           product.price,
//                           style: TextStyle(
//                             fontSize: constraints.maxWidth * 0.04,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         Text(
//                           product.delivery,
//                           style: TextStyle(
//                             fontSize: constraints.maxWidth * 0.03,
//                             color: Colors.grey,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

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
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Ensuring finite height for GridView
          return Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 37, 61, 121),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
                bottom: Radius.circular(1),
              ),
            ),
            child: SizedBox(
              // Height of the item box
              height: itemHeight * 3.43,
              child: GridView.builder(
                // Smooth the scroller
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 1,
                  childAspectRatio:
                      (constraints.maxWidth - 5 * horizontalPadding) /
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
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(0.5), // Shadow color
                              spreadRadius: 2, // How much the shadow spreads
                              blurRadius: 5, // The blur radius of the shadow
                              offset: Offset(0, 3), // The offset of the shadow
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Stack(
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
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
                                        width: 90,
                                        height: 90,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 82,
                                    left: 70,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 2),
                                      color: Colors.blue,
                                      child: Text(
                                        'New', // Placeholder for the status text
                                        style: const TextStyle(
                                          fontSize: 12,
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
                              height: 120,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      product.source,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      product.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      product.rating != null
                                          ? 'Rating: ${product.rating} (${product.ratingCount} reviews)'
                                          : 'No ratings available',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      product.price,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      product.delivery,
                                      style: const TextStyle(
                                        fontSize: 14,
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

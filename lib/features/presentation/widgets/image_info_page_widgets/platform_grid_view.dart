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
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 20), // Align with TopRowWidget
      child: SizedBox(
        height: 405, // Set a height to make the grid scrollable
        child: GridView.builder(
          physics: const BouncingScrollPhysics(), // Smooth scrolling
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, // 1 column per row
            mainAxisSpacing: 3, // Space between rows
            childAspectRatio: 2.4, // Aspect ratio to create a wide box
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () => onProductTap(product),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    // Container for the image and status text
                    Stack(
                      children: [
                        Container(
                          width: 100, // Fixed width for image
                          height: 100, // Fixed height for the image side
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
                              width: 100,
                              height: 100,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
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
                    // Space between image and details
                    const SizedBox(width: 10),

                    // Separator Line
                    Container(
                      width: 1, // width of separator line
                      height: 120, // height of the separator line
                      color: Colors.grey, // Color separator line
                    ),

                    // Space between separator and details
                    const SizedBox(width: 5),

                    // Product Details
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Source of the product
                            Text(
                              product.source,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            // Title of the product
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
                            // Ratings of the product
                            Text(
                              product.rating != null
                                  ? 'Rating: ${product.rating} (${product.ratingCount} reviews)'
                                  : 'No ratings available',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 5),
                            // Price of the product
                            Text(
                              product.price,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            // Delivery price of the product
                            Text(
                              product.delivery,
                              style: TextStyle(
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
            );
          },
        ),
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

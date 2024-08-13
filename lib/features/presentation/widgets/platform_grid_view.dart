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
    final productCount = products.length;
    // Determine the number of columns based on the product count
    final crossAxisCount = productCount <= 2 ? productCount : 2;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        height: 315, // Adjust the height as needed for layout spacing
        decoration: BoxDecoration(
          color: Color(0xff0e235a), // Container background color
          borderRadius:
              BorderRadius.circular(10), // Rounded corners for the container
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(15),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount, // Number of columns
            crossAxisSpacing: 10, // Spacing between columns
            mainAxisSpacing: 10, // Spacing between rows
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () => onProductTap(product),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Background color of each grid item
                  borderRadius: BorderRadius.circular(
                      10), // Rounded corners for each grid item
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      product.imageUrl,
                      height: 60, // Adjust the image size
                    ),
                    // const SizedBox(height: 10),
                    // Text(
                    //   product.title,
                    //   style: const TextStyle(fontSize: 14, color: Colors.black),
                    //   textAlign: TextAlign.center,
                    // ),
                    const SizedBox(height: 10),
                    Text(
                      product.price,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      product.delivery,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      textAlign: TextAlign.center,
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

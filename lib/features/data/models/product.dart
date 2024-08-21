import 'dart:convert';
import 'package:valuefinder/core/error/failures.dart';

class Product {
  final String title;
  final String source;
  final String link;
  final String price;
  final String delivery;
  final String imageUrl;
  final int position;
  final double? rating;
  final int? ratingCount;
  final String? offers;
  final String? productId;

  Product({
    required this.title,
    required this.source,
    required this.link,
    required this.price,
    required this.delivery,
    required this.imageUrl,
    required this.position,
    this.rating,
    this.ratingCount,
    this.offers,
    this.productId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    try {
      return Product(
        title: json['title'] ?? '',
        source: json['source'] ?? '',
        link: json['link'] ?? '',
        price: json['price'] ?? '',
        delivery: json['delivery'] ?? '',
        imageUrl: json['imageUrl'] ?? '',
        position: json['position'] ?? 0, // Default to 0 if not present
        rating:
            (json['rating'] as num?)?.toDouble(), // Convert rating to double
        ratingCount: json['ratingCount'] as int?,
        offers: json['offers'],
        productId: json['productId'],
      );
    } catch (e) {
      throw ServerFailure('Error parsing product: $e');
    }
  }

  get description => null;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'source': source,
      'link': link,
      'price': price,
      'delivery': delivery,
      'imageUrl': imageUrl,
      'position': position,
      'rating': rating,
      'ratingCount': ratingCount,
      'offers': offers,
      'productId': productId,
    };
  }
}

class ProductResponse {
  final List<Product> products;

  ProductResponse({required this.products});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    try {
      var list = json['products'];
      if (list == null || list is! List) {
        throw FormatException('Invalid or missing "products" key');
      }
      List<Product> productList = (list as List<dynamic>)
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();
      return ProductResponse(products: productList);
    } catch (e) {
      throw ServerFailure('Error parsing product response: $e');
    }
  }
}

// Function to parse the response with error handling
ProductResponse parseProductResponse(String jsonResponse) {
  try {
    final Map<String, dynamic> parsed = jsonDecode(jsonResponse);
    return ProductResponse.fromJson(parsed);
  } catch (e) {
    throw ServerFailure('Failed to parse product response: $e');
  }
}

void debugJson(String jsonResponse) {
  try {
    final parsed = jsonDecode(jsonResponse);
  } catch (e) {
    throw JsonDecodingFailure(message: 'Error decoding JSON: $e');
  }
}

// Define a custom failure for JSON decoding errors
class JsonDecodingFailure extends Failure {
  const JsonDecodingFailure({required String message}) : super(message);
}

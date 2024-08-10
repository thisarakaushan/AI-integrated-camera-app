import 'dart:convert';

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
    return Product(
      title: json['title'] ?? '',
      source: json['source'] ?? '',
      link: json['link'] ?? '',
      price: json['price'] ?? '',
      delivery: json['delivery'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      position: json['position'] ?? 0, // Default to 0 if not present
      rating: (json['rating'] as num?)?.toDouble(), // Convert rating to double
      ratingCount: json['ratingCount'] as int?,
      offers: json['offers'],
      productId: json['productId'],
    );
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
    var list = json['products'];
    if (list == null || list is! List) {
      throw FormatException('Invalid or missing "products" key');
    }
    List<Product> productList = (list as List<dynamic>)
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
    return ProductResponse(products: productList);
  }
}

// Function to parse the response
ProductResponse parseProductResponse(String jsonResponse) {
  final Map<String, dynamic> parsed = jsonDecode(jsonResponse);
  return ProductResponse.fromJson(parsed);
}

void debugJson(String jsonResponse) {
  try {
    final parsed = jsonDecode(jsonResponse);
  } catch (e) {
    print('Error decoding JSON: $e');
  }
}

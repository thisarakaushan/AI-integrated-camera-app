class Product {
  final String title;
  final String source;
  final String link;
  final String price;
  final String delivery;
  final String imageUrl;
  final int size;
  final int position;
  final int? rating;
  final int? ratingCount;

  Product({
    required this.title,
    required this.source,
    required this.link,
    required this.price,
    required this.delivery,
    required this.imageUrl,
    required this.size,
    required this.position,
    this.rating,
    this.ratingCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      title: json['title'],
      source: json['source'],
      link: json['link'],
      price: json['price'],
      delivery: json['delivery'],
      imageUrl: json['imageUrl'],
      size: json['size'],
      position: json['position'],
      rating: json['rating'],
      ratingCount: json['ratingCount'],
    );
  }
}

class ProductResponse {
  final List<Product> products;

  ProductResponse({required this.products});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    var list = json['products'] as List;
    List<Product> productsList = list.map((i) => Product.fromJson(i)).toList();

    return ProductResponse(products: productsList);
  }
}

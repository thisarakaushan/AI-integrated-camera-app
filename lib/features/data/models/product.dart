class Product {
  final String title;
  final String source;
  final String link;
  final String price;
  final String delivery;
  final String imageUrl;
  final int position;
  final int? rating;
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
      title: json['title'],
      source: json['source'],
      link: json['link'],
      price: json['price'],
      delivery: json['delivery'],
      imageUrl: json['imageUrl'],
      position: json['position'],
      rating: json['rating'],
      ratingCount: json['ratingCount'],
      offers: json['offers'],
      productId: json['productId'],
    );
  }
}

class ProductResponse {
  final List<Product> products;

  ProductResponse({required this.products});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    var list = json['products'] as List;
    List<Product> productList = list.map((i) => Product.fromJson(i)).toList();
    return ProductResponse(products: productList);
  }
}

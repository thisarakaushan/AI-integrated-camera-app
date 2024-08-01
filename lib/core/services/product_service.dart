// lib/services/product_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:valuefinder/features/data/models/product.dart';

Future<ProductResponse> fetchProducts(String searchQuery) async {
  final url =
      'https://shopping-s4r2ozb5wq-uc.a.run.app/images?search=$searchQuery';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return ProductResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load products');
  }
}

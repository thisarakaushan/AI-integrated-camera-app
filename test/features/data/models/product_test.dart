import 'package:flutter_test/flutter_test.dart';
import 'package:valuefinder/features/data/models/product.dart';
import 'dart:convert';
import 'dart:io'; // For File operations

void main() {
  group('Product JSON Parsing', () {
    Future<Map<String, dynamic>> loadJson(String path) async {
      print('Loading JSON file from: $path'); // Debug print statement
      final file = File(path);
      final jsonString = await file.readAsString();
      return jsonDecode(jsonString);
    }

    test('Parse Product from JSON', () async {
      final jsonData = await loadJson(
          'test/test_data/product_data/product_with_all_fields.json');
      print('Loaded JSON: $jsonData'); // Debug print statement

      final productResponse = ProductResponse.fromJson(jsonData);

      // Assertions
      expect(productResponse.products.length, 1);

      final product = productResponse.products[0];
      expect(
          product.title, "Vissla - Undefined Lines Eco SS Shirt - Clay - XXL");
      expect(product.source, "Vissla Australia");
      expect(product.link, contains("vissla.com"));
      expect(product.price, "\$89.99");
      expect(product.delivery, "\$4.95 delivery");
      expect(product.imageUrl, startsWith("https://"));
      expect(product.position, 1);
      expect(product.rating, 4.5);
      expect(product.ratingCount, 8);
      expect(product.offers, "2");
      expect(product.productId, "14473362052745828812");
    });

    test('Parse empty product list', () async {
      final jsonData =
          await loadJson('test/test_data/product_data/empty_product_list.json');
      print('Loaded JSON: $jsonData'); // Debug print statement

      final productResponse = ProductResponse.fromJson(jsonData);

      // Assertions
      expect(productResponse.products.isEmpty, true);
    });

    test('Parse Product with missing optional fields', () async {
      final jsonData = await loadJson(
          'test/test_data/product_data/product_with_missing_fields.json');
      print('Loaded JSON: $jsonData'); // Debug print statement

      final productResponse = ProductResponse.fromJson(jsonData);

      // Assertions
      expect(productResponse.products.length, 1);

      final product = productResponse.products[0];
      expect(product.title, "Sample Product");
      expect(product.source, "Example Source");
      expect(product.link, "https://example.com/product");
      expect(product.price, "\$10.00");
      expect(product.delivery, "Free delivery");
      expect(product.imageUrl, "https://example.com/image.jpg");
      expect(product.position, 1);
      expect(product.rating, isNull);
      expect(product.ratingCount, isNull);
      expect(product.offers, isNull);
      expect(product.productId, isNull);
    });
  });
}

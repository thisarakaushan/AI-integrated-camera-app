import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:valuefinder/core/error/failures.dart';
import 'package:valuefinder/features/data/models/product.dart';

Future<Either<Failure, ProductResponse>> fetchProducts(
    String searchQuery) async {
  final url = 'https://shopping-s4r2ozb5wq-uc.a.run.app?keyword=$searchQuery';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return Right(ProductResponse.fromJson(jsonDecode(response.body)));
    } else {
      // Handle different HTTP status codes if needed
      return Left(
          ServerFailure('Failed to load products: ${response.statusCode}'));
    }
  } on http.ClientException {
    return Left(NetworkFailure('Network error occurred'));
  } catch (e) {
    return Left(ServerFailure('Unexpected error occurred: $e'));
  }
}

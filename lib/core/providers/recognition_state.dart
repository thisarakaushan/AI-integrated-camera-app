import 'package:flutter/material.dart';
import 'package:valuefinder/features/data/models/product.dart';

class RecognitionState extends ChangeNotifier {
  String _imageUrl = '';
  String _identifiedObject = '';
  List<Product> _products = [];

  String get imageUrl => _imageUrl;
  String get identifiedObject => _identifiedObject;
  List<Product> get products => _products;

  void setImageUrl(String imageUrl) {
    _imageUrl = imageUrl;
    notifyListeners();
  }

  void setIdentifiedObject(String identifiedObject) {
    _identifiedObject = identifiedObject;
    notifyListeners();
  }

  void setProducts(List<Product> products) {
    _products = products;
    notifyListeners();
  }
}

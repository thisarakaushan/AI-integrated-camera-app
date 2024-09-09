import 'package:flutter/foundation.dart';

class ProcessingPageState extends ChangeNotifier {
  String _textContent = 'Processing...';
  String _otherTextContent = 'We\'re finding the best information for you';

  String get textContent => _textContent;
  String get otherTextContent => _otherTextContent;

  void updateText(String newText, String otherNewText) {
    _textContent = newText;
    _otherTextContent = otherNewText;
    notifyListeners();
  }
}

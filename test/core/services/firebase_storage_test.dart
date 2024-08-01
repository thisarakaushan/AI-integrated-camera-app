import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_storage/firebase_storage.dart';

void main() {
  test('Firebase Storage Upload and Download', () async {
    final FirebaseStorage _storage = FirebaseStorage.instance;

    try {
      Reference ref = _storage.ref().child('test/test_file.txt');

      // Upload a file
      await ref.putString('Hello Firebase Storage!');
      print('File uploaded successfully');

      // Download the file
      String downloadURL = await ref.getDownloadURL();
      print('Download URL: $downloadURL');
    } catch (e) {
      print('Error with Firebase Storage: $e');
    }
  });
}

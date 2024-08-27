import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:valuefinder/firebase_options.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  test('Firebase Storage Upload and Download', () async {
    final FirebaseStorage storage = FirebaseStorage.instance;

    try {
      Reference ref = storage.ref().child('test/test_file.txt');

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

import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:valuefinder/firebase_options.dart';
import 'firebase_test_setup.dart';

void main() {
  setUpAll(() async {
    await setupFirebase(); // Initialize Firebase
  });

  test('Firebase Initialization Test', () async {
    // Your test code here
    expect(
      () async => await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      completes,
    );
  });
}

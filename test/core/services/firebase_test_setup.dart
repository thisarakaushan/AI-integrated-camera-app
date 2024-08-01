import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:valuefinder/firebase_options.dart';

void setupFirebase() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions.android, // Make sure to use appropriate options
  );
}

void main() {
  setUpAll(() async {
    setupFirebase();
  });
}

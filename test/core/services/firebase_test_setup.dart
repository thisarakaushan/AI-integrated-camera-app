import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:valuefinder/firebase_options.dart';

Future<void> setupFirebase() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  try {
    print('Initializing Firebase...');
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print(
        'Firebase initialized with options: ${DefaultFirebaseOptions.currentPlatform}');
  } catch (e) {
    print('Failed to initialize Firebase: $e');
  }
}

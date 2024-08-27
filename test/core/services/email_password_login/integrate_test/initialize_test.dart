import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:valuefinder/firebase_options.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  test('Firebase Authentication Login with Email and Password', () async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      // Replace these with valid credentials for testing
      String testEmail = 'nilantha@excelly.io';
      String testPassword = 'Nila_123';

      // Sign in with email and password
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      );

      // Check if the sign-in was successful
      User? user = userCredential.user;
      expect(user, isNotNull);
      expect(user?.email, equals(testEmail));
      print('User signed in successfully: ${user?.email}');
    } catch (e) {
      print('Error signing in: $e');
    }
  });
}

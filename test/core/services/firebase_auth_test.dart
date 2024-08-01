import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_test_setup.dart'; // Ensure this path is correct

void main() {
  setUpAll(() async { 
    setupFirebase(); // Initialize Firebase before running tests
  });

  test('Firebase Auth Sign-In', () async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      // Test signing in anonymously
      UserCredential userCredential = await _auth.signInAnonymously();
      User? user = userCredential.user;

      if (user != null) {
        expect(user.uid, isNotEmpty); // Check if uid is not empty
        print('Successfully signed in: ${user.uid}');
      } else {
        fail('User is null');
      }
    } catch (e) {
      print('Error signing in: $e');
      fail('Exception occurred: $e'); // Fail the test if there's an exception
    }
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../firebase_test_setup.dart';

void main() {
  setUpAll(() async {
    await setupFirebase();
  });

  test('Firebase Auth Sign-In', () async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      UserCredential userCredential = await auth.signInAnonymously();
      User? user = userCredential.user;

      if (user != null) {
        expect(user.uid, isNotEmpty);
        //print('Successfully signed in: ${user.uid}');
      } else {
        fail('User is null');
      }
    } catch (e) {
      //print('Error signing in: $e');
      fail('Exception occurred: $e');
    }
  });
}

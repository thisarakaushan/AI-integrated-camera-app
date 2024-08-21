import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:valuefinder/firebase_options.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  test('Successful Login with Valid Credentials', () async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      String testEmail = 'nilantha@excelly.io';
      String testPassword = 'Nila_123';

      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      );

      User? user = userCredential.user;
      expect(user, isNotNull);
      expect(user?.email, equals(testEmail));
    } catch (e) {
      fail('Login should succeed, but failed with error: $e');
    }
  });

  test('Login with Incorrect Password', () async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      String testEmail = 'valid@example.com';
      String wrongPassword = 'wrongPassword';

      await auth.signInWithEmailAndPassword(
        email: testEmail,
        password: wrongPassword,
      );

      fail('Login should fail with an incorrect password');
    } catch (e) {
      expect(e, isInstanceOf<FirebaseAuthException>());
      if (e is FirebaseAuthException) {
        expect(e.code, equals('wrong-password'));
      }
    }
  });

  test('Login with Non-existent User', () async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      String nonExistentEmail = 'nonexistent@example.com';
      String password = 'somePassword';

      await auth.signInWithEmailAndPassword(
        email: nonExistentEmail,
        password: password,
      );

      fail('Login should fail for a non-existent user');
    } catch (e) {
      expect(e, isInstanceOf<FirebaseAuthException>());
      if (e is FirebaseAuthException) {
        expect(e.code, equals('user-not-found'));
      }
    }
  });
}

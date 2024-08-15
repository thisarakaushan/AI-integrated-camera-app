import 'package:firebase_auth/firebase_auth.dart';

class AnonymousAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInAnonymously() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      print('Failed to sign in anonymously: $e');
      return null;
    }
  }
}

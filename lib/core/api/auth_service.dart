import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String apiKey = 'AIzaSyAm9ZteqRe39bf8uM2vU9y6P0e-yXdWWWU';
  static const String signInUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey';

  Future<String?> signInWithEmailAndPassword(
      String email, String password) async {
    final response = await http.post(
      Uri.parse(signInUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData['idToken'];
    } else {
      print('Failed to sign in: ${response.body}');
      return null;
    }
  }
}

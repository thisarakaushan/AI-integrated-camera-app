// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class AuthServiceHttp {
//   static const String apiKey = 'AIzaSyAm9ZteqRe39bf8uM2vU9y6P0e-yXdWWWU';
//   static const String signInUrl =
//       'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey';

//   Future<String?> signInWithEmailAndPassword(
//       String email, String password) async {
//     final response = await http.post(
//       Uri.parse(signInUrl),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({
//         'email': email,
//         'password': password,
//         'returnSecureToken': true,
//       }),
//     );

//     if (response.statusCode == 200) {
//       final responseData = json.decode(response.body);
//       return responseData['idToken'];
//     } else {
//       print('Failed to sign in: ${response.body}');
//       return null;
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart'; // Add this for Either type
import 'package:valuefinder/core/error/failures.dart';

class AuthServiceHttp {
  static const String apiKey = 'AIzaSyAm9ZteqRe39bf8uM2vU9y6P0e-yXdWWWU';
  static const String signInUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey';

  Future<Either<Failure, String?>> signInWithEmailAndPassword(
      String email, String password) async {
    try {
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
        return Right(responseData['idToken']);
      } else {
        // Handle specific HTTP error codes if needed
        return Left(ServerFailure('Failed to sign in: ${response.body}'));
      }
    } on http.ClientException {
      return Left(NetworkFailure('Network error occurred'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }
}

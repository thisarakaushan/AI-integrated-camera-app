// import 'package:geolocator/geolocator.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// Future<String> getCountryCode() async {
//   // Request permission and get the current location
//   LocationPermission permission = await Geolocator.requestPermission();
//   if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
//     return 'Permission Denied';
//   }

//   Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

//   // Reverse geocoding to get the country code
//   final response = await http.get(Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=YOUR_GOOGLE_API_KEY'));
//   final Map<String, dynamic> data = jsonDecode(response.body);

//   // Extract the country code
//   String countryCode = '';
//   if (data['results'].isNotEmpty) {
//     for (var component in data['results'][0]['address_components']) {
//       if (component['types'].contains('country')) {
//         countryCode = component['short_name'];
//         break;
//       }
//     }
//   }
//   return countryCode;
// }
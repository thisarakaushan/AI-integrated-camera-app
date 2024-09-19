// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';

// Future<String> determineUserCountry() async {
//   try {
//     // Request permission to access the location
//     LocationPermission permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       throw Exception("Location permission denied");
//     }

//     // Get current location (latitude and longitude)
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     // Reverse geocoding to get the address details from coordinates
//     List<Placemark> placemarks = await placemarkFromCoordinates(
//         position.latitude, position.longitude);

//     if (placemarks.isNotEmpty) {
//       // Extract the country code
//       return placemarks.first.isoCountryCode ?? 'US'; // Default to 'US' if not found
//     } else {
//       throw Exception("Could not determine country");
//     }
//   } catch (e) {
//     print("Error determining user country: $e");
//     return 'US'; // Default to US if there's an error
//   }
// }

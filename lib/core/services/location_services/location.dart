import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'location_permission.dart';

String? cachedCountryCode;

Future<String> getCountryCode() async {
  // Request location permission
  await requestLocationPermission();

  // Try to get geolocation first
  String? countryCode = await getCountryFromGeolocation();
  if (countryCode != null) {
    return countryCode;
  }

  // Fallback to IP-based location if geolocation fails
  return await getCountryFromIP();
}

// Geolocation-based function
Future<String?> getCountryFromGeolocation() async {
  try {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return null; // Fallback to IP-based if services are disabled
    }

    // Check permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied.');
        return null; // Fallback to IP-based if permission is denied
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied.');
      return null;
    }

    // Get current position
    // Position position = await Geolocator.getCurrentPosition(
    //   desiredAccuracy: LocationAccuracy.high,
    // );

    // Define location settings
    LocationSettings locationSettings = AndroidSettings(
      accuracy: LocationAccuracy.high,
      // Minimum distance change (measured in meters) that will trigger the location update
      distanceFilter: 10,
      // Set to true to force the use of location manager
      forceLocationManager: false,
      // Interval duration for updates
      intervalDuration: Duration(seconds: 5),
    );

    // Get current position using the defined settings
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    print(
        'Geolocation obtained: Lat: ${position.latitude}, Lon: ${position.longitude}');

    // Use reverse geocoding API to get country code from latitude and longitude
    final geoResponse = await http.get(Uri.parse(
        'https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=${position.latitude}&longitude=${position.longitude}&localityLanguage=en'));

    if (geoResponse.statusCode == 200) {
      final geoData = json.decode(geoResponse.body);
      print('Geolocation country: ${geoData['countryCode']}');
      return geoData['countryCode']; // Return the country code
    } else {
      print('Failed to get geolocation country.');
      return null;
    }
  } catch (e) {
    print('Error getting geolocation: $e');
    return null; // Fallback to IP-based location on error
  }
}

// IP-based location function
Future<String> getCountryFromIP() async {
  if (cachedCountryCode != null) {
    return cachedCountryCode!;
  }

  await Future.delayed(
      Duration(seconds: 5)); // Adding delay for rate limit issues
  final response = await http.get(Uri.parse('https://ipapi.co/json/'));

  print('Response status: ${response.statusCode}');
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    cachedCountryCode = data['country_code'];
    return cachedCountryCode!;
  } else {
    print('Failed with status: ${response.statusCode}');
    return 'US'; // Default fallback
  }
}

// Future<String> getCountryFromIP() async {
//   if (cachedCountryCode != null) {
//     return cachedCountryCode!;
//   }

//   await Future.delayed(Duration(seconds: 5)); // Delay for rate limit issues
//   final response = await http.get(Uri.parse('https://ipapi.co/json/'));

//   print('Response status: ${response.statusCode}');
//   if (response.statusCode == 200) {
//     final data = json.decode(response.body);
//     cachedCountryCode = data['country_code'];
//     return cachedCountryCode!;
//   } else if (response.statusCode == 429) {
//     print('Rate limit exceeded. Retrying...');
//     await Future.delayed(Duration(seconds: 10)); // Wait longer on rate limit
//     return await getCountryFromIP(); // Retry
//   } else {
//     print('Failed with status: ${response.statusCode}');
//     return 'US'; // Default fallback
//   }
// }
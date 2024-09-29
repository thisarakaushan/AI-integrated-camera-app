import 'package:http/http.dart' as http;
import 'dart:convert';

String? cachedCountryCode;

// IP-based location function
Future<String> getCountryFromIP() async {
  if (cachedCountryCode != null) {
    //print('Using cached country code...');
    return cachedCountryCode!;
  }

  //print('Inside IP based location access function...');
  await Future.delayed(Duration(seconds: 5));
  final response = await http.get(Uri.parse('https://ipapi.co/json/'));
  //final response = await http.get(Uri.parse('https://ipapi.co/json/?key=YOUR_API_KEY'));
  print('Response status: ${response.statusCode}');
  if (response.statusCode == 200) {
    //print('Response Body: ${response.body}');
    final data = json.decode(response.body);
    cachedCountryCode = data['country_code'];
    //return data['country_code'];
    return cachedCountryCode!;
  } else {
    print('Failed with status: ${response.statusCode}');
    return 'US'; // Default fallback
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:valuefinder/firebase_options.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  test('Firebase Analytics Log Event', () async {
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

    try {
      await analytics.logEvent(
        name: 'test_event',
        parameters: {'test_param': 'test_value'},
      );
      print('Event logged successfully');
    } catch (e) {
      print('Error logging event: $e');
    }
  });
}

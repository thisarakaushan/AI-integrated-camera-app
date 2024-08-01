import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

void main() {
  test('Firebase Analytics Log Event', () async {
    final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

    try {
      await _analytics.logEvent(
        name: 'test_event',
        parameters: {'test_param': 'test_value'},
      );
      print('Event logged successfully');
    } catch (e) {
      print('Error logging event: $e');
    }
  });
}

// /Eka/provider/firebase_helper.dart
import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsHelper {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  /// Log custom event
  static Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
    } catch (e) {
      // Tidak crash meskipun gagal kirim log
    }
  }

  /// Log screen view
  static Future<void> setCurrentScreen({required String screenName}) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenName,
      );
    } catch (e) {
      // Tidak crash meskipun gagal kirim log
    }
  }
}

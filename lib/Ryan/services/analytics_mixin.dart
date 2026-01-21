import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'analytics_service.dart';

/// Mixin agar setiap screen otomatis log ke Firebase Analytics
mixin AnalyticsScreenTracking<T extends StatefulWidget> on State<T> {
  static bool _disableForTesting = false;

  /// Setter untuk menonaktifkan analytics saat testing
  static void disableForTesting(bool value) {
    _disableForTesting = value;
  }

  // Lazy initialization untuk menghindari Firebase di testing
  AnalyticsService? _analyticsService;

  /// Getter untuk analytics service dengan penanganan testing
  AnalyticsService get analyticsService {
    if (_disableForTesting) {
      return _NoOpAnalyticsService();
    }

    if (_analyticsService == null) {
      _analyticsService = AnalyticsService(FirebaseAnalytics.instance);
    }
    return _analyticsService!;
  }

  /// Override nama screen
  String get screenName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        analyticsService.logScreenView(screenName);
      } catch (e) {
        // Hanya rethrow error jika bukan di testing mode
        if (!_disableForTesting) {
          rethrow;
        }
        // Di testing mode, ignore error saja
      }
    });
  }
}

class _NoOpAnalyticsService extends AnalyticsService {
  // Constructor panggil parent
  _NoOpAnalyticsService() : super(FirebaseAnalytics.instance);

  @override
  Future<void> logScreenView(String screenName) async {
    // Do nothing - untuk testing
  }

  @override
  Future<void> logEvent(String name, {Map<String, Object>? params}) async {
    // Do nothing - untuk testing
  }
}

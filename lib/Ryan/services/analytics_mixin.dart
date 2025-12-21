import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'analytics_service.dart';

/// Mixin agar setiap screen otomatis log ke Firebase Analytics
mixin AnalyticsScreenTracking<T extends StatefulWidget> on State<T> {
  final AnalyticsService analyticsService = AnalyticsService(FirebaseAnalytics.instance);

  /// Override nama screen
  String get screenName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      analyticsService.logScreenView(screenName);
    });
  }
}

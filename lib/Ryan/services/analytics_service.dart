import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class AnalyticsService {
  final FirebaseAnalytics analytics;

  AnalyticsService(this.analytics);

  /// Untuk integrasi di MaterialApp (navigatorObservers)
  FirebaseAnalyticsObserver getObserver() =>
      FirebaseAnalyticsObserver(analytics: analytics);

  /// Track saat user membuka screen
  Future<void> logScreenView(String screenName) async {
    await analytics.logScreenView(screenName: screenName);
  }

  /// Track event custom
  Future<void> logEvent(String name, {Map<String, Object>? params}) async {
    await analytics.logEvent(name: name, parameters: params);
  }

  /// Like
  Future<void> logLike({
    required String name,
    required String category,
    required String subtype,
  }) async {
    await analytics.logEvent(
      name: 'like_species',
      parameters: {
        'name': name,
        'category': category,
        'subtype': subtype,
      },
    );
  }

  /// Pin
  Future<void> logPin({
    required String name,
    required String category,
    required String subtype,
  }) async {
    await analytics.logEvent(
      name: 'pin_species',
      parameters: {
        'name': name,
        'category': category,
        'subtype': subtype,
      },
    );
  }

  /// Share
  Future<void> logShare({
    required String name,
    required String method,
    required String category,
  }) async {
    await analytics.logShare(
      contentType: 'Species Info',
      itemId: name,
      method: method,
    );
    // Tambahan log event custom
    await analytics.logEvent(
      name: 'share_species',
      parameters: {
        'name': name,
        'category': category,
        'method': method,
      },
    );
  }

  /// Comment
  Future<void> logComment({
    required String name,
    required String content,
    required String category,
  }) async {
    await analytics.logEvent(
      name: 'comment_sent',
      parameters: {
        'name': name,
        'category': category,
        'content': content,
      },
    );
  }

  /// Report (Laporan pengguna)
  Future<void> logReport({
    required String name,
    required String category,
    required String reason,
  }) async {
    await analytics.logEvent(
      name: 'report_species',
      parameters: {
        'name': name,
        'category': category,
        'reason': reason,
      },
    );
  }

  /// Repost (misalnya membagikan ulang konten)
  Future<void> logRepost({
    required String name,
    required String category,
    required String method,
  }) async {
    await analytics.logEvent(
      name: 'repost_species',
      parameters: {
        'name': name,
        'category': category,
        'method': method,
      },
    );
  }

  /// Overlay menu
  Future<void> logOverlayOpened(String overlayName) async {
    await analytics.logEvent(
      name: 'overlay_opened',
      parameters: {'overlay_name': overlayName},
    );
  }
}

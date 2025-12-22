import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'dart:async';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;
  
  // Session tracking
  static DateTime? _sessionStartTime;
  static int _interactionCount = 0;
  static Timer? _heartbeatTimer;
  
  // Engagement metrics
  static DateTime? _lastInteractionTime;
  static final Map<String, int> _featureUsage = {};
  static final Map<String, int> _contentViews = {};
  
  // Initialize analytics service
  static Future<void> initialize() async {
    await _crashlytics.setCrashlyticsCollectionEnabled(true);
    
    // Start session
    _startSession();
    
    print('✅ Analytics Service: Initialized');
  }
  
  // Session Management
  static void _startSession() {
    _sessionStartTime = DateTime.now();
    _interactionCount = 0;
    
    // Heartbeat every minute
    _heartbeatTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _logHeartbeat();
    });
    
    _logEvent('session_start', {'timestamp': _sessionStartTime!.toIso8601String()});
  }
  
  static void _endSession() {
    if (_sessionStartTime != null) {
      final sessionDuration = DateTime.now().difference(_sessionStartTime!);
      
      _logEvent('session_end', {
        'duration_seconds': sessionDuration.inSeconds.toString(),
        'interaction_count': _interactionCount.toString(),
        'feature_usage_count': _featureUsage.length.toString(),
      });
      
      _sessionStartTime = null;
      _interactionCount = 0;
      _heartbeatTimer?.cancel();
    }
  }
  
  static void _logHeartbeat() {
    _logEvent('session_heartbeat', {
      'session_duration_minutes': _sessionStartTime != null 
          ? DateTime.now().difference(_sessionStartTime!).inMinutes.toString() 
          : '0',
      'total_interactions': _interactionCount.toString(),
    });
  }
  
  // PERBAIKAN: Gunakan method yang lebih sederhana tanpa parameter complex
  static Future<void> _logEvent(String name, Map<String, String> parameters) async {
    try {
      await _analytics.logEvent(
        name: name,
        parameters: parameters,
      );
      print('📊 Analytics: $name - $parameters');
    } catch (e) {
      print('❌ Analytics Error: $e');
      _recordError(e, StackTrace.current, reason: 'analytics_log_failed');
    }
  }
  
  // Public methods for tracking - SEMUA PARAMETER DIUBAH KE STRING
  static void trackInteraction(String interactionType) {
    _interactionCount++;
    _lastInteractionTime = DateTime.now();
    
    _logEvent('user_interaction', {
      'type': interactionType,
      'total_interactions': _interactionCount.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  static void trackFeatureUsage(String featureName) {
    _featureUsage[featureName] = (_featureUsage[featureName] ?? 0) + 1;
    
    _logEvent('feature_used', {
      'feature_name': featureName,
      'usage_count': _featureUsage[featureName].toString(),
      'total_features_used': _featureUsage.length.toString(),
    });
  }
  
  static void trackContentView(String contentType, String contentId) {
    _contentViews[contentId] = (_contentViews[contentId] ?? 0) + 1;
    
    _logEvent('content_view', {
      'content_type': contentType,
      'content_id': contentId,
      'view_count': _contentViews[contentId].toString(),
      'total_unique_content': _contentViews.length.toString(),
    });
  }
  
  static void trackPerformance(String operation, int milliseconds) {
    _logEvent('performance_timing', {
      'operation': operation,
      'duration_ms': milliseconds.toString(),
      'threshold_exceeded': (milliseconds > 2000).toString(),
    });
  }
  
  static void trackError(String errorType, String errorMessage, {String? context}) {
    _logEvent('error_occurred', {
      'error_type': errorType,
      'error_message': errorMessage,
      'context': context ?? 'unknown',
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  static void trackNavigation(String from, String to) {
    _logEvent('navigation', {
      'from_screen': from,
      'to_screen': to,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  static Future<void> _recordError(dynamic error, StackTrace stackTrace, {String? reason}) async {
    try {
      await _crashlytics.recordError(
        error,
        stackTrace,
        reason: reason ?? 'unhandled_error',
        fatal: false,
      );
    } catch (e) {
      print('❌ Crashlytics Error: $e');
    }
  }
  
  // User behavior tracking
  static void trackSearch(String query, String context) {
    _logEvent('search_performed', {
      'query': query,
      'context': context,
      'query_length': query.length.toString(),
      'has_results': 'true',
    });
  }
  
  static void trackRefresh(String context) {
    _logEvent('refresh_action', {
      'context': context,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  // Cleanup
  static void dispose() {
    _endSession();
    _heartbeatTimer?.cancel();
  }
}
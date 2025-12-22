// lib/notification_service.dart
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ============ NOTIFICATION MODEL ============
class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final Map<String, dynamic> data;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.data,
    this.isRead = false,
  });

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'timestamp': timestamp.toIso8601String(),
      'data': data,
      'isRead': isRead,
    };
  }

  // Create from Map
  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      id: map['id'] as String,
      title: map['title'] as String,
      body: map['body'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      data: Map<String, dynamic>.from(map['data'] as Map),
      isRead: map['isRead'] as bool,
    );
  }
}

// ============ NOTIFICATION SERVICE ============
class NotificationService extends ChangeNotifier {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final List<AppNotification> _notifications = [];
  
  bool _permissionDeniedForever = false;
  bool _fcmInitialized = false;
  bool _permissionGranted = false;
  String? _fcmToken;
  
  static const String _storageKey = 'stored_notifications';
  SharedPreferences? _prefs;

  List<AppNotification> get notifications => List.unmodifiable(_notifications);
  int get unreadCount => _notifications.where((n) => !n.isRead).length;
  bool get isPermissionDeniedForever => _permissionDeniedForever;
  bool get isPermissionGranted => _permissionGranted;

  // ============ FCM INITIALIZATION ============
  Future<void> initialize() async {
    try {
      print('🔔 Initializing FCM...');
      
      // Initialize SharedPreferences
      await _initializeStorage();
      
      await _checkPermissionStatus();
      await _getFCMToken();
      await _setupFCMHandlers();
      
      _fcmInitialized = true;
      print('✅ FCM initialized. Total notifications: ${_notifications.length}');
      
    } catch (e) {
      print('❌ FCM Error: $e');
    }
  }

  Future<void> _initializeStorage() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      if (_prefs == null) return;
      
      final jsonString = _prefs!.getString(_storageKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> jsonList = json.decode(jsonString);
        _notifications.clear();
        
        for (var jsonItem in jsonList) {
          try {
            final notification = AppNotification.fromMap(jsonItem);
            _notifications.add(notification);
          } catch (e) {
            print('❌ Error loading notification: $e');
          }
        }
        
        print('📂 Loaded ${_notifications.length} notifications from storage');
      }
    } catch (e) {
      print('❌ Error loading notifications from storage: $e');
    }
  }

  Future<void> _saveNotifications() async {
    try {
      if (_prefs == null) return;
      
      final jsonList = _notifications.map((n) => n.toMap()).toList();
      final jsonString = json.encode(jsonList);
      await _prefs!.setString(_storageKey, jsonString);
      
      print('💾 Saved ${_notifications.length} notifications to storage');
    } catch (e) {
      print('❌ Error saving notifications: $e');
    }
  }

  Future<void> _getFCMToken() async {
    _fcmToken = await _fcm.getToken();
    if (_fcmToken != null) {
      print('🔑 FCM Token: ${_fcmToken!.substring(0, 30)}...');
    }
  }

  Future<void> _checkPermissionStatus() async {
    final status = await Permission.notification.status;
    _permissionDeniedForever = status.isPermanentlyDenied;
    _permissionGranted = status.isGranted;
    print('📱 Permission Status: $status (Granted: $_permissionGranted)');
  }

  Future<void> _setupFCMHandlers() async {
    // Request permission
    final settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    
    print('📱 FCM Permission settings: $settings');

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📱 Foreground notification received');
      _addNotification(message);
    });

    // Background/terminated messages
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('👆 Notification opened from background');
      _addNotification(message);
    });

    // Get initial message
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      print('📱 Initial notification found');
      _addNotification(initialMessage);
    }
  }

  // ============ NOTIFICATION MANAGEMENT ============
  void _addNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification != null) {
      final newNotification = AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: notification.title ?? 'Notifikasi Baru',
        body: notification.body ?? '',
        timestamp: DateTime.now(),
        data: message.data,
      );
      
      _notifications.insert(0, newNotification);
      await _saveNotifications();
      notifyListeners();
      print('✅ Notification added: ${newNotification.title}');
    }
  }

  // Method untuk test manual
  void addTestNotification() async {
    final testNotification = AppNotification(
      id: 'test_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Test Notification',
      body: 'This is a manual test notification. Tap to see details.',
      timestamp: DateTime.now(),
      data: {
        'type': 'test', 
        'source': 'manual',
        'animal_name': 'Paus Biru',
        'message': 'Testing notification system'
      },
    );
    
    _notifications.insert(0, testNotification);
    await _saveNotifications();
    notifyListeners();
    print('🧪 Test notification added');
  }

  void markAsRead(String id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      await _saveNotifications();
      notifyListeners();
    }
  }

  void deleteNotification(String id) async {
    _notifications.removeWhere((n) => n.id == id);
    await _saveNotifications();
    notifyListeners();
  }

  void clearAll() async {
    _notifications.clear();
    await _saveNotifications();
    notifyListeners();
  }

  // Clean up old notifications (older than 30 days)
  Future<void> cleanupOldNotifications() async {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    _notifications.removeWhere((n) => n.timestamp.isBefore(thirtyDaysAgo));
    await _saveNotifications();
    notifyListeners();
    print('🧹 Cleaned up old notifications');
  }

  // ============ PERMISSION HANDLING ============
  Future<bool> checkAndUpdatePermission() async {
    await _checkPermissionStatus();
    return _permissionGranted;
  }

  Future<void> openPermissionSettings() async {
    await openAppSettings();
    await Future.delayed(const Duration(seconds: 1));
    await _checkPermissionStatus();
    notifyListeners();
  }
}
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sopan_santun_app/Eka/activity/Profile_Page.dart';
import 'package:sopan_santun_app/Ryan/screens/home_screen.dart';
import 'SeeAllScreen.dart';
import 'DetailScreen.dart';
import 'package:flutter/foundation.dart';
import '../Fauzan/News/home_screen.dart';
import '../Fauzan/Event/EventPage.dart';
import '../Provider/hewan_provider.dart';
import '../legend.dart';
import '../Provider/analytics_service.dart';
import '../Provider/analytics_wrapper.dart';

// Background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('📨 [BACKGROUND] Notification received while app was closed/terminated');
  print('📨 Title: ${message.notification?.title}');
  print('📨 Body: ${message.notification?.body}');
  print('📨 Data: ${message.data}');
  
  // Cek apakah ini notification untuk fitur aplikasi
  if (message.data['notification_type'] == 'feature_announcement' ||
      message.data['notification_type'] == 'app_update' ||
      message.data['notification_type'] == 'tip_of_the_day' ||
      message.data['notification_type'] == 'educational_content') {
    
    // Simpan notifikasi fitur untuk ditampilkan saat app dibuka
    await _saveFeatureNotification(message);
  }
}

// Helper untuk simpan notifikasi fitur
Future<void> _saveFeatureNotification(RemoteMessage message) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    
    // Baca notifikasi fitur yang tersimpan
    final savedFeatureNotificationsJson = prefs.getStringList('feature_notifications') ?? [];
    List<Map<String, dynamic>> savedNotifications = [];
    
    // Decode JSON
    for (final jsonString in savedFeatureNotificationsJson) {
      try {
        final parts = jsonString.split('|||');
        if (parts.length >= 6) {
          savedNotifications.add({
            'id': parts[0],
            'title': parts[1],
            'message': parts[2],
            'timestamp': parts[3],
            'type': parts[4],
            'action_url': parts[5],
            'feature_name': parts.length > 6 ? parts[6] : '',
            'read': false, // Default unread untuk notifikasi baru
          });
        }
      } catch (e) {
        print('❌ Error parsing feature notification: $e');
      }
    }
    
    // Tambahkan notifikasi fitur baru (default unread)
    final newId = 'feature_${DateTime.now().millisecondsSinceEpoch}';
    final notificationString = [
      newId,
      message.notification?.title ?? 'Fitur Baru!',
      message.notification?.body ?? 'Cek fitur terbaru kami',
      DateTime.now().toIso8601String(),
      message.data['notification_type'] ?? 'feature_announcement',
      message.data['action_url'] ?? '',
      message.data['feature_name'] ?? '',
      'false', // read status: false (unread)
    ].join('|||');
    
    savedFeatureNotificationsJson.add(notificationString);
    
    // Simpan kembali (maksimal 20 notifikasi fitur)
    if (savedFeatureNotificationsJson.length > 20) {
      savedFeatureNotificationsJson.removeAt(0);
    }
    
    await prefs.setStringList('feature_notifications', savedFeatureNotificationsJson);
    print('💾 Feature notification saved: ${message.notification?.title}');
    
  } catch (e) {
    print('❌ Error saving feature notification: $e');
  }
}

class HomeScreen extends StatefulWidget {
  final String uid;
  const HomeScreen(this.uid, {super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeContent(),
    FauzanNewsHomeScreen(),
    EventLautPage(),
    RyanHomeScreen(),
    MyProfile(),
  ];

  void _onItemTapped(int index) {
    final List<String> pageNames = [
      'Beranda',
      'Berita',
      'Event',
      'Edukasi',
      'Profil',
    ];
    AnalyticsService.trackNavigation(
      pageNames[_selectedIndex],
      pageNames[index],
    );
    AnalyticsService.trackFeatureUsage('bottom_navigation_${pageNames[index]}');

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize analytics service
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AnalyticsService.initialize();
    });
  }

  @override
  void dispose() {
    AnalyticsService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HewanProvider(),
      child: AnalyticsWrapper(
        screenName: 'HomeScreen',
        child: Scaffold(
          body: _pages[_selectedIndex],
          bottomNavigationBar: _buildBottomNavBar(context),
        ),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavBar(BuildContext context) {
    final theme = Theme.of(context);
    return BottomNavigationBar(
      backgroundColor: theme.colorScheme.surface,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: theme.colorScheme.primary,
      unselectedItemColor: theme.unselectedWidgetColor,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(fontSize: 12),
      unselectedLabelStyle: TextStyle(fontSize: 12),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article_outlined),
          activeIcon: Icon(Icons.article),
          label: 'Berita',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event_outlined),
          activeIcon: Icon(Icons.event),
          label: 'Event',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school_outlined),
          activeIcon: Icon(Icons.school),
          label: 'Edukasi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  // Firebase Services
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  // Remote Config Values
  String _welcomeTitle = "Selamat Datang!";
  String _welcomeMessage = "Temukan keanekaragaman hayati laut di seluruh dunia";
  bool _isConfigLoaded = false;

  // Notification State
  final List<Map<String, dynamic>> _featureNotifications = [];
  int _permissionRequestCount = 0;
  bool _permissionDeniedForever = false;
  bool _permissionGranted = false;
  bool _showPermissionBanner = false;
  
  // Timer untuk auto-cleanup
  Timer? _cleanupTimer;

  @override
  void initState() {
    super.initState();

    // Analytics dengan service baru
    AnalyticsService.trackFeatureUsage('home_content');
    AnalyticsService.trackInteraction('screen_view_home');

    // Data loading existing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<HewanProvider>();
      if (provider.apiAnimals.isEmpty && !provider.isLoadingApi) {
        print('🔄 HomeContent: Memuat data dari API...');
        _trackDataLoading(provider);
      }
    });

    // Initialize Firebase services
    _initializeFirebaseServices();
  }

  @override
  void dispose() {
    _cleanupTimer?.cancel();
    super.dispose();
  }

  // Setup Firebase services
  Future<void> _initializeFirebaseServices() async {
    await _setupRemoteConfig();
    await _setupPushNotifications();
    await _loadSavedFeatureNotifications();
    _startAutoCleanupTimer();
  }

  // Load saved feature notifications from SharedPreferences
  Future<void> _loadSavedFeatureNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedNotificationsJson = prefs.getStringList('feature_notifications') ?? [];
      
      List<Map<String, dynamic>> loadedNotifications = [];
      
      for (final jsonString in savedNotificationsJson) {
        try {
          final parts = jsonString.split('|||');
          if (parts.length >= 7) {
            final timestamp = DateTime.parse(parts[3]);
            final ageInHours = DateTime.now().difference(timestamp).inHours;
            
            // Hapus notifikasi fitur yang sudah lebih dari 7 hari
            if (ageInHours < (24 * 7)) { // 7 hari
              loadedNotifications.add({
                'id': parts[0],
                'title': parts[1],
                'message': parts[2],
                'timestamp': timestamp,
                'type': parts[4],
                'action_url': parts[5],
                'feature_name': parts[6],
                'read': parts.length > 7 ? parts[7] == 'true' : false,
              });
            }
          }
        } catch (e) {
          print('❌ Error parsing feature notification: $e');
        }
      }
      
      // Simpan notifikasi fitur yang masih valid
      await _saveValidFeatureNotifications(loadedNotifications);
      
      // Load ke memory
      setState(() {
        _featureNotifications.clear();
        _featureNotifications.addAll(loadedNotifications);
      });
      
      print('📂 Loaded ${loadedNotifications.length} feature notifications from storage');
      print('📂 Unread notifications: ${loadedNotifications.where((n) => !n['read']).length}');
      
    } catch (e) {
      print('❌ Error loading feature notifications: $e');
    }
  }

  // Save valid feature notifications to SharedPreferences
  Future<void> _saveValidFeatureNotifications(List<Map<String, dynamic>> notifications) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> jsonList = [];
      
      for (final notification in notifications) {
        final timestamp = notification['timestamp'] as DateTime;
        jsonList.add([
          notification['id'],
          notification['title'],
          notification['message'],
          timestamp.toIso8601String(),
          notification['type'],
          notification['action_url'] ?? '',
          notification['feature_name'] ?? '',
          notification['read'].toString(), // Simpan status read
        ].join('|||'));
      }
      
      await prefs.setStringList('feature_notifications', jsonList);
      print('💾 Saved ${notifications.length} notifications to storage');
    } catch (e) {
      print('❌ Error saving feature notifications: $e');
    }
  }

  // Mark a single notification as read
  Future<void> _markNotificationAsRead(String notificationId) async {
    final index = _featureNotifications.indexWhere((n) => n['id'] == notificationId);
    if (index != -1 && !_featureNotifications[index]['read']) {
      setState(() {
        _featureNotifications[index]['read'] = true;
      });
      
      await _saveValidFeatureNotifications(_featureNotifications);
      AnalyticsService.trackInteraction('notification_marked_as_read');
      print('✅ Marked notification as read: $notificationId');
    }
  }

  // Start auto cleanup timer (setiap 1 jam)
  void _startAutoCleanupTimer() {
    _cleanupTimer = Timer.periodic(Duration(hours: 1), (timer) {
      _cleanupOldFeatureNotifications();
    });
  }

  // Cleanup feature notifications older than 7 days
  Future<void> _cleanupOldFeatureNotifications() async {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(Duration(days: 7));
    
    final validNotifications = _featureNotifications.where((notification) {
      final timestamp = notification['timestamp'] as DateTime;
      return timestamp.isAfter(sevenDaysAgo);
    }).toList();
    
    if (validNotifications.length < _featureNotifications.length) {
      setState(() {
        _featureNotifications.clear();
        _featureNotifications.addAll(validNotifications);
      });
      
      await _saveValidFeatureNotifications(validNotifications);
      print('🧹 Cleaned up old feature notifications');
    }
  }

  void _trackDataLoading(HewanProvider provider) {
    final stopwatch = Stopwatch()..start();

    provider
        .fetchAnimalsFromAPI()
        .then((_) {
          stopwatch.stop();
          AnalyticsService.trackPerformance(
            'data_loading_api',
            stopwatch.elapsedMilliseconds,
          );

          if (provider.apiError != null) {
            AnalyticsService.trackError(
              'api_error',
              provider.apiError!,
              context: 'home_content_loading',
            );
          } else {
            AnalyticsService.trackInteraction('data_loaded_success');
            AnalyticsService.trackFeatureUsage('animal_data_loaded');
          }
        })
        .catchError((error) {
          AnalyticsService.trackError(
            'api_error_catch',
            error.toString(),
            context: 'home_content_loading',
          );
        });
  }

  // Setup Remote Config dengan periodic updates
  Future<void> _setupRemoteConfig() async {
    try {
      final stopwatch = Stopwatch()..start();

      await _remoteConfig.setDefaults({
        'welcome_title': _welcomeTitle,
        'welcome_message': _welcomeMessage,
      });

      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: Duration.zero,
        ),
      );

      await _remoteConfig.fetchAndActivate();
      _updateFromRemoteConfig();

      stopwatch.stop();
      AnalyticsService.trackPerformance(
        'remote_config_load',
        stopwatch.elapsedMilliseconds,
      );
      AnalyticsService.trackFeatureUsage('remote_config_loaded');

      print('✅ Remote Config: Initial load successful');

      // Periodic updates setiap 10 menit
      _startPeriodicConfigUpdates();
    } catch (e) {
      AnalyticsService.trackError('remote_config_error', e.toString());
      print('❌ Remote Config Error: $e');
      _isConfigLoaded = true;
    }
  }

  // Periodic updates untuk real-time changes
  void _startPeriodicConfigUpdates() {
    Future.delayed(Duration(minutes: 10), () {
      if (mounted) {
        try {
          _remoteConfig.fetchAndActivate().then((updated) {
            if (updated) {
              AnalyticsService.trackInteraction('remote_config_updated');
              print('🔄 Remote Config: Periodic update detected changes');
              _updateFromRemoteConfig();
            }
            _startPeriodicConfigUpdates();
          });
        } catch (e) {
          AnalyticsService.trackError(
            'remote_config_periodic_error',
            e.toString(),
          );
          print('❌ Remote Config Periodic Update Error: $e');
          _startPeriodicConfigUpdates();
        }
      }
    });
  }

  // Refresh method untuk pull-to-refresh
  Future<void> _refreshAllData() async {
    AnalyticsService.trackRefresh('home_screen_pull');
    AnalyticsService.trackInteraction('pull_to_refresh');

    print('🔄 Refresh: Memuat ulang semua data...');

    try {
      final stopwatch = Stopwatch()..start();

      // 1. Refresh Remote Config
      final configUpdated = await _remoteConfig.fetchAndActivate();
      if (configUpdated) {
        _updateFromRemoteConfig();
        AnalyticsService.trackFeatureUsage('remote_config_refreshed');
        print('✅ Remote Config: Updated via pull-to-refresh');
      }

      // 2. Refresh animal data dari API
      final provider = context.read<HewanProvider>();
      if (!provider.isLoadingApi) {
        await provider.fetchAnimalsFromAPI();
        AnalyticsService.trackFeatureUsage('animal_data_refreshed');
        print('✅ Animal Data: Refreshed via pull-to-refresh');
      }

      // 3. Cleanup old feature notifications
      await _cleanupOldFeatureNotifications();

      // 4. Re-check permission status setelah refresh
      await _checkAndUpdatePermissionStatus();

      stopwatch.stop();
      AnalyticsService.trackPerformance(
        'pull_refresh_complete',
        stopwatch.elapsedMilliseconds,
      );
    } catch (e) {
      AnalyticsService.trackError('refresh_error', e.toString());
      print('❌ Refresh Error: $e');
    }
  }

  // Cek dan update permission status
  Future<void> _checkAndUpdatePermissionStatus() async {
    try {
      final permissionStatus = await Permission.notification.status;
      
      print('🔄 Checking permission status: $permissionStatus');
      
      setState(() {
        _permissionGranted = permissionStatus.isGranted;
        _permissionDeniedForever = permissionStatus.isPermanentlyDenied;
        
        // LOGIKA YANG BENAR UNTUK BANNER:
        // 1. Tampilkan banner jika permission BELUM diberikan
        // 2. Tampilkan banner jika permission DITOLAK selamanya (untuk show "Buka Pengaturan")
        // 3. Jangan tampilkan banner jika permission SUDAH diberikan
        _showPermissionBanner = !_permissionGranted;
        
        print('📱 Permission Granted: $_permissionGranted');
        print('📱 Permission Denied Forever: $_permissionDeniedForever');
        print('📱 Show Banner: $_showPermissionBanner');
      });
      
    } catch (e) {
      print('❌ Error checking permission status: $e');
    }
  }

  void _updateFromRemoteConfig() {
    if (mounted) {
      setState(() {
        _welcomeTitle = _remoteConfig.getString('welcome_title');
        _welcomeMessage = _remoteConfig.getString('welcome_message');
        _isConfigLoaded = true;
      });
      AnalyticsService.trackInteraction('ui_updated_remote_config');
      print('🔄 UI Updated from Remote Config: "$_welcomeTitle"');
    }
  }

  // FCM setup untuk notifikasi fitur aplikasi
  Future<void> _setupPushNotifications() async {
    try {
      // Load permission request count dari SharedPreferences
      await _loadPermissionRequestCount();
      
      // Cek status permission
      final permissionStatus = await Permission.notification.status;
      
      setState(() {
        _permissionGranted = permissionStatus.isGranted;
        _permissionDeniedForever = permissionStatus.isPermanentlyDenied;
        
        // LOGIKA YANG BENAR: 
        // Tampilkan banner jika permission BELUM diberikan
        // Ini termasuk jika ditolak selamanya (akan tampilkan "Buka Pengaturan")
        _showPermissionBanner = !_permissionGranted;
      });
      
      print('📱 Initial Permission Status: $permissionStatus');
      print('📱 Initial Permission Granted: $_permissionGranted');
      print('📱 Initial Permission Denied Forever: $_permissionDeniedForever');
      print('📱 Initial Show Permission Banner: $_showPermissionBanner');
      print('📱 Initial Permission Request Count: $_permissionRequestCount');
      
      // Setup Firebase Cloud Messaging dengan benar
      await _setupFirebaseCloudMessaging();
      
    } catch (e) {
      AnalyticsService.trackError('notification_setup_error', e.toString());
      print('❌ Notification Setup Error: $e');
    }
  }

  // Setup Firebase Cloud Messaging dengan benar
  Future<void> _setupFirebaseCloudMessaging() async {
    try {
      // Dapatkan FCM Token
      final token = await _fcm.getToken();
      print('🔑 FCM Token: $token');

      // Setup Android Notification Channel
      await _fcm.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      
      // Setup background handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      
      // Handle incoming notifications - FOREGROUND
      FirebaseMessaging.onMessage.listen(_handleIncomingForegroundNotification);
      
      // Handle when notification opens the app (app dibuka dari notification)
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationOpenedApp);
      
      // Get initial message saat app dibuka dari terminated state
      final initialMessage = await _fcm.getInitialMessage();
      if (initialMessage != null) {
        print('📱 App opened from terminated state via notification');
        await _handleNotificationOpenedApp(initialMessage);
      }

      print('✅ Firebase Cloud Messaging setup successful');
      
    } catch (e) {
      AnalyticsService.trackError('fcm_setup_error', e.toString());
      print('❌ FCM Setup Error: $e');
    }
  }

  // Load permission request count dari SharedPreferences
  Future<void> _loadPermissionRequestCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _permissionRequestCount = prefs.getInt('permission_request_count') ?? 0;
      print('📱 Loaded permission request count: $_permissionRequestCount');
    } catch (e) {
      print('❌ Error loading permission request count: $e');
    }
  }

  // Save permission request count ke SharedPreferences
  Future<void> _savePermissionRequestCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('permission_request_count', _permissionRequestCount);
      print('💾 Saved permission request count: $_permissionRequestCount');
    } catch (e) {
      print('❌ Error saving permission request count: $e');
    }
  }

  // Minta permission untuk notifikasi
  Future<void> _requestNotificationPermission() async {
    try {
      // Increment counter
      _permissionRequestCount++;
      await _savePermissionRequestCount();
      
      print('📱 Requesting permission (attempt $_permissionRequestCount)');
      
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
      
      final isGranted = settings.authorizationStatus == AuthorizationStatus.authorized;
      
      // Get updated status
      final updatedStatus = await Permission.notification.status;
      
      print('📱 After request - Permission status: $updatedStatus');
      print('📱 After request - Is granted: $isGranted');
      print('📱 After request - Is permanently denied: ${updatedStatus.isPermanentlyDenied}');
      
      setState(() {
        _permissionGranted = isGranted;
        _permissionDeniedForever = updatedStatus.isPermanentlyDenied;
        
        // LOGIKA YANG BENAR:
        // 1. Jika permission diberikan -> HILANGKAN BANNER
        if (isGranted) {
          _showPermissionBanner = false;
          print('✅ Permission granted - Hiding banner');
        } 
        // 2. Jika ditolak -> TAMPILKAN BANNER (akan otomatis show "Buka Pengaturan" jika sudah 2x)
        else {
          _showPermissionBanner = true;
          print('❌ Permission denied - Showing banner');
        }
      });
      
      if (_permissionGranted) {
        AnalyticsService.trackFeatureUsage('push_notifications_enabled');
        
        // Setup FCM setelah permission diberikan
        await _setupFirebaseCloudMessaging();
        
        // Tampilkan snackbar konfirmasi
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Notifikasi telah diaktifkan!'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        AnalyticsService.trackFeatureUsage('push_notifications_denied');
        print('❌ Notification permission denied');
        
        // Cek jika sudah ditolak 2 kali
        if (_permissionRequestCount >= 2) {
          print('⚠️ User has denied permission 2 times');
        }
      }
      
    } catch (e) {
      print('❌ Error requesting notification permission: $e');
    }
  }

  // Handle incoming foreground notification
  Future<void> _handleIncomingForegroundNotification(RemoteMessage message) async {
    print('📱 [FOREGROUND] Notification received');
    print('📱 Title: ${message.notification?.title}');
    print('📱 Body: ${message.notification?.body}');
    print('📱 Data: ${message.data}');
    
    // Add to feature notifications
    await _addFeatureNotification(
      title: message.notification?.title ?? 'Fitur Baru!',
      message: message.notification?.body ?? 'Ada fitur baru untuk Anda',
      type: message.data['notification_type'] ?? 'feature_announcement',
      actionUrl: message.data['action_url'],
      featureName: message.data['feature_name'],
    );
    
    // Show snackbar untuk memberi tahu user
    _showNotificationSnackbar(
      message.notification?.title ?? 'Notifikasi',
      message.notification?.body ?? '',
      message.data,
    );
  }

  // Handle notification opened app (app dibuka dari notification)
  Future<void> _handleNotificationOpenedApp(RemoteMessage message) async {
    print('👆 [NOTIFICATION OPENED] App opened from notification');
    print('👆 Title: ${message.notification?.title}');
    print('👆 Body: ${message.notification?.body}');
    print('👆 Data: ${message.data}');
    
    // Add to feature notifications
    await _addFeatureNotification(
      title: message.notification?.title ?? 'Fitur Baru!',
      message: message.notification?.body ?? 'Ada fitur baru untuk Anda',
      type: message.data['notification_type'] ?? 'feature_announcement',
      actionUrl: message.data['action_url'],
      featureName: message.data['feature_name'],
    );
    
    // Navigate ke halaman notifikasi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showFeatureNotificationsScreen();
    });
  }

  // Show notification snackbar
  void _showNotificationSnackbar(String title, String message, Map<String, dynamic> data) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              message,
              style: TextStyle(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        duration: Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Lihat',
          onPressed: () => _showFeatureNotificationsScreen(),
        ),
      ),
    );
  }

  // Add feature notification dengan save ke storage
  Future<void> _addFeatureNotification({
    required String title,
    required String message,
    String type = 'feature_announcement',
    String? actionUrl,
    String? featureName,
  }) async {
    final newNotification = {
      'id': 'feature_${DateTime.now().millisecondsSinceEpoch}',
      'title': title,
      'message': message,
      'timestamp': DateTime.now(),
      'type': type,
      'action_url': actionUrl ?? '',
      'feature_name': featureName ?? '',
      'read': false, // Default unread saat notifikasi baru diterima
    };
    
    setState(() {
      _featureNotifications.insert(0, newNotification);
    });
    
    AnalyticsService.trackFeatureUsage('feature_notification_received');
    
    // Save to SharedPreferences
    await _saveValidFeatureNotifications(_featureNotifications);
    
    print('✅ Feature notification added to list: $title (unread)');
  }

  // Show feature announcement dialog
  void _showFeatureAnnouncementDialog(String title, String message, String featureName, String? actionUrl) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.new_releases, color: Colors.amber),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (featureName.isNotEmpty) ...[
              Text(
                'Fitur: $featureName',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: 8),
            ],
            Text(
              message,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup'),
          ),
          if (actionUrl != null && actionUrl.isNotEmpty)
            ElevatedButton(
              onPressed: () {
                AnalyticsService.trackInteraction('feature_explore_clicked');
                Navigator.pop(context);
                // Navigate berdasarkan actionUrl
                _handleFeatureAction(actionUrl, featureName);
              },
              child: Text('Jelajahi Fitur'),
            ),
        ],
      ),
    );
  }

  // Handle feature action
  void _handleFeatureAction(String actionUrl, String featureName) {
    AnalyticsService.trackFeatureUsage('feature_explored_$featureName');
    
    // Parse actionUrl untuk menentukan navigasi
    if (actionUrl.startsWith('screen://')) {
      final screen = actionUrl.replaceFirst('screen://', '');
      switch (screen) {
        case 'events':
          final homeScreenState = context.findRootAncestorStateOfType<_HomeScreenState>();
          if (homeScreenState != null) {
            homeScreenState._onItemTapped(2); // Event page index
          }
          break;
        case 'education':
          final homeScreenState = context.findRootAncestorStateOfType<_HomeScreenState>();
          if (homeScreenState != null) {
            homeScreenState._onItemTapped(3); // Edukasi page index
          }
          break;
        case 'news':
          final homeScreenState = context.findRootAncestorStateOfType<_HomeScreenState>();
          if (homeScreenState != null) {
            homeScreenState._onItemTapped(1); // Berita page index
          }
          break;
        case 'profile':
          final homeScreenState = context.findRootAncestorStateOfType<_HomeScreenState>();
          if (homeScreenState != null) {
            homeScreenState._onItemTapped(4); // Profile page index
          }
          break;
      }
    }
    // Bisa ditambahkan untuk deep link lainnya
  }

  // Show feature notifications screen
  void _showFeatureNotificationsScreen() {
    AnalyticsService.trackInteraction('feature_notifications_opened');
    AnalyticsService.trackFeatureUsage('feature_notifications_view');
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Notifikasi'),
            actions: [
              if (_featureNotifications.any((n) => !n['read']))
                IconButton(
                  onPressed: _markAllFeatureNotificationsAsRead,
                  icon: Icon(Icons.done_all),
                  tooltip: 'Tandai semua sudah dibaca',
                ),
            ],
          ),
          body: _buildFeatureNotificationsContent(),
        ),
      ),
    );
  }

  // Build feature notifications content
  Widget _buildFeatureNotificationsContent() {
    // SEBELUM membangun UI, cek ulang permission status
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkAndUpdatePermissionStatus();
    });
    
    return Column(
      children: [
        // Tombol permission jika belum diizinkan
        if (_showPermissionBanner) 
          _buildPermissionRequestSection(),
        
        // Daftar notifikasi fitur
        Expanded(
          child: _featureNotifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.new_releases_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Belum ada notifikasi fitur',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Notifikasi tentang fitur baru akan muncul di sini',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _featureNotifications.length,
                  itemBuilder: (context, index) {
                    final notification = _featureNotifications[index];
                    return _buildFeatureNotificationItem(notification);
                  },
                ),
        ),
      ],
    );
  }

  // Build permission request section
  Widget _buildPermissionRequestSection() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.notifications_off, color: Colors.orange),
              SizedBox(width: 8),
              Text(
                'Notifikasi Belum Diaktifkan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[800],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Aktifkan notifikasi untuk mendapatkan informasi tentang fitur-fitur terbaru dan tips edukasi.',
            style: TextStyle(fontSize: 14),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              // PERBAIKAN LOGIKA: 
              // Jika sudah ditolak 2 kali ATAU ditolak selamanya, tampilkan "Buka Pengaturan"
              if (_permissionRequestCount >= 2 || _permissionDeniedForever)
                ElevatedButton(
                  onPressed: () {
                    print('📱 Opening app settings...');
                    openAppSettings();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: Text('Buka Pengaturan'),
                )
              // Jika belum ditolak 2 kali, tampilkan "Aktifkan Notifikasi"
              else
                ElevatedButton(
                  onPressed: () async {
                    print('📱 Requesting notification permission...');
                    // Minta permission
                    await _requestNotificationPermission();
                    
                    // Refresh halaman notifikasi setelah request
                    if (mounted) {
                      setState(() {
                        // State sudah diupdate di _requestNotificationPermission
                      });
                    }
                    
                    // Jika permission diberikan, tutup halaman
                    if (_permissionGranted && mounted) {
                      Future.delayed(Duration(milliseconds: 500), () {
                        Navigator.pop(context); // Tutup halaman notifikasi
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: Text('Aktifkan Notifikasi'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Mark all feature notifications as read
  Future<void> _markAllFeatureNotificationsAsRead() async {
    AnalyticsService.trackInteraction('mark_all_features_read');
    
    bool hasUnread = false;
    for (var notification in _featureNotifications) {
      if (!notification['read']) {
        notification['read'] = true;
        hasUnread = true;
      }
    }
    
    if (hasUnread) {
      setState(() {});
      await _saveValidFeatureNotifications(_featureNotifications);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua notifikasi fitur telah dibaca'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnalyticsWrapper(
      screenName: 'HomeContent',
      child: Scaffold(
        appBar: _buildAppBar(context),  
        body: _buildBodyWithRefresh(context),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor:
          theme.appBarTheme.backgroundColor ??
          (theme.brightness == Brightness.dark
              ? Colors.blueAccent
              : Colors.blueAccent),
      title: _buildSearchField(context),
      actions: [
        // Feature notification button
        _buildFeatureNotificationButton(context),
        _buildProfileButton(context),
        // Config status indicator
        _buildConfigStatusIndicator(),
        Consumer<HewanProvider>(
          builder: (context, provider, _) {
            if (provider.isLoadingApi) {
              return Padding(
                padding: EdgeInsets.only(right: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              );
            }
            return SizedBox.shrink();
          },
        ),
      ],
    );
  }

  // Feature notification button
  Widget _buildFeatureNotificationButton(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: Icon(Icons.new_releases_outlined, size: 26),
          onPressed: _showFeatureNotificationsScreen,
          tooltip: "Fitur & Update",
        ),
        if (_featureNotifications.any((n) => !n['read']))
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: BoxConstraints(
                minWidth: 8,
                minHeight: 8,
              ),
            ),
          ),
      ],
    );
  }

  // Config status indicator
  Widget _buildConfigStatusIndicator() {
    return Tooltip(
      message: _isConfigLoaded ? 'Config: Updated' : 'Config: Loading...',
      child: Icon(
        _isConfigLoaded ? Icons.cloud_done : Icons.cloud_download,
        color: Colors.white,
        size: 22,
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 40,
      child: TextField(
        onChanged: (query) {
          if (query.isNotEmpty) {
            AnalyticsService.trackSearch(query, 'home_screen');
          }
        },
        onTap: () {
          AnalyticsService.trackInteraction('search_field_tapped');
          AnalyticsService.trackFeatureUsage('search_activated');
        },
        decoration: InputDecoration(
          hintText: "Cari tahu tentang laut...",
          hintStyle: TextStyle(
            color: theme.brightness == Brightness.dark
                ? Colors.white70
                : Colors.white.withOpacity(0.7),
          ),
          prefixIcon: Icon(Icons.search, color: Colors.white),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 8),
        ),
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  Widget _buildProfileButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.account_circle, size: 28),
      onPressed: () {
        AnalyticsService.trackInteraction('profile_button_clicked');
        AnalyticsService.trackFeatureUsage('profile_access_from_home');
      },
      tooltip: "Profil Pengguna",
    );
  }

  // Body dengan RefreshIndicator
  Widget _buildBodyWithRefresh(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshAllData,
      backgroundColor: Colors.blueAccent,
      color: Colors.white,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            _buildWelcomeBanner(context),
            _buildBiodiversityChart(context),
            _buildAnimalListHeader(context),
            const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
            _buildAnimalList(context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeBanner(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<HewanProvider>(
      builder: (context, provider, _) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: provider.showWelcomeBanner
              ? Container(
                  key: ValueKey('welcome-banner-$_welcomeTitle'),
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.dark
                        ? Colors.blueAccent[700]
                        : Colors.lightBlue[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.waving_hand, color: Colors.amber),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _welcomeTitle,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _welcomeMessage,
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.textTheme.bodyMedium?.color,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.close, size: 18),
                        onPressed: () {
                          AnalyticsService.trackInteraction(
                            'welcome_banner_closed',
                          );
                          provider.showWelcomeBanner = false;
                        },
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ],
                  ),
                )
              : SizedBox.shrink(key: ValueKey('empty-banner')),
        );
      },
    );
  }

  Widget _buildBiodiversityChart(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? Colors.grey[800]
            : Colors.lightBlue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Keanekaragaman Hayati di Tiap Samudra",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Expanded(child: LegendWidget())],
          ),

          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: Consumer<HewanProvider>(
              builder: (context, provider, _) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  AnalyticsService.trackContentView(
                    'biodiversity_chart',
                    'ocean_diversity',
                  );
                });

                return BarChart(
                  BarChartData(
                    barGroups: provider.barChartGroups,
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          interval: 5000,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${(value ~/ 1000)}K',
                              style: TextStyle(fontSize: 12),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            List<String> samudra = [
                              "Pasifik",
                              "Atlantik",
                              "Hindia",
                              "Selatan",
                              "Arktik",
                            ];
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                samudra[value.toInt()],
                                style: TextStyle(fontSize: 11),
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: const FlGridData(show: true),
                    borderData: FlBorderData(show: false),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimalListHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Consumer<HewanProvider>(
            builder: (context, provider, _) {
              return Text(
                "Hewan yang Dilindungi (${provider.protectedAnimals.length})",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
          TextButton(
            onPressed: () async {
              AnalyticsService.trackInteraction('lihat_semua_clicked');
              AnalyticsService.trackFeatureUsage('see_all_animals');

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SeeAllScreen()),
              );
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text("Lihat Semua", style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimalList(BuildContext context) {
    return Consumer<HewanProvider>(
      builder: (context, provider, _) {
        if (provider.isLoadingApi && provider.protectedAnimals.isEmpty) {
          return _buildLoadingState();
        }

        if (provider.apiError != null && provider.protectedAnimals.isEmpty) {
          return _buildErrorState(provider, context);
        }

        if (provider.protectedAnimals.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: provider.protectedAnimals.length,
          separatorBuilder: (context, index) => SizedBox(height: 8),
          itemBuilder: (context, index) {
            final animal = provider.protectedAnimals[index];
            return ProtectedAnimal(
              name: animal['name']!,
              count: animal['count']!,
              location: animal['location']!,
              image: animal['image']!,
              status: animal['status']!,
            );
          },
        );
      },
    );
  }

  Widget _buildLoadingState() {
    AnalyticsService.trackInteraction('data_loading_displayed');
    return Container(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Memuat data hewan...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(HewanProvider provider, BuildContext context) {
    AnalyticsService.trackError(
      'data_loading_error',
      provider.apiError ?? 'Unknown error',
    );

    return Container(
      height: 200,
      padding: EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.orange),
            SizedBox(height: 16),
            Text(
              'Gagal memuat data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Menggunakan data lokal',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                AnalyticsService.trackInteraction('retry_data_loading');
                provider.fetchAnimalsFromAPI();
              },
              icon: Icon(Icons.refresh),
              label: Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    AnalyticsService.trackInteraction('empty_data_displayed');
    return Container(
      height: 150,
      padding: EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Tidak ada hewan yang dilindungi',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Build feature notification item
  Widget _buildFeatureNotificationItem(Map<String, dynamic> notification) {
    final isUnread = !notification['read'];
    final timestamp = notification['timestamp'] as DateTime;
    final featureName = notification['feature_name'] as String;
    
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: isUnread
          ? Colors.blue.shade50
          : Theme.of(context).cardColor,
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _getFeatureNotificationIcon(notification['type']),
          ],
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification['title'],
              style: TextStyle(
                fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (featureName.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  featureName,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification['message']),
            SizedBox(height: 4),
            Text(
              _formatTimeAgo(timestamp),
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: isUnread
            ? IconButton(
                icon: Icon(Icons.circle, size: 10, color: Colors.blue),
                onPressed: () async {
                  await _markNotificationAsRead(notification['id']);
                },
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                tooltip: 'Tandai sudah dibaca',
              )
            : Icon(Icons.check_circle, size: 10, color: Colors.green),
        onTap: () async {
          // Mark as read when tapped
          if (isUnread) {
            await _markNotificationAsRead(notification['id']);
          }
          
          // Show feature dialog
          _showFeatureAnnouncementDialog(
            notification['title'],
            notification['message'],
            featureName,
            notification['action_url'],
          );
        },
        onLongPress: () async {
          final result = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Hapus Notifikasi Fitur?'),
              content: Text('Notifikasi ini akan dihapus dari daftar.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('Batal'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text('Hapus', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
          
          if (result == true) {
            _featureNotifications.remove(notification);
            setState(() {});
            
            await _saveValidFeatureNotifications(_featureNotifications);
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Notifikasi fitur telah dihapus'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
      ),
    );
  }

  // Get icon based on notification type
  Widget _getFeatureNotificationIcon(String type, {double size = 24}) {
    switch (type) {
      case 'feature_announcement':
        return Icon(Icons.new_releases, color: Colors.green, size: size);
      case 'app_update':
        return Icon(Icons.update, color: Colors.purple, size: size);
      case 'tip_of_the_day':
        return Icon(Icons.lightbulb, color: Colors.amber, size: size);
      case 'educational_content':
        return Icon(Icons.school, color: Colors.teal, size: size);
      default:
        return Icon(Icons.info, color: Colors.blue, size: size);
    }
  }

  // Format time ago
  String _formatTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) return 'Baru saja';
    if (difference.inMinutes < 60) return '${difference.inMinutes} menit yang lalu';
    if (difference.inHours < 24) return '${difference.inHours} jam yang lalu';
    if (difference.inDays < 30) return '${difference.inDays} hari yang lalu';
    
    return '${(difference.inDays / 30).floor()} bulan yang lalu';
  }
}

class ProtectedAnimal extends StatefulWidget {
  final String name, count, location, image, status;

  const ProtectedAnimal({
    super.key,
    required this.name,
    required this.count,
    required this.location,
    required this.image,
    required this.status,
  });

  @override
  State<ProtectedAnimal> createState() => _ProtectedAnimalState();
}

class _ProtectedAnimalState extends State<ProtectedAnimal> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 1,
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          AnalyticsService.trackInteraction('animal_card_tapped');
          AnalyticsService.trackContentView('animal_detail', widget.name);
          AnalyticsService.trackFeatureUsage('animal_detail_view');

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(animalName: widget.name),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  AnalyticsService.trackInteraction('animal_image_tapped');
                  AnalyticsService.trackFeatureUsage('animal_image_view');
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    widget.image,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      AnalyticsService.trackError(
                        'image_load_error',
                        error.toString(),
                      );
                      return Container(
                        width: 70,
                        height: 70,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, color: Colors.grey),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            widget.location,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () {
                        AnalyticsService.trackInteraction('animal_status_tapped');
                      },
                      child: Chip(
                        label: Text(
                          widget.status,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        backgroundColor: widget.status == 'Dilindungi'
                            ? (Theme.of(context).brightness == Brightness.dark
                                ? Colors.green[800]
                                : Colors.lightGreen[100])
                            : (Theme.of(context).brightness == Brightness.dark
                                ? Colors.orange[800]
                                : Colors.orange[100]),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Tooltip(
                    message: "Jumlah populasi",
                    child: GestureDetector(
                      onTap: () {
                        AnalyticsService.trackInteraction('population_info_tapped');
                        AnalyticsService.trackFeatureUsage('population_info_view');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.brightness == Brightness.dark
                              ? Colors.blueAccent[700]
                              : Colors.lightBlue[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.count,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : Colors.grey[600],
                      size: 20,
                    ),
                    onPressed: () {
                      final newFavoriteState = !_isFavorite;

                      AnalyticsService.trackInteraction('favorite_toggled');
                      AnalyticsService.trackFeatureUsage(
                        newFavoriteState ? 'favorite_added' : 'favorite_removed',
                      );

                      setState(() => _isFavorite = newFavoriteState);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _isFavorite
                                ? "${widget.name} ditambahkan ke favorit"
                                : "${widget.name} dihapus dari favorit",
                          ),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              AnalyticsService.trackInteraction('favorite_undo');
                              setState(() => _isFavorite = !_isFavorite);
                            },
                          ),
                        ),
                      );
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
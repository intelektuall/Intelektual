import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  
  // Simpan notifikasi untuk ditampilkan saat app dibuka
  await _saveNotificationForLater(message);
}

// Helper untuk simpan notifikasi ke SharedPreferences
Future<void> _saveNotificationForLater(RemoteMessage message) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    
    // Baca notifikasi yang tersimpan
    final savedNotificationsJson = prefs.getStringList('saved_notifications') ?? [];
    List<Map<String, dynamic>> savedNotifications = [];
    
    // Decode JSON string ke list
    for (final jsonString in savedNotificationsJson) {
      try {
        // Format sederhana: simpan sebagai map
        final parts = jsonString.split('|||');
        if (parts.length >= 4) {
          savedNotifications.add({
            'id': parts[0],
            'title': parts[1],
            'message': parts[2],
            'timestamp': parts[3],
            'type': parts.length > 4 ? parts[4] : 'general',
            'fromBackground': true,
          });
        }
      } catch (e) {
        print('❌ Error parsing saved notification: $e');
      }
    }
    
    // Tambahkan notifikasi baru
    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    final notificationString = [
      newId,
      message.notification?.title ?? 'Notifikasi Baru',
      message.notification?.body ?? 'Ada informasi baru',
      DateTime.now().toIso8601String(),
      message.data['type'] ?? 'general',
    ].join('|||');
    
    savedNotificationsJson.add(notificationString);
    
    // Simpan kembali (maksimal 50 notifikasi)
    if (savedNotificationsJson.length > 50) {
      savedNotificationsJson.removeAt(0);
    }
    
    await prefs.setStringList('saved_notifications', savedNotificationsJson);
    print('💾 Background notification saved: ${message.notification?.title}');
    
  } catch (e) {
    print('❌ Error saving notification: $e');
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

  // In-App Notification State
  final List<Map<String, dynamic>> _inAppNotifications = [];
  int _notificationCount = 0;
  
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
    await _loadSavedNotifications();
    _startAutoCleanupTimer();
  }

  // Load saved notifications from SharedPreferences
  Future<void> _loadSavedNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedNotificationsJson = prefs.getStringList('saved_notifications') ?? [];
      
      List<Map<String, dynamic>> loadedNotifications = [];
      
      for (final jsonString in savedNotificationsJson) {
        try {
          final parts = jsonString.split('|||');
          if (parts.length >= 4) {
            final timestamp = DateTime.parse(parts[3]);
            final ageInHours = DateTime.now().difference(timestamp).inHours;
            
            // Hapus notifikasi yang sudah lebih dari 24 jam
            if (ageInHours < 24) {
              loadedNotifications.add({
                'id': parts[0],
                'title': parts[1],
                'message': parts[2],
                'timestamp': timestamp,
                'type': parts.length > 4 ? parts[4] : 'general',
                'read': false,
                'fromBackground': true,
              });
            }
          }
        } catch (e) {
          print('❌ Error parsing notification: $e');
        }
      }
      
      // Simpan notifikasi yang masih valid
      await _saveValidNotifications(loadedNotifications);
      
      // Load ke memory
      setState(() {
        _inAppNotifications.clear();
        _inAppNotifications.addAll(loadedNotifications);
        _notificationCount = loadedNotifications.length;
      });
      
      print('📂 Loaded ${loadedNotifications.length} notifications from storage');
      
    } catch (e) {
      print('❌ Error loading notifications: $e');
    }
  }

  // Save valid notifications to SharedPreferences
  Future<void> _saveValidNotifications(List<Map<String, dynamic>> notifications) async {
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
        ].join('|||'));
      }
      
      await prefs.setStringList('saved_notifications', jsonList);
    } catch (e) {
      print('❌ Error saving notifications: $e');
    }
  }

  // Start auto cleanup timer (setiap 1 jam)
  void _startAutoCleanupTimer() {
    _cleanupTimer = Timer.periodic(Duration(hours: 1), (timer) {
      _cleanupOldNotifications();
    });
  }

  // Cleanup notifications older than 24 hours
  Future<void> _cleanupOldNotifications() async {
    final now = DateTime.now();
    final validNotifications = _inAppNotifications.where((notification) {
      final timestamp = notification['timestamp'] as DateTime;
      return now.difference(timestamp).inHours < 24;
    }).toList();
    
    if (validNotifications.length < _inAppNotifications.length) {
      setState(() {
        _inAppNotifications.clear();
        _inAppNotifications.addAll(validNotifications);
        _notificationCount = validNotifications.length;
      });
      
      await _saveValidNotifications(validNotifications);
      print('🧹 Cleaned up old notifications');
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

      // 3. Cleanup old notifications
      await _cleanupOldNotifications();

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

  // FCM setup
  Future<void> _setupPushNotifications() async {
    try {
      final settings = await _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        final token = await _fcm.getToken();
        AnalyticsService.trackFeatureUsage('push_notifications_enabled');
        print('🔑 FCM Token: $token');

        // Setup background handler
        FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
        
        // Handle incoming notifications - FOREGROUND
        FirebaseMessaging.onMessage.listen(_handleIncomingNotification);
        
        // Handle when notification opens the app
        FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationOpened);

        print('✅ FCM: Setup successful with background handler');
      } else {
        AnalyticsService.trackFeatureUsage('push_notifications_denied');
        print('ℹ️ FCM: Permission not granted');
      }
    } catch (e) {
      AnalyticsService.trackError('fcm_setup_error', e.toString());
      print('❌ FCM Error: $e');
    }
  }

  // Handle incoming notification - FOREGROUND (app terbuka)
  void _handleIncomingNotification(RemoteMessage message) async {
    AnalyticsService.trackInteraction('push_notification_received_foreground');
    
    // Add to in-app notifications
    await _addInAppNotification(
      title: message.notification?.title ?? 'Pemberitahuan Baru',
      message: message.notification?.body ?? 'Ada informasi baru untuk Anda',
      type: message.data['type'] ?? 'general',
      payload: message.data,
      fromBackground: false,
    );
    
    // Show snackbar notification
    _showNotificationSnackbar(
      message.notification?.title ?? 'Pemberitahuan',
      message.notification?.body ?? '',
      message.data['type'] ?? 'general',
    );
    
    print('📨 [FOREGROUND] Notification received: ${message.notification?.title}');
  }

  // Handle notification opened (app dibuka dari notification)
  void _handleNotificationOpened(RemoteMessage message) async {
    AnalyticsService.trackInteraction('push_notification_opened');
    AnalyticsService.trackFeatureUsage(
      'notification_opened_${message.data['type'] ?? 'unknown'}',
    );
    
    // Add to in-app notifications
    await _addInAppNotification(
      title: message.notification?.title ?? 'Notifikasi',
      message: message.notification?.body ?? 'Informasi baru',
      type: message.data['type'] ?? 'general',
      payload: message.data,
      fromBackground: true,
    );
    
    // Navigate based on notification type
    final data = message.data;
    if (data['type'] == 'new_animal' && data['animal_name'] != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AnalyticsService.trackNavigation('notification', 'animal_detail');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(animalName: data['animal_name']!),
          ),
        );
      });
    } else if (data['type'] == 'feature_update') {
      // Show feature dialog
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showFeatureDialog(
          message.notification?.title ?? 'Fitur Baru',
          message.notification?.body ?? '',
        );
      });
    }
  }

  // Add in-app notification dengan save ke storage
  Future<void> _addInAppNotification({
    required String title,
    required String message,
    String type = 'general',
    Map<String, dynamic>? payload,
    bool fromBackground = false,
  }) async {
    final newNotification = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': title,
      'message': message,
      'timestamp': DateTime.now(),
      'type': type,
      'read': false,
      'payload': payload,
      'fromBackground': fromBackground,
    };
    
    setState(() {
      _inAppNotifications.insert(0, newNotification);
      _notificationCount++;
    });
    
    AnalyticsService.trackFeatureUsage('in_app_notification_received');
    
    // Save to SharedPreferences
    await _saveValidNotifications(_inAppNotifications);
  }

  // Show notification snackbar
  void _showNotificationSnackbar(String title, String message, String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            _getNotificationIcon(type, size: 20),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    message,
                    style: TextStyle(fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        duration: Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Lihat',
          onPressed: () => _showNotificationsScreen(),
        ),
      ),
    );
  }

  // Show notifications screen
  void _showNotificationsScreen() {
    AnalyticsService.trackInteraction('notification_center_opened');
    AnalyticsService.trackFeatureUsage('notification_center_view');
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Notifikasi'),
            actions: [
              if (_notificationCount > 0)
                TextButton(
                  onPressed: _markAllAsRead,
                  child: Text(
                    'Tandai Sudah Dibaca',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
          body: _buildNotificationsContent(),
        ),
      ),
    );
  }

  // Build notifications content
  Widget _buildNotificationsContent() {
    if (_inAppNotifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Tidak ada notifikasi',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Notifikasi baru akan muncul di sini',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      itemCount: _inAppNotifications.length,
      itemBuilder: (context, index) {
        final notification = _inAppNotifications[index];
        return _buildNotificationItem(notification);
      },
    );
  }

  // Mark all notifications as read
  Future<void> _markAllAsRead() async {
    AnalyticsService.trackInteraction('mark_all_notifications_read');
    
    for (var notification in _inAppNotifications) {
      notification['read'] = true;
    }
    
    setState(() {
      _notificationCount = 0;
    });
    
    await _saveValidNotifications(_inAppNotifications);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Semua notifikasi telah dibaca'),
        duration: Duration(seconds: 2),
      ),
    );
    
    Navigator.pop(context);
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
        // Notification button with badge
        _buildNotificationButton(context),
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

  // New notification button with badge
  Widget _buildNotificationButton(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: Icon(Icons.notifications_outlined, size: 26),
          onPressed: _showNotificationsScreen,
          tooltip: "Notifikasi",
        ),
        if (_notificationCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                _notificationCount > 9 ? '9+' : _notificationCount.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
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

  // Build notification item
  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    final isUnread = !notification['read'];
    final timestamp = notification['timestamp'] as DateTime;
    final fromBackground = notification['fromBackground'] ?? false;
    
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: isUnread
          ? (fromBackground ? Colors.orange.shade50 : Colors.blue.shade50)
          : Theme.of(context).cardColor,
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _getNotificationIcon(notification['type']),
            if (fromBackground)
              Container(
                margin: EdgeInsets.only(top: 2),
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'BG',
                  style: TextStyle(fontSize: 8, color: Colors.white),
                ),
              ),
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
            ? Icon(Icons.circle, size: 10, color: fromBackground ? Colors.orange : Colors.blue)
            : null,
        onTap: () async {
          // Mark as read when tapped
          if (isUnread) {
            setState(() {
              notification['read'] = true;
              _notificationCount--;
            });
            
            await _saveValidNotifications(_inAppNotifications);
          }
          
          // Handle notification action based on type
          _handleNotificationAction(notification);
        },
        onLongPress: () async {
          final result = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Hapus Notifikasi?'),
              content: Text('Notifikasi ini akan dihapus secara permanen.'),
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
            _inAppNotifications.remove(notification);
            setState(() {
              if (!notification['read']) {
                _notificationCount--;
              }
            });
            
            await _saveValidNotifications(_inAppNotifications);
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Notifikasi telah dihapus'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
      ),
    );
  }

  // Get icon based on notification type
  Widget _getNotificationIcon(String type, {double size = 24}) {
    switch (type) {
      case 'feature_update':
        return Icon(Icons.new_releases, color: Colors.green, size: size);
      case 'event':
        return Icon(Icons.event, color: Colors.orange, size: size);
      case 'tip':
        return Icon(Icons.lightbulb, color: Colors.yellow.shade700, size: size);
      case 'alert':
        return Icon(Icons.warning, color: Colors.red, size: size);
      case 'new_animal':
        return Icon(Icons.pets, color: Colors.teal, size: size);
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

  // Handle notification action
  void _handleNotificationAction(Map<String, dynamic> notification) {
    AnalyticsService.trackInteraction('notification_item_tapped');
    
    final type = notification['type'];
    final payload = notification['payload'];
    
    switch (type) {
      case 'new_animal':
        if (payload != null && payload['animal_name'] != null) {
          Navigator.pop(context); // Close notification screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(animalName: payload['animal_name']),
            ),
          );
        }
        break;
      case 'event':
        // Navigate to events page
        Navigator.pop(context); // Close notification screen
        final homeScreenState = context.findRootAncestorStateOfType<_HomeScreenState>();
        if (homeScreenState != null) {
          homeScreenState._onItemTapped(2); // Event page index
        }
        break;
      case 'feature_update':
        // Show feature dialog
        _showFeatureDialog(notification['title'], notification['message']);
        break;
      default:
        // Close notification screen and show message
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Membuka: ${notification['title']}'),
            duration: Duration(seconds: 2),
          ),
        );
        break;
    }
  }

  // Show feature dialog
  void _showFeatureDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              AnalyticsService.trackFeatureUsage('feature_explored_from_notif');
              // Navigate to Edukasi tab
              final homeScreenState = context.findRootAncestorStateOfType<_HomeScreenState>();
              if (homeScreenState != null) {
                homeScreenState._onItemTapped(3); // Edukasi page index
              }
            },
            child: Text('Jelajahi'),
          ),
        ],
      ),
    );
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
  _ProtectedAnimalState createState() => _ProtectedAnimalState();
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
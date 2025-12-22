// // main.dart : Sebelum ada firestore ganteng punya eka
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_analytics/observer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:provider/provider.dart';
// import 'package:sopan_santun_app/Fauzan/Event/EventPage.dart';
// import 'package:sopan_santun_app/Fauzan/Event/Notification/notification_database.dart';
// import 'package:sopan_santun_app/Fauzan/LoginPage/Firebase_Auth/launch.dart';
// import 'package:sopan_santun_app/Fauzan/News/Models/news_provider.dart';

// // === Provider Hatami ===
// import 'Provider/hewan_provider.dart';

// // === Provider Fauzan ===
// import 'Fauzan/Event/Notification/notification_provider.dart';
// import 'Fauzan/Event/Providers/event_provider.dart';
// import 'Fauzan/LoginPage/Providers/LoginValidation.dart';
// import 'Fauzan/LoginPage/Providers/ProviderLogin.dart';

// // === Provider Eka ===
// import 'Eka/provider/settings_provider.dart';
// import 'Eka/provider/firebase_helper.dart';

// // === Provider Ryan ===
// import 'Ryan/providers/link_provider.dart';
// import 'Ryan/providers/marine_species_provider.dart';
// import 'Ryan/providers/coral_species_provider.dart';
// import 'Ryan/providers/filter_provider.dart';
// import 'Ryan/providers/content_filter_provider.dart';
// import 'Ryan/providers/marine_species_action_provider.dart';
// import 'Ryan/providers/coral_species_action_provider.dart';
// import 'Ryan/providers/cardOverlay/card_overlay_provider.dart';
// import 'Ryan/providers/cardOverlay/cardC_overlay_provider.dart';

// // === Halaman awal ===
// import 'Fauzan/LoginPage/login_screen.dart';
// import 'Ryan/screens/newpage_unlocked.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   await FirebaseAuth.instance.signOut();

//   // Pastikan Analytics aktif
//   await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

//   final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
//   final FirebaseAnalyticsObserver observer =
//       FirebaseAnalyticsObserver(analytics: analytics);

//   runApp(
//     MultiProvider(
//       providers: [
//         // === Provider Hatami ===
//         ChangeNotifierProvider(create: (_) => HewanProvider()),

//         // === Provider Fauzan ===
//         ChangeNotifierProvider(create: (_) => AgreeTermsProvider()),
//         ChangeNotifierProvider(create: (_) => LoginValidationProvider()),
//         ChangeNotifierProvider(create: (_) => EventProvider()),
//         ChangeNotifierProvider(create: (_) => NotificationProvider()),
//         ChangeNotifierProvider(create: (_) => NewsProvider()),

//         // === Provider Eka ===
//         ChangeNotifierProvider(create: (_) => SettingsProvider()),

//         // === Provider Ryan ===
//         ChangeNotifierProvider(create: (_) => LinkProvider()),
//         ChangeNotifierProvider(create: (_) => MarineSpeciesProvider()),
//         ChangeNotifierProvider(create: (_) => CoralSpeciesProvider()),
//         ChangeNotifierProvider(create: (_) => FilterProvider()),
//         ChangeNotifierProvider(create: (_) => ContentFilterProvider()),
//         ChangeNotifierProvider(create: (_) => MarineSpeciesActionProvider()),
//         ChangeNotifierProvider(create: (_) => CoralSpeciesActionProvider()),
//         ChangeNotifierProvider(create: (_) => CardOverlayProvider()),
//         ChangeNotifierProvider(create: (_) => CardOverlayCProvider()),
//       ],
//       child: MainApp(analytics: analytics, observer: observer),
//     ),
//   );
// }

// class MainApp extends StatefulWidget {
//   final FirebaseAnalytics analytics;
//   final FirebaseAnalyticsObserver observer;

//   const MainApp({super.key, required this.analytics, required this.observer});

//   @override
//   State<MainApp> createState() => _MainAppState();
// }

// class _MainAppState extends State<MainApp> {
//   @override
//   void initState() {
//     super.initState();
//     _logAppStart();
//   }

//   Future<void> _logAppStart() async {
//     await widget.analytics.logAppOpen();
//     await widget.analytics.logEvent(
//       name: 'app_started',
//       parameters: {'timestamp': DateTime.now().toIso8601String()},
//     );
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final settings = Provider.of<SettingsProvider>(context, listen: false);
//     final isDark = settings.backgroundMode == "Hitam";

//     // Catat perubahan tema
//     widget.analytics.logEvent(
//       name: 'change_theme',
//       parameters: {'theme': isDark ? 'dark' : 'light'},
//     );

//     // Catat perubahan bahasa
//     widget.analytics.logEvent(
//       name: 'change_language',
//       parameters: {'language': settings.language},
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final settings = Provider.of<SettingsProvider>(context);
//     final isDark = settings.backgroundMode == "Hitam";

//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: "Sopan Santun App",
//       navigatorObservers: [widget.observer],

//       // === Tema terang ===
//       theme: ThemeData(
//         useMaterial3: true,
//         brightness: Brightness.light,
//         scaffoldBackgroundColor: Colors.white,
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: Colors.blueAccent,
//           brightness: Brightness.light,
//         ),
//       ),

//       // === Tema gelap ===
//       darkTheme: ThemeData(
//         useMaterial3: true,
//         brightness: Brightness.dark,
//         scaffoldBackgroundColor: Colors.black,
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: Colors.blueAccent,
//           brightness: Brightness.dark,
//         ),
//       ),

//       themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

//       // === Lokalisasi ===
//       locale:
//           settings.language == "Indonesia" ? const Locale('id') : const Locale('en'),
//       supportedLocales: const [Locale('id'), Locale('en')],
//       localizationsDelegates: const [
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],

//       home: const LaunchScreen(),
//       routes: {'/newpage_unlocked': (context) => const NewPageUnlocked()},
//     );
//   }
// }

// main.dart : setelah masuk firestore ganteng punya eka
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:sopan_santun_app/Fauzan/Event/EventPage.dart';
import 'package:sopan_santun_app/Fauzan/Event/Notification/notification_database.dart';
import 'package:sopan_santun_app/Fauzan/LoginPage/Firebase_Auth/launch.dart';
import 'package:sopan_santun_app/Fauzan/LoginPage/login_screen.dart';
import 'package:sopan_santun_app/Fauzan/News/Models/news_provider.dart';

// === Provider Hatami ===
import 'Provider/hewan_provider.dart';

// === Provider Fauzan ===
import 'Fauzan/Event/Notification/notification_provider.dart';
import 'Fauzan/Event/Providers/event_provider.dart';
import 'Fauzan/LoginPage/Providers/LoginValidation.dart';
import 'Fauzan/LoginPage/Providers/AgreeTermsProvider.dart';

// === Provider Eka ===
import 'Eka/provider/settings_provider.dart';
import 'Eka/provider/firebase_helper.dart';

// === Provider Ryan ===
import 'Ryan/providers/link_provider.dart';
import 'Ryan/providers/marine_species_provider.dart';
import 'Ryan/providers/coral_species_provider.dart';
import 'Ryan/providers/filter_provider.dart';
import 'Ryan/providers/content_filter_provider.dart';
import 'Ryan/providers/marine_species_action_provider.dart';
import 'Ryan/providers/coral_species_action_provider.dart';
import 'Ryan/providers/cardOverlay/card_overlay_provider.dart';
import 'Ryan/providers/cardOverlay/cardC_overlay_provider.dart';
import 'Ryan/providers/locale_provider.dart';
import 'Ryan/providers/user_access_provider.dart';

// Services Ryan
import 'Ryan/services/analytics_service.dart';
import 'l10n/app_localizations.dart';

// === Interstitial Ad Manager ===
import 'Periklanan/interstitial_ad_manager.dart';

// === Halaman lain ===
import 'Ryan/screens/newpage_unlocked.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // === Inisialisasi Google Mobile Ads ===
  try {
    await MobileAds.instance.initialize();
    print('📱 Google Mobile Ads initialized successfully.');
  } catch (e) {
    print('❌ Google Mobile Ads initialization failed: $e');
  }

  // === Inisialisasi Firebase ===
  try {
    await Firebase.initializeApp();
    debugPrint("Firebase initialized successfully.");
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }

  // === Nonaktifkan sesi login otomatis ===
  await FirebaseAuth.instance.signOut();

  // === Aktifkan Firebase Analytics ===
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
    analytics: analytics,
  );
  final AnalyticsService analyticsService = AnalyticsService(analytics);

  // === Tes koneksi Firestore ===
  try {
    await FirebaseFirestore.instance
        .collection('test_connection')
        .doc('ping')
        .set({
          'connected': true,
          'timestamp': DateTime.now().toIso8601String(),
        });
    debugPrint("Firestore connection success ✅");
  } catch (e) {
    debugPrint("Firestore connection failed ❌: $e");
  }

  // === Pre-load iklan interstitial ===
  WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
    Future.delayed(const Duration(seconds: 2), () {
      InterstitialAdManager().loadInterstitialAd();
    });
  });

  runApp(
    MultiProvider(
      providers: [
        // === Provider Hatami ===
        ChangeNotifierProvider(create: (_) => HewanProvider()),

        // === Provider Fauzan ===
        ChangeNotifierProvider(create: (_) => AgreeTermsProvider()),
        ChangeNotifierProvider(create: (_) => LoginValidationProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),

        // === Provider Eka ===
        ChangeNotifierProvider(create: (_) => SettingsProvider()),

        // === Provider Ryan ===
        ChangeNotifierProvider(create: (_) => LinkProvider()),
        ChangeNotifierProvider(create: (_) => MarineSpeciesProvider()),
        ChangeNotifierProvider(create: (_) => CoralSpeciesProvider()),
        ChangeNotifierProvider(create: (_) => FilterProvider()),
        ChangeNotifierProvider(create: (_) => ContentFilterProvider()),
        ChangeNotifierProvider(create: (_) => MarineSpeciesActionProvider()),
        ChangeNotifierProvider(create: (_) => CoralSpeciesActionProvider()),
        ChangeNotifierProvider(create: (_) => CardOverlayProvider()),
        ChangeNotifierProvider(create: (_) => CardOverlayCProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => UserAccessProvider()),
        Provider.value(value: analyticsService),
      ],
      child: MainApp(
        analytics: analytics,
        observer: observer,
        analyticsService: analyticsService,
      ),
    ),
  );
}

class MainApp extends StatefulWidget {
  final AnalyticsService analyticsService;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  const MainApp({
    super.key,
    required this.analytics,
    required this.observer,
    required this.analyticsService,
  });

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    _logAppStart();
  }

  Future<void> _logAppStart() async {
    await widget.analytics.logAppOpen();
    await widget.analytics.logEvent(
      name: 'app_started',
      parameters: {'timestamp': DateTime.now().toIso8601String()},
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final isDark = settings.backgroundMode == "Hitam";

    widget.analytics.logEvent(
      name: 'change_theme',
      parameters: {'theme': isDark ? 'dark' : 'light'},
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDark = settings.backgroundMode == "Hitam";

    return Consumer<LocaleProvider>(
      builder: (context, LocaleProvider, _) {
        return MaterialApp(
          locale: LocaleProvider.locale,
           supportedLocales: const [
            Locale('id'),
            Locale('en'),
            Locale('zh'),
            Locale('es'),
            Locale('fr'),
            Locale('hi'),
            Locale('ru'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
          title: "Sopan Santun App",
          navigatorObservers: [widget.observer],

          // === Tema terang ===
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blueAccent,
              brightness: Brightness.light,
            ),
          ),

          // === Tema gelap ===
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Colors.black,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blueAccent,
              brightness: Brightness.dark,
            ),
          ),

          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

          home: const LaunchScreen(),
          routes: {'/newpage_unlocked': (context) => const NewPageUnlocked()},
        );
      },
    );
  }
}
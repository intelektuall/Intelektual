import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

// === Provider Hatami ===
import 'Provider/hewan_provider.dart';

// === Provider Fauzan ===
import 'Fauzan/Event/Notification/notification_provider.dart';
import 'Fauzan/Event/Providers/event_provider.dart';
import 'Fauzan/LoginPage/Providers/LoginValidation.dart';
import 'Fauzan/LoginPage/Providers/ProviderLogin.dart';

// === Provider Eka ===
import 'Eka/provider/settings_provider.dart';

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

// === Halaman awal ===
import 'Fauzan/LoginPage/login_screen.dart';

// === Tambahan halaman Ryan jika ingin akses lewat route ===
import 'Ryan/screens/newpage_unlocked.dart';

void main() {
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
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDark = settings.backgroundMode == "Hitam";

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Sopan Santun App",

      // === Tema default (light)
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.light,
        ),
      ),

      // === Tema dark (jika user pilih Hitam)
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
      ),

      // === Aktifkan mode sesuai setting user
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

      // === Lokalisasi ===
      locale: const Locale('id'),
      supportedLocales: const [
        Locale('id'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // === Halaman pertama ===
      home: MyLoginAndSignin(),

      // === Routing halaman tambahan ===
      routes: {
        '/newpage_unlocked': (context) => const NewPageUnlocked(),
      },
    );
  }
}

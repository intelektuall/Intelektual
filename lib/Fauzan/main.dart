import 'package:sopan_santun_app/Fauzan/LoginPage/Firebase_Auth/launch.dart';

import '/Fauzan/Event/Notification/notification_provider.dart';
import '/Fauzan/Event/Providers/event_provider.dart';
import '/Fauzan/LoginPage/Providers/LoginValidation.dart';
import '/Fauzan/LoginPage/Providers/ProviderLogin.dart';
import '/Activity/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AgreeTermsProvider()),
        ChangeNotifierProvider(create: (_) => LoginValidationProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      locale: Locale('id'),
      supportedLocales: [
        Locale('id'), // Bahasa Indonesia
        Locale('en'), // Bahasa Inggris
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: LaunchScreen(),
    );
  }
}

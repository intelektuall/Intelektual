import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import '../../services/analytics_service.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/mystery_item.dart';

class MysteryDetailScreen extends StatelessWidget {
  final MysteryItem mystery;

  const MysteryDetailScreen({super.key, required this.mystery});

  @override
  Widget build(BuildContext context) {
    AnalyticsService(
      FirebaseAnalytics.instance,
    ).logScreenView("MysteryDetailScreen_${mystery.title}");
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = isDark ? Colors.grey[900] : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final appBarColor = isDark ? Colors.blueAccent : Colors.blueAccent;
    final iconColor = isDark ? Colors.white : Colors.black;
    final shadowColor = isDark ? Colors.black54 : Colors.black87;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: CircleAvatar(
            backgroundColor: backgroundColor,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: iconColor),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),

      body: Stack(
        children: [
         /// 🔹 Background
          Positioned.fill(
            child: Container(
              color: theme.scaffoldBackgroundColor,
            ),
          ),

          /// 🔹 Overlay Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.6),
                          Colors.black.withOpacity(0.8),
                        ]
                      : [
                          Colors.white.withOpacity(0.2),
                          Colors.white.withOpacity(0.4),
                          Colors.white.withOpacity(0.5),
                        ],
                ),
              ),
            ),
          ),

          /// 🔹 Konten Utama
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: 100,
              left: 16,
              right: 16,
              bottom: 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 📌 Judul Fakta
                Center(
                  child: Text(
                    mystery.title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      shadows: [
                        Shadow(blurRadius: 6, color: shadowColor),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                /// 📌 Konten Artikel Penuh
                Text(
                  mystery.fullContent,
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    height: 1.7,
                    color: textColor.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

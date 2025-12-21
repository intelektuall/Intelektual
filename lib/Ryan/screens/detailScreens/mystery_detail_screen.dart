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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: CircleAvatar(
            backgroundColor: Colors.black.withOpacity(0.3),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          /// 🔹 Background Laut
          Positioned.fill(
            child: Image.asset(
              "assets/images/oceanDetailBackground.jpg",
              fit: BoxFit.cover,
            ),
          ),

          /// 🔹 Overlay gelap agar teks terbaca
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.4)),
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
                      color: Colors.white,
                      shadows: [
                        const Shadow(blurRadius: 6, color: Colors.black87),
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
                    color: Colors.white.withOpacity(0.95),
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

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/fact_item.dart';
import '../../services/analytics_service.dart';

class FactOceanDetailScreen extends StatelessWidget {
  final FactItem fact;

  const FactOceanDetailScreen({super.key, required this.fact});

  @override
  Widget build(BuildContext context) {
    AnalyticsService(
      FirebaseAnalytics.instance,
    ).logScreenView("FactDetailScreen_${fact.title}");
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
                    fact.title,
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
                  fact.fullContent,
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

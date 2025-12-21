import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/coral_species.dart';
import '../../services/analytics_service.dart';

class CoralSpeciesDetailScreen extends StatelessWidget {
  final CoralSpecies species;

  const CoralSpeciesDetailScreen({super.key, required this.species});

  @override
  Widget build(BuildContext context) {
    AnalyticsService(
      FirebaseAnalytics.instance,
    ).logScreenView("CoralSpeciesDetailScreen_${species.name}");
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
          /// 🔹 Background Gambar Laut
          Positioned.fill(
            child: Image.asset(
              "assets/images/oceanDetailBackground.jpg",
              fit: BoxFit.cover,
            ),
          ),

          /// 🔹 Overlay Gelap Agar Tulisan Terbaca
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),

          /// 🔹 Konten
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
                /// 📌 Gambar Utama
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      species.imagePath,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                /// 📌 Nama Spesies
                Center(
                  child: Text(
                    species.name,
                    style: GoogleFonts.roboto(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        const Shadow(blurRadius: 6, color: Colors.black87),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),

                /// 📌 Deskripsi Spesies
                Text(
                  species.description,
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    height: 1.6,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

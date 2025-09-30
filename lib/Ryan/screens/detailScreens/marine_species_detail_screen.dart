import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/marine_species.dart';

class MarineSpeciesDetailScreen extends StatelessWidget {
  final MarineSpecies species;

  const MarineSpeciesDetailScreen({super.key, required this.species});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final appBarColor = isDark ? Colors.blueAccent : Colors.blueAccent;
    final iconColor = isDark ? Colors.white : Colors.black;
    final shadowColor = isDark ? Colors.black54 : Colors.black87;
    final boxShadowColor = isDark ? Colors.black54 : Colors.black38;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: iconColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Stack(
        children: [
          /// 🔹 Background with Theme Color
          Positioned.fill(
            child: Container(
              color: theme.scaffoldBackgroundColor,
            ),
          ),

          /// 🔹 Gradient Overlay
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

          /// 🔹 Main Content
          SingleChildScrollView(
            padding: const EdgeInsets.only(
                top: 100, left: 16, right: 16, bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 📌 Species Image
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: boxShadowColor,
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

                /// 📌 Species Name
                Center(
                  child: Text(
                    species.name,
                    style: GoogleFonts.roboto(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      shadows: [
                        Shadow(
                          blurRadius: 6,
                          color: shadowColor,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),

                /// 📌 Species Description
                Text(
                  species.description,
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    height: 1.6,
                    color: textColor.withOpacity(0.9),
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
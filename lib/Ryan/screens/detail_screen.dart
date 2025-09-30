import 'package:flutter/material.dart';
import '/Ryan/screens/link_tree_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/sea_life.dart';

class DetailScreen extends StatelessWidget {
  final SeaLife seaLife;

  const DetailScreen({super.key, required this.seaLife});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black54 : Colors.blueAccent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: textColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),

      body: Stack(
        children: [
          /// 🔹 Background
          Positioned.fill(
            child: Container(color: backgroundColor),
          ),

          /// 🔹 Overlay Transparan (diabaikan karena tidak ada gambar background)
          Positioned.fill(
            child: Container(color: backgroundColor),
          ),

          /// 🔹 Konten
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: 100,
              left: 16,
              right: 16,
              bottom: 80,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 📌 Gambar Utama
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      seaLife.imagePath,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                /// 📌 Judul utama
                Center(
                  child: Text(
                    seaLife.name,
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),

                /// 📌 Section Dinamis
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(seaLife.sections.length, (
                    sectionIndex,
                  ) {
                    final section = seaLife.sections[sectionIndex];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 📌 Subjudul
                        Text(
                          section.title,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 6),

                        /// 📌 Teks biasa
                        if (section.text != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              section.text!,
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                height: 1.6,
                                color: textColor,
                              ),
                            ),
                          ),

                        /// 📌 Poin bernomor
                        if (section.points.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(section.points.length, (
                              index,
                            ) {
                              final point = section.points[index];

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// 📌 Poin utama
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 25,
                                          alignment: Alignment.topCenter,
                                          child: Text(
                                            "${index + 1}.",
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: textColor,
                                              shadows: isDark
                                                  ? [
                                                      const Shadow(
                                                        blurRadius: 3,
                                                        color: Colors.black,
                                                      )
                                                    ]
                                                  : [],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            point.title,
                                            textAlign: TextAlign.justify,
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              height: 1.5,
                                              color: textColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    /// 📌 Deskripsi tambahan
                                    if (point.description != null)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 33.0,
                                          top: 4,
                                        ),
                                        child: Text(
                                          point.description!,
                                          textAlign: TextAlign.justify,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            height: 1.5,
                                            color: textColor,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        const SizedBox(height: 20),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),

      /// 📌 FAB ke LinkTree
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LinkTreeScreen()),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.arrow_forward, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

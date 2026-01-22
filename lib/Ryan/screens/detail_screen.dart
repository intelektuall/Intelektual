import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'link_tree_screen.dart';
import '../models/seaLifeModel/ocean.dart';
import '../providers/locale_provider.dart';
import '../services/my_http_helper.dart';
import '../services/analytics_mixin.dart';

class DetailScreen extends StatefulWidget {
  final String oceanId;
  final HttpHelper httpHelper;

  DetailScreen({super.key, required this.oceanId, HttpHelper? httpHelper})
    : httpHelper = httpHelper ?? HttpHelper();

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with AnalyticsScreenTracking {
  late Future<Ocean> futureOcean;

  @override
  String get screenName => 'DetailScreen';

  @override
  void initState() {
    super.initState();
    futureOcean = fetchOceanDetail(widget.oceanId);
  }

  Future<Ocean> fetchOceanDetail(String id) async {
    final allOceans = await widget.httpHelper.fetchSeaLife();

    return allOceans.firstWhere(
      (ocean) => ocean.id == id,
      orElse: () => Ocean(
        id: '',
        name: const {'en': 'Not Found', 'id': 'Tidak ditemukan'},
        imagePath: '',
        sections: const [],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    /// 🔥 bahasa aktif
    final lang = context.watch<LocaleProvider>().languageCode;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<Ocean>(
        future: futureOcean,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Terjadi kesalahan:\n${snapshot.error}",
                style: const TextStyle(color: Colors.redAccent),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                "Data samudra tidak tersedia",
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final ocean = snapshot.data!;

          return Stack(
            children: [
              Positioned.fill(child: Container(color: backgroundColor)),
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 100, 16, 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🔹 Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: ocean.imagePath.isNotEmpty
                          ? Image.asset(
                              ocean.imagePath,
                              height: 250,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              height: 250,
                              color: Colors.grey[700],
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 20),

                    /// 🔹 Title
                    Center(
                      child: Text(
                        ocean.getName(lang),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// 🔹 Sections
                    ...ocean.sections.map((section) {
                      final sectionText = section.getText(lang);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            section.getTitle(lang),
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          if (sectionText != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                sectionText,
                                textAlign: TextAlign.justify,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  height: 1.6,
                                  color: textColor.withOpacity(0.9),
                                ),
                              ),
                            ),

                          /// 🔹 Points
                          ...section.points.asMap().entries.map((entry) {
                            final index = entry.key;
                            final point = entry.value;
                            final description = point.getDescription(lang);

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 25,
                                        child: Text(
                                          '${index + 1}.',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: textColor,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          point.getTitle(lang),
                                          textAlign: TextAlign.justify,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            height: 1.5,
                                            color: textColor.withOpacity(0.9),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (description != null)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 33,
                                        top: 4,
                                      ),
                                      child: Text(
                                        description,
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
                          const SizedBox(height: 20),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.arrow_forward, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LinkTreeScreen()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

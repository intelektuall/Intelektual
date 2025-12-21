import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'link_tree_screen.dart';
import '../models/seaLifeModel/ocean.dart';
import '../services/my_http_helper.dart';
import '../services/analytics_mixin.dart';

class DetailScreen extends StatefulWidget {
  final String oceanId;

  const DetailScreen({super.key, required this.oceanId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> with AnalyticsScreenTracking{
  late Future<Ocean> futureOcean;

  @override
  String get screenName => 'DetailScreen';

  @override
  void initState() {
    super.initState();
    futureOcean = fetchOceanDetail(widget.oceanId);
  }

  Future<Ocean> fetchOceanDetail(String id) async {
    final allOceans = await HttpHelper().fetchData(
        'https://68f78975f7fb897c66163a7c.mockapi.io/api/education_sea/seaLifeModel');
    // cari ocean berdasarkan id
    return allOceans.firstWhere(
      (ocean) => ocean.id == id,
      orElse: () => Ocean(id: '', name: 'Tidak ditemukan', imagePath: '', sections: []),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder<Ocean>(
        future: futureOcean,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Terjadi kesalahan: ${snapshot.error}",
                style: const TextStyle(color: Colors.redAccent),
                textAlign: TextAlign.center,
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text(
                "Data samudra tidak tersedia",
                style: TextStyle(color: Colors.white70),
              ),
            );
          } else {
            final ocean = snapshot.data!;
            return Stack(
              children: [
                // Background
                Positioned.fill(
                  child: Image.asset(
                    "assets/images/oceanDetailBackground.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(color: Colors.black.withOpacity(0.3)),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 100, left: 16, right: 16, bottom: 80),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gambar utama
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 10, offset: Offset(0, 4))],
                        ),
                        child: ClipRRect(
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
                                    child: Icon(Icons.image_not_supported, color: Colors.white, size: 50),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Judul utama
                      Center(
                        child: Text(
                          ocean.name,
                          style: GoogleFonts.poppins(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [Shadow(blurRadius: 6, color: Colors.black87)],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Sections & Points
                      ...ocean.sections.map((section) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              section.title,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [Shadow(blurRadius: 4, color: Colors.black)],
                              ),
                            ),
                            if (section.text != null && section.text!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  section.text!,
                                  textAlign: TextAlign.justify,
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    height: 1.6,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ),
                            if (section.points.isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: section.points.map((point) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 25,
                                              alignment: Alignment.topCenter,
                                              child: Text(
                                                "${section.points.indexOf(point) + 1}.",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  shadows: [Shadow(blurRadius: 3, color: Colors.black)],
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
                                                  color: Colors.white.withOpacity(0.9),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (point.description != null)
                                          Padding(
                                            padding: const EdgeInsets.only(left: 33.0, top: 4),
                                            child: Text(
                                              point.description!,
                                              textAlign: TextAlign.justify,
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                height: 1.5,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            const SizedBox(height: 20),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
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

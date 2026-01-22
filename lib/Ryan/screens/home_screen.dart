import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

import '../models/seaLifeModel/ocean.dart';
import '../widgets/sea_life_card.dart';
import '../services/my_http_helper.dart';
import '../services/analytics_mixin.dart';
import '../providers/locale_provider.dart';
import 'detail_screen.dart';

class RyanHomeScreen extends StatefulWidget {
  final HttpHelper httpHelper;

  RyanHomeScreen({super.key, HttpHelper? httpHelper})
    : httpHelper = httpHelper ?? HttpHelper();

  @override
  State<RyanHomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<RyanHomeScreen>
    with AnalyticsScreenTracking {
  late Future<List<Ocean>> futureSeaLife;

  @override
  String get screenName => 'RyanHomeScreen';

  @override
  void initState() {
    super.initState();
    futureSeaLife = widget.httpHelper.fetchSeaLife();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    /// 🔥 Ambil kode bahasa aktif
    final lang = context.watch<LocaleProvider>().languageCode;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/logoOcean-removebg.png", height: 40),
            const SizedBox(width: 10),
            Text(
              "Life Below Water",
              style: GoogleFonts.oswald(
                fontWeight: FontWeight.bold,
                fontSize: 23,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: theme.scaffoldBackgroundColor),
          Container(
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
          Padding(
            padding: const EdgeInsets.only(top: kToolbarHeight + 32),
            child: FutureBuilder<List<Ocean>>(
              future: futureSeaLife,
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

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "Tidak ada data samudra tersedia.",
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                }

                return SeaLifeCarousel(
                  seaLifeItems: snapshot.data!,
                  lang: lang, // 🔥 kirim bahasa aktif
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SeaLifeCarousel extends StatelessWidget {
  final List<Ocean> seaLifeItems;
  final String lang;

  const SeaLifeCarousel({
    super.key,
    required this.seaLifeItems,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 320,
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        viewportFraction: 0.75,
        enableInfiniteScroll: true,
        scrollPhysics: const BouncingScrollPhysics(),
      ),
      items: seaLifeItems.map((ocean) {
        return SeaLifeCard(
          imagePath: ocean.imagePath,
          title: ocean.getName(lang), // ✅ FIX MULTILINGUAL
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailScreen(oceanId: ocean.id),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

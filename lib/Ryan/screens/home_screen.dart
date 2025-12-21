import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/seaLifeModel/ocean.dart';
import '../widgets/sea_life_card.dart';
import '../services/my_http_helper.dart';
import '../services/analytics_mixin.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AnalyticsScreenTracking{
  late Future<List<Ocean>> futureSeaLife;

  @override
  String get screenName => 'HomeScreen';

  @override
  void initState() {
    super.initState();
    futureSeaLife = HttpHelper().fetchData(
      'https://68f78975f7fb897c66163a7c.mockapi.io/api/education_sea/seaLifeModel',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/oceanDetailBackground.jpg",
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.2),
                  Colors.transparent,
                  Colors.black.withOpacity(0.5),
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
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Terjadi kesalahan: ${snapshot.error}",
                      style: const TextStyle(color: Colors.redAccent),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      "Tidak ada data samudra tersedia.",
                      style: TextStyle(color: Colors.white70),
                    ),
                  );
                } else {
                  final seaLifeItems = snapshot.data!;
                  return SeaLifeCarousel(seaLifeItems: seaLifeItems);
                }
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

  const SeaLifeCarousel({super.key, required this.seaLifeItems});

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
        return Builder(
          builder: (BuildContext context) {
            return SeaLifeCard(
              imagePath: ocean.imagePath,
              title: ocean.name,
              onTap: () {
                // Kirim seluruh objek Ocean ke DetailScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(oceanId: ocean.id),
                  ),
                );
              },
            );
          },
        );
      }).toList(),
    );
  }
}

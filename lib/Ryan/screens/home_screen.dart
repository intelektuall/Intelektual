import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/sea_life.dart';
import '../widgets/sea_life_card.dart';
import 'detail_screen.dart';

class RyanHomeScreen extends StatelessWidget {
  const RyanHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.blueAccent : Colors.blueAccent,
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
          Container(
            color: theme.scaffoldBackgroundColor,
          ),
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
            child: SeaLifeCarousel(seaLifeItems: seaLifeList),
          ),
        ],
      ),
    );
  }
}

class SeaLifeCarousel extends StatelessWidget {
  final List<SeaLife> seaLifeItems;

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
      items: seaLifeItems.map((seaLife) {
        return Builder(
          builder: (BuildContext context) {
            return SeaLifeCard(
              imagePath: seaLife.imagePath,
              title: seaLife.name,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(seaLife: seaLife),
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

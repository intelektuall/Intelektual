import 'dart:async';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'Models/news_model.dart';
import 'Widgets/main_news.dart';
import 'Widgets/news_card.dart';

class FauzanNewsHomeScreen extends StatefulWidget {
  const FauzanNewsHomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<FauzanNewsHomeScreen> {
  String? selectedChoice;
  final List<String> choices = ['Latest', 'Trending', 'Recommended'];
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int _currentIndex = 0;
  bool isGrid = false;
  bool _isLoadingNews = false;

  void _toggleView() {
    setState(() {
      _isLoadingNews = true;
    });

    Timer(Duration(seconds: 1), () {
      setState(() {
        isGrid = !isGrid;
        _isLoadingNews = false;
      });
    });
  }

  List<News> get filteredNews {
    if (selectedChoice == null || selectedChoice == 'Latest') {
      List<News> sorted = List.from(newsList);
      sorted.sort((a, b) => b.date.compareTo(a.date));
      return sorted;
    }

    return newsList
        .where(
          (news) =>
              news.category.toLowerCase() == selectedChoice!.toLowerCase(),
        )
        .toList();
  }

  Widget _buildNewsContent() {
    if (_isLoadingNews) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (filteredNews.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(child: Text("Tidak ada berita tersedia.")),
      );
    }

    if (isGrid) {
      return AnimationLimiter(
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: filteredNews.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredGrid(
              position:
                  index, // (1) Menentukan urutan animasi untuk setiap item di grid
              columnCount:
                  2, // (2) Jumlah kolom pada grid, digunakan untuk sinkronisasi animasi
              duration: Duration(
                milliseconds: 800,
              ), // (3) Durasi animasi munculnya item
              child: ScaleAnimation(
                // (4) Efek memperbesar item saat muncul
                child: FadeInAnimation(
                  // (5) Efek memudar saat item muncul
                  child: NewsCard(news: filteredNews[index], isGrid: true),
                ),
              ),
            );
          },
        ),
      );
    } else {
      return AnimationLimiter(
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: filteredNews.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: Duration(milliseconds: 800),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: NewsCard(news: filteredNews[index], isGrid: false),
                ),
              ),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DeepNews"),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(isGrid ? Icons.view_list : Icons.grid_view),
            onPressed: _toggleView,
            tooltip: isGrid ? 'Tampilan List' : 'Tampilan Grid',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (newsList.isNotEmpty) ...[
              Stack(
                children: [
                  AnimationConfiguration.synchronized(
                    duration: Duration(milliseconds: 600),
                    child: SlideAnimation(
                      verticalOffset: -50,
                      child: CarouselSlider(
                        carouselController: _carouselController,
                        options: CarouselOptions(
                          height: 260.0,
                          autoPlay: true,
                          enlargeCenterPage: false,
                          viewportFraction: 1.0,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                        ),
                        items:
                            newsList
                                .map((newsItem) => MainNews(news: newsItem))
                                .toList(),
                      ),
                    ),
                  ),

                  // Positioned dots inside the image (bottom center)
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: AnimationConfiguration.synchronized(
                        duration: Duration(milliseconds: 500),
                        child: FadeInAnimation(
                          child: AnimatedSmoothIndicator(
                            activeIndex:
                                _currentIndex, // (1) Indeks titik yang sedang aktif
                            count: newsList.length, // (2) Total jumlah titik
                            effect: WormEffect(
                              // (3) Efek animasi worm
                              dotHeight: 8, // (4) Tinggi titik
                              dotWidth: 8, // (5) Lebar titik
                              activeDotColor:
                                  Colors.white, // (6) Warna titik aktif
                              dotColor:
                                  Colors.white54, // (7) Warna titik non-aktif
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),
            ],

            // Filter Chip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 5,
                children: List.generate(
                  choices.length,
                  (index) => AnimationConfiguration.staggeredList(
                    position: index,
                    duration: Duration(milliseconds: 400),
                    child: ScaleAnimation(
                      child: ChoiceChip(
                        label: Text(choices[index]),
                        selected: selectedChoice == choices[index],
                        onSelected: (bool selected) {
                          setState(() {
                            selectedChoice = selected ? choices[index] : null;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 10),
            _buildNewsContent(),
          ],
        ),
      ),
    );
  }
}

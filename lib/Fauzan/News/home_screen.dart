import 'dart:async';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:sopan_santun_app/Fauzan/News/Models/news_model.dart';
import 'package:sopan_santun_app/Fauzan/News/Models/news_provider.dart';
import 'package:sopan_santun_app/Fauzan/News/Widgets/main_news.dart';
import 'package:sopan_santun_app/Fauzan/News/Widgets/news_card.dart';

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

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<NewsProvider>(context, listen: false).fetchNews(),
    );
  }

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

  List<News> _filterNews(List<News> allNews) {
    if (selectedChoice == null || selectedChoice == 'Latest') {
      List<News> sorted = List.from(allNews);
      sorted.sort((a, b) => b.date.compareTo(a.date));
      return sorted;
    }
    return allNews
        .where((n) => n.category.toLowerCase() == selectedChoice!.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NewsProvider>(context);
    final newsList = provider.newsList;
    final filteredNews = _filterNews(newsList);

    return Scaffold(
      appBar: AppBar(
        title: const Text("DeepNews"),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(isGrid ? Icons.view_list : Icons.grid_view),
            onPressed: _toggleView,
            tooltip: isGrid ? 'Tampilan List' : 'Tampilan Grid',
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.errorMessage != null
          ? Center(child: Text(provider.errorMessage!))
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (newsList.isNotEmpty) ...[
                    Stack(
                      children: [
                        AnimationConfiguration.synchronized(
                          duration: const Duration(milliseconds: 600),
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
                              items: newsList
                                  .map((newsItem) => MainNews(news: newsItem))
                                  .toList(),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 12,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: AnimatedSmoothIndicator(
                              activeIndex: _currentIndex,
                              count: newsList.length,
                              effect: const WormEffect(
                                dotHeight: 8,
                                dotWidth: 8,
                                activeDotColor: Colors.white,
                                dotColor: Colors.white54,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Wrap(
                      spacing: 5,
                      children: choices.map((choice) {
                        return ChoiceChip(
                          label: Text(choice),
                          selected: selectedChoice == choice,
                          onSelected: (bool selected) {
                            setState(() {
                              selectedChoice = selected ? choice : null;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _isLoadingNews
                      ? const Center(child: CircularProgressIndicator())
                      : filteredNews.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text("Tidak ada berita tersedia."),
                          ),
                        )
                      : isGrid
                      ? GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredNews.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredGrid(
                              position: index,
                              columnCount: 2,
                              duration: const Duration(milliseconds: 800),
                              child: ScaleAnimation(
                                child: FadeInAnimation(
                                  child: NewsCard(
                                    news: filteredNews[index],
                                    isGrid: true,
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: filteredNews.length,
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 800),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: NewsCard(
                                    news: filteredNews[index],
                                    isGrid: false,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
    );
  }
}

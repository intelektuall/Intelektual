import '/Fauzan/News/detail_screen.dart';
import 'package:flutter/material.dart';
import '../Models/news_model.dart';

class MainNews extends StatelessWidget {
  final News news;

  const MainNews({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              imageUrl: news.imageUrl,
              headline: news.headline,
              newsbody: news.content,
              synopsis: news.content,
              date: news.date,
            ),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 260,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(news.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 260,
            color: Colors.black.withOpacity(0.4),
          ),
          Positioned(
            left: 16,
            bottom: 20,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news.headline,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  news.content,
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

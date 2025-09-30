import 'package:flutter/material.dart';
import 'SeeAllScreen.dart';

class DetailScreen extends StatelessWidget {
  final String animalName;

  DetailScreen({required this.animalName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(animalName),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Text("Detail tentang $animalName"),
      ),
    );
  }
}

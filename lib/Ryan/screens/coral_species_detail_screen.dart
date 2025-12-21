import 'package:flutter/material.dart';
import '../models/coral_species.dart';

class CoralSpeciesDetailScreen extends StatelessWidget {
  final CoralSpecies coralSpecies;

  const CoralSpeciesDetailScreen({super.key, required this.coralSpecies});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(coralSpecies.name),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Image.asset(
            coralSpecies.imagePath,
            width: double.infinity,
            height: 250,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              coralSpecies.description,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}

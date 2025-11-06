import 'threats_generator.dart';
import 'funfacts_generator.dart';
import 'images_generator.dart';

class AnimalDetail {
  final int id;
  final String scientificName;
  final String category;
  final String description;
  final String diet;
  final String size;
  final String weight;
  final String lifespan;
  final String habitat;
  final String conservationStatus;
  final List<Threat> threats;
  final List<FunFact> funFacts;
  final List<ImageData> images;

  AnimalDetail({
    required this.id,
    required this.scientificName,
    required this.category,
    required this.description,
    required this.diet,
    required this.size,
    required this.weight,
    required this.lifespan,
    required this.habitat,
    required this.conservationStatus,
    required this.threats,
    required this.funFacts,
    required this.images,
  });

  factory AnimalDetail.fromJson(Map<String, dynamic> json) {
    return AnimalDetail(
      id: json['id'] ?? 0,
      scientificName: json['scientific_name'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      diet: json['diet'] ?? '',
      size: json['size'] ?? '',
      weight: json['weight'] ?? '',
      lifespan: json['lifespan'] ?? '',
      habitat: json['habitat'] ?? '',
      conservationStatus: json['conservation_status'] ?? '',
      threats: (json['threats'] as List?)
          ?.map((e) => Threat.fromJson({'name': e}))
          .toList() ?? [],
      funFacts: (json['fun_facts'] as List?)
          ?.map((e) => FunFact.fromJson({'text': e}))
          .toList() ?? [],
      images: (json['images'] as List?)
          ?.map((e) => ImageData.fromJson({'url': e}))
          .toList() ?? [],
    );
  }
}
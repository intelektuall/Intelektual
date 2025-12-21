import 'section.dart';

class Ocean {
  final String id;
  final String name;
  final String imagePath;
  final List<Section> sections;

  Ocean({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.sections,
  });

  factory Ocean.fromJson(Map<String, dynamic> json) {
    final rawSections = json['sections'];
    List<Section> parsedSections = [];

    if (rawSections is List) {
      parsedSections =
          rawSections
              .whereType<Map<String, dynamic>>() // hanya ambil yang Map
              .map((item) => Section.fromJson(item))
              .toList();
    }
    return Ocean(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      imagePath: json['imagePath'] ?? '',
      sections: parsedSections,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'sections': sections.map((s) => s.toJson()).toList(),
    };
  }

  Ocean copyWith({
    String? id,
    String? name,
    String? imagePath,
    List<Section>? sections,
  }) {
    return Ocean(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      sections: sections ?? this.sections,
    );
  }
}

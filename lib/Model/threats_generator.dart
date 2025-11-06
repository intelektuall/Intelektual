class Threat {
  final String name;

  Threat({required this.name});

  factory Threat.fromJson(Map<String, dynamic> json) {
    return Threat(name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() => {'name': name};
}
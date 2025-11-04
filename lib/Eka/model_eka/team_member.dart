// Eka/model_eka/team_member.dart
class TeamMember {
  final String id;
  final String name;
  final String status;
  final String image;
  final String whatsapp;

  TeamMember({
    required this.id,
    required this.name,
    required this.status,
    required this.image,
    required this.whatsapp,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      status: json['status'] ?? 'Member',
      image: json['image'] ?? '',
      whatsapp: json['whatsapp'] ?? '',
    );
  }
}

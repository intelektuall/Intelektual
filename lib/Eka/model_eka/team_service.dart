// Eka/model_eka/team_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/Eka/model_eka/team_member.dart';

class TeamService {
  final String apiUrl =
      'https://68f088b30b966ad500333190.mockapi.io/Teammember';

  Future<List<TeamMember>> fetchTeamMembers() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => TeamMember.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat data tim');
    }
  }
}

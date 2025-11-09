// /Eka/model_eka/team_service.dart
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

      return data.map((item) {
        // ambil id dari API
        final id = item['id'] ?? '0';

        // tentukan path gambar lokal berdasarkan id
        final localImagePath = 'assets/images/$id.jpg';

        // jika tidak ada file sesuai, gunakan default
        final imagePath = (id == '0')
            ? 'assets/images/default_avatar.png'
            : localImagePath;

        return TeamMember.fromJson({...item, 'image': imagePath});
      }).toList();
    } else {
      throw Exception('Gagal memuat data tim');
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/seaLifeModel/ocean.dart';

class HttpHelper {
  final http.Client client;
  final String baseUrl;

  HttpHelper({
    http.Client? client,
    this.baseUrl =
        'https://mocki.io/v1/ba7843ef-37f5-4211-ad59-283fc305f8ec',
  }) : client = client ?? http.Client();

  Future<List<Ocean>> fetchSeaLife() async {
    final url = Uri.parse(baseUrl);

    final response = await client.get(url);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      /// 🔥 pastikan response adalah LIST
      if (decoded is List) {
        return decoded
            .whereType<Map<String, dynamic>>()
            .map((json) => Ocean.fromJson(json))
            .toList();
      } else {
        throw Exception('Unexpected API format: not a list');
      }
    } else {
      throw Exception(
        'Failed to fetch data: ${response.statusCode}',
      );
    }
  }

  /// Optional (best practice)
  void dispose() {
    client.close();
  }
}

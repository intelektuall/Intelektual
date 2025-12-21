import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/seaLifeModel/ocean.dart';

class HttpHelper {
  Future<List<Ocean>> fetchData(String uri) async {
    final url = Uri.parse(uri);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      // Mapping data JSON ke model Ocean
      final oceans = data.map((oceanData) => Ocean.fromJson(oceanData)).toList();

      return oceans;
    } else {
      throw Exception("Failed to fetch data: ${response.statusCode}");
    }
  }
}

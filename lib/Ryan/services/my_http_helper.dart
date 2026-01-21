// lib/services/my_http_helper.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/seaLifeModel/ocean.dart';

class HttpHelper {
  final http.Client client;
  final String baseUrl;
  
  HttpHelper({
    http.Client? client,
    this.baseUrl = 'https://68f78975f7fb897c66163a7c.mockapi.io/api/education_sea',
  }) : client = client ?? http.Client();

  Future<List<Ocean>> fetchSeaLife() async {
    final url = Uri.parse('$baseUrl/seaLifeModel');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((oceanData) => Ocean.fromJson(oceanData)).toList();
    } else {
      throw Exception("Failed to fetch data: ${response.statusCode}");
    }
  }
}
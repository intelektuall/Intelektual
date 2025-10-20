import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Models/news_model.dart';

class NewsProvider with ChangeNotifier {
  List<News> _newsList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<News> get newsList => _newsList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchNews() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final url = Uri.parse(
      'https://68eff114b06cc802829f3aac.mockapi.io/news_data',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _newsList = data.map((item) => News.fromJson(item)).toList();
      } else {
        _errorMessage = 'Gagal memuat data (${response.statusCode})';
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

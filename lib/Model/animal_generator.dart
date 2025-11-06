import 'dart:convert';
import 'package:http/http.dart' as http;
import 'details_generator.dart';

class Animal {
  final String id;
  final String name;
  final String count;
  final String location;
  final String image;
  final String status;
  final DateTime timestamp;
  final List<AnimalDetail> details;

  Animal({
    required this.id,
    required this.name,
    required this.count,
    required this.location,
    required this.image,
    required this.status,
    required this.timestamp,
    required this.details,
  });

  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      count: json['count'] ?? '',
      location: json['location'] ?? '',
      image: json['image'] ?? 'assets/images/default_animal.jpg',
      status: json['status'] ?? 'Tidak Dilindungi',
      timestamp: _parseTimestamp(json['timestamp']),
      details: (json['details'] as List?)
          ?.map((e) => AnimalDetail.fromJson(e))
          .toList() ?? [],
    );
  }

  // 🔧 FIX: Method untuk parsing timestamp yang aman
  static DateTime _parseTimestamp(dynamic timestamp) {
    try {
      if (timestamp == null) {
        return DateTime.now();
      }
      
      if (timestamp is DateTime) {
        return timestamp;
      }
      
      if (timestamp is String) {
        // Handle format ISO 8601 dengan Z
        if (timestamp.endsWith('Z')) {
          return DateTime.parse(timestamp);
        }
        // Handle format tanpa Z
        return DateTime.parse(timestamp);
      }
      
      // Fallback ke DateTime.now()
      return DateTime.now();
    } catch (e) {
      print('❌ Error parsing timestamp: $timestamp, error: $e');
      return DateTime.now();
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'count': count,
      'location': location,
      'image': image,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
      'details': details.map((detail) => {
        'id': detail.id,
        'scientific_name': detail.scientificName,
        'category': detail.category,
        'description': detail.description,
        'diet': detail.diet,
        'size': detail.size,
        'weight': detail.weight,
        'lifespan': detail.lifespan,
        'habitat': detail.habitat,
        'conservation_status': detail.conservationStatus,
        'threats': detail.threats.map((threat) => threat.name).toList(),
        'fun_facts': detail.funFacts.map((fact) => fact.text).toList(),
        'images': detail.images.map((img) => img.url).toList(),
      }).toList(),
    };
  }
}

/// Fungsi untuk mengambil data dari API
Future<List<Animal>> fetchAnimals() async {
  const url = 'https://68f94e0edeff18f212b93351.mockapi.io/hatami/01/animal';
  
  try {
    print('🔄 Mengambil data dari: $url');
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print('📡 Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final dynamic responseData = jsonDecode(response.body);
      
      List<dynamic> animalsData;
      
      // Handle nested structure: [{"animals": [...]}]
      if (responseData is List && responseData.isNotEmpty) {
        if (responseData[0] is Map && responseData[0]['animals'] != null) {
          animalsData = responseData[0]['animals'];
          print('📊 Struktur data: Nested dengan key "animals"');
        } else {
          animalsData = responseData;
          print('📊 Struktur data: Array langsung');
        }
      } else {
        animalsData = [];
      }
      
      print('✅ Data berhasil diambil dari API: ${animalsData.length} items');
      
      // Debug: Print timestamp untuk troubleshooting
      for (var data in animalsData) {
        print('⏰ Timestamp untuk ${data['name']}: ${data['timestamp']} (type: ${data['timestamp'].runtimeType})');
      }
      
      final animals = animalsData.map((json) => Animal.fromJson(json)).toList();
      
      // Debug: Print semua nama hewan yang berhasil di-load
      for (var animal in animals) {
        print('🐠 ${animal.name} - ${animal.location} - ${animal.status} - ${animal.timestamp}');
      }
      
      return animals;
    } else {
      print('❌ Gagal mengambil data. Status code: ${response.statusCode}');
      throw Exception('Gagal mengambil data dari API. Status: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Error fetching animals: $e');
    throw Exception('Gagal terhubung ke server: $e');
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/hewan_provider.dart';
import '../Model/animal_generator.dart';

class DetailScreen extends StatelessWidget {
  final String animalName;

  const DetailScreen({super.key, required this.animalName});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<HewanProvider>();
    
    // Cari hewan dari data API
    final animal = provider.allAnimals.firstWhere(
      (animal) => animal['name'] == animalName,
      orElse: () => {},
    );

    // Debug info
    print('🔍 DetailScreen mencari: $animalName');
    print('📊 Total data tersedia: ${provider.allAnimals.length}');
    if (animal.isEmpty) {
      print('❌ Hewan tidak ditemukan: $animalName');
    } else {
      print('✅ Hewan ditemukan: ${animal['name']}');
    }

    // Jika hewan tidak ditemukan
    if (animal.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(animalName),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Data hewan tidak ditemukan',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(animalName),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildDetailContent(animal, isDark),
    );
  }

  Widget _buildDetailContent(Map<String, dynamic> animal, bool isDark) {
    // Ambil detail pertama dari array details
    final details = animal['details'] is List && (animal['details'] as List).isNotEmpty
        ? (animal['details'] as List).first
        : {};

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan gambar
          _buildHeaderSection(animal, isDark),
          SizedBox(height: 24),
          
          // Informasi dasar dari API
          if (details.isNotEmpty) ...[
            _buildBasicInfoSection(details, isDark),
            SizedBox(height: 24),
            
            // Statistik fisik dari API
            _buildPhysicalStatsSection(details, isDark),
            SizedBox(height: 24),
            
            // Fakta menarik dari API
            if ((details['fun_facts'] as List?)?.isNotEmpty ?? false) ...[
              _buildFunFactsSection(details, isDark),
              SizedBox(height: 24),
            ],
            
            // Ancaman dari API
            if ((details['threats'] as List?)?.isNotEmpty ?? false) ...[
              _buildThreatsSection(details, isDark),
              SizedBox(height: 24),
            ],
          ] else ...[
            // Fallback jika tidak ada details
            _buildNoDetailsSection(isDark),
          ],
        ],
      ),
    );
  }

  Widget _buildHeaderSection(Map<String, dynamic> animal, bool isDark) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.asset(
              animal['image'],
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 250,
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.image,
                    size: 64,
                    color: Colors.grey[600],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  animal['name'],
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 18, color: Colors.blueAccent),
                    SizedBox(width: 6),
                    Text(
                      animal['location'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.insights, size: 18, color: Colors.green),
                    SizedBox(width: 6),
                    Text(
                      'Populasi: ${animal['count']} ekor',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: animal['status'] == 'Dilindungi' 
                        ? Colors.redAccent.withOpacity(0.1) 
                        : Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: animal['status'] == 'Dilindungi' 
                          ? Colors.redAccent 
                          : Colors.green,
                    ),
                  ),
                  child: Text(
                    animal['status'],
                    style: TextStyle(
                      color: animal['status'] == 'Dilindungi' 
                          ? Colors.redAccent 
                          : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection(Map<String, dynamic> details, bool isDark) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: Colors.blueAccent),
                SizedBox(width: 8),
                Text(
                  'Informasi Dasar',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            if (details['scientific_name'] != null && details['scientific_name'].isNotEmpty)
              _buildDetailRow('Nama Ilmiah', details['scientific_name'], isDark),
            if (details['category'] != null && details['category'].isNotEmpty)
              _buildDetailRow('Kategori', details['category'], isDark),
            if (details['habitat'] != null && details['habitat'].isNotEmpty)
              _buildDetailRow('Habitat', details['habitat'], isDark),
            if (details['conservation_status'] != null && details['conservation_status'].isNotEmpty)
              _buildDetailRow('Status Konservasi', details['conservation_status'], isDark),
            if (details['diet'] != null && details['diet'].isNotEmpty)
              _buildDetailRow('Makanan', details['diet'], isDark),
            if (details['lifespan'] != null && details['lifespan'].isNotEmpty)
              _buildDetailRow('Rentang Hidup', details['lifespan'], isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildPhysicalStatsSection(Map<String, dynamic> details, bool isDark) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.straighten, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Statistik Fisik',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (details['size'] != null && details['size'].isNotEmpty)
                  _buildStatCard('Ukuran', details['size'], Icons.straighten, Colors.blue),
                if (details['weight'] != null && details['weight'].isNotEmpty)
                  _buildStatCard('Berat', details['weight'], Icons.fitness_center, Colors.orange),
              ],
            ),
            SizedBox(height: 16),
            if (details['description'] != null && details['description'].isNotEmpty) ...[
              Divider(),
              SizedBox(height: 16),
              Text(
                'Deskripsi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Text(
                details['description'],
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFunFactsSection(Map<String, dynamic> details, bool isDark) {
    final funFacts = details['fun_facts'] as List;
    
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.emoji_objects, color: Colors.amber),
                SizedBox(width: 8),
                Text(
                  'Fakta Menarik',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Column(
              children: funFacts.map((fact) => _buildFunFactItem(fact.toString(), isDark)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThreatsSection(Map<String, dynamic> details, bool isDark) {
    final threats = details['threats'] as List;
    
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning, color: Colors.redAccent),
                SizedBox(width: 8),
                Text(
                  'Ancaman',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: threats.map((threat) => _buildThreatChip(threat.toString(), isDark)).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoDetailsSection(bool isDark) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.info_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Detail lengkap belum tersedia',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Informasi detail untuk hewan ini sedang dalam pengembangan.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.grey[300] : Colors.grey[700],
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: 120,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFunFactItem(String fact, bool isDark) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.emoji_objects, color: Colors.amber, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              fact,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThreatChip(String threat, bool isDark) {
    return Chip(
      label: Text(
        threat,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
      backgroundColor: Colors.redAccent,
      visualDensity: VisualDensity.compact,
    );
  }
}
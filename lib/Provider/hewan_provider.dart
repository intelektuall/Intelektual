import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'db_helper.dart';
import 'event_model.dart';
import '../Model/animal_generator.dart';

class HewanProvider extends ChangeNotifier {
  // === DATA DARI API ===
  List<Animal> _apiAnimals = [];
  bool _isLoadingApi = false;
  String? _apiError;

  // === DATA LOKAL (FALLBACK) ===
  final List<Map<String, dynamic>> _protectedAnimals = [
    {
      "name": "Paus pembunuh palsu",
      "count": "250",
      "location": "Samudra Pasifik",
      "image": "assets/images/paus_pembunuh_palsu.jpg",
      "status": "Dilindungi",
      "timestamp": DateTime(2022, 1, 1),
    },
    {
      "name": "Cumi-cumi vampir",
      "count": "620",
      "location": "Samudra Atlantik",
      "image": "assets/images/cumi_cumi_vampir.jpeg",
      "status": "Dilindungi",
      "timestamp": DateTime(2023, 3, 1),
    },
    {
      "name": "Ikan kodok",
      "count": "700",
      "location": "Samudra Pasifik",
      "image": "assets/images/ikan_kodok.jpg",
      "status": "Dilindungi",
      "timestamp": DateTime(2024, 4, 10),
    },
    {
      "name": "Ikan sturgeon",
      "count": "800",
      "location": "Samudra Hindia",
      "image": "assets/images/ikan_sturgeon.jpg",
      "status": "Dilindungi",
      "timestamp": DateTime(2024, 6, 15),
    },
    {
      "name": "Ikan hiu martil",
      "count": "1.200",
      "location": "Samudra Pasifik",
      "image": "assets/images/Hewan2.png",
      "status": "Tidak Dilindungi",
      "timestamp": DateTime(2023, 6, 20),
    },
    {
      "name": "Ubur-ubur kristal",
      "count": "950",
      "location": "Samudra Atlantik",
      "image": "assets/images/Hewan4.png",
      "status": "Tidak Dilindungi",
      "timestamp": DateTime(2022, 11, 5),
    },
    {
      "name": "Anemon laut",
      "count": "500",
      "location": "Samudra Hindia",
      "image": "assets/images/Hewan3.png",
      "status": "Tidak Dilindungi",
      "timestamp": DateTime(2023, 1, 12),
    },
    {
      "name": "Ikan gergaji",
      "count": "600",
      "location": "Samudra Selatan",
      "image": "assets/images/Hewan1.png",
      "status": "Tidak Dilindungi",
      "timestamp": DateTime(2023, 9, 30),
    },
    {
      "name": "Anjing laut arktik",
      "count": "300",
      "location": "Samudra Arktik",
      "image": "assets/images/Hewan5.png",
      "status": "Tidak Dilindungi",
      "timestamp": DateTime(2022, 7, 10),
    },
  ];

  // === DATABASE & FORM ===
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Submission> _databaseSubmissions = [];
  List<Submission> _pendingSubmissions = [];
  bool _isLoading = false;

  final FormController formController = FormController();

  // === GETTERS YANG BERUBAH ===
  List<Animal> get apiAnimals => _apiAnimals;
  bool get isLoadingApi => _isLoadingApi;
  String? get apiError => _apiError;

  // Data gabungan: API data + fallback data lokal
  List<Map<String, dynamic>> get allAnimals {
    if (_apiAnimals.isNotEmpty) {
      // Gunakan data dari API
      return _apiAnimals.map((animal) => animal.toMap()).toList();
    } else {
      // Fallback ke data lokal kosong (akan diisi oleh API)
      return [];
    }
  }

  List<Map<String, dynamic>> get protectedAnimals {
    final animals = allAnimals;
    return animals.where((e) => e['status'] == 'Dilindungi').toList();
  }

  // === GETTERS LAINNYA TETAP SAMA ===
  List<Map<String, dynamic>> get submissions {
    return _databaseSubmissions
        .where((submission) => submission.isSynced)
        .map((submission) => _submissionToMap(submission))
        .toList();
  }

  List<Submission> get databaseSubmissions => _databaseSubmissions;
  List<Submission> get pendingSubmissions => _pendingSubmissions;
  bool get isLoading => _isLoading;

  static const String _lastUpdateKey = 'last_update_time';

  bool _selectedCB1 = false;
  bool get selectedCB1 => _selectedCB1;
  set selectedCB1(bool value) {
    _selectedCB1 = value;
    notifyListeners();
  }

  bool _selectedCB2 = false;
  bool get selectedCB2 => _selectedCB2;
  set selectedCB2(bool value) {
    _selectedCB2 = value;
    notifyListeners();
  }

  static const List<List<double>> _chartData = [
    [12000, 15000, 6000],
    [8000, 10000, 4000],
    [7500, 9500, 4000],
    [3500, 4500, 1000],
    [2000, 2500, 500],
  ];

  List<BarChartGroupData> get barChartGroups => List.generate(
    _chartData.length,
    (index) => BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(toY: _chartData[index][0], color: Colors.red, width: 12),
        BarChartRodData(toY: _chartData[index][1], color: Colors.blueAccent, width: 12),
        BarChartRodData(toY: _chartData[index][2], color: Colors.green, width: 12),
      ],
    ),
  );

  String? _selectedLocation;
  String? get selectedLocation => _selectedLocation;
  set selectedLocation(String? value) {
    _selectedLocation = value;
    notifyListeners();
  }

  String? _selectedType;
  String? get selectedType => _selectedType;
  set selectedType(String? value) {
    _selectedType = value;
    notifyListeners();
  }

  bool _showWelcomeBanner = true;
  bool get showWelcomeBanner => _showWelcomeBanner;
  set showWelcomeBanner(bool value) {
    _showWelcomeBanner = value;
    notifyListeners();
  }

  // === CONSTRUCTOR ===
  HewanProvider() {
    loadSubmissions();
    fetchAnimalsFromAPI(); // Otomatis ambil data dari API saat startup
  }

  // === METHOD BARU: AMBIL DATA DARI API ===
  Future<void> fetchAnimalsFromAPI() async {
    _isLoadingApi = true;
    _apiError = null;
    notifyListeners();

    try {
      print('🔄 Memulai fetchAnimalsFromAPI...');
      _apiAnimals = await fetchAnimals();
      print('✅ Data API berhasil diambil: ${_apiAnimals.length} hewan');
      _isLoadingApi = false;
      notifyListeners();
    } catch (e) {
      _isLoadingApi = false;
      _apiError = e.toString();
      print('❌ Error mengambil data API: $e');
      notifyListeners();
      
      // Tampilkan snackbar error
      Get.snackbar(
        'Error',
        'Gagal mengambil data dari server.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }

  // === METHOD DATABASE (TIDAK BERUBAH) ===
  Future<void> loadSubmissions() async {
    _isLoading = true;
    notifyListeners();

    try {
      print('📥 Memuat data dari database...');
      final submissionsMap = await _dbHelper.getSubmissions();
      _databaseSubmissions = submissionsMap.map((map) => Submission.fromMap(map)).toList();
      
      final pendingMap = await _dbHelper.getUnsyncedSubmissions();
      _pendingSubmissions = pendingMap.map((map) => Submission.fromMap(map)).toList();
      
      print('✅ Data berhasil dimuat: ${_databaseSubmissions.length} submissions');
      print('📋 Pending submissions: ${_pendingSubmissions.length}');
    } catch (e) {
      print('❌ Error loading submissions: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // CREATE - Add new submission
  Future<void> addSubmission(Map<String, dynamic> submission) async {
    try {
      final submissionMap = {
        'name': submission['name'],
        'type': submission['type'],
        'location': submission['location'],
        'count': submission['count'],
        'desc': submission['desc'],
        'imagePath': submission['image'],
        'timestamp': submission['timestamp'].toIso8601String(),
        'status': 'Pending',
        'isSynced': 0,
      };

      final id = await _dbHelper.insertSubmission(submissionMap);
      print('✅ Data berhasil disimpan ke database dengan ID: $id');
      
      await loadSubmissions();
      
      Get.snackbar(
        'Berhasil',
        'Pengajuan berhasil dikirim',
        duration: Duration(seconds: 3),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('❌ Error menyimpan data: $e');
      Get.snackbar(
        'Error',
        'Gagal mengirim pengajuan: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  // READ - Get submission by ID
  Future<Submission?> getSubmissionById(int id) async {
    try {
      final submissionMap = await _dbHelper.getSubmissionById(id);
      return submissionMap != null ? Submission.fromMap(submissionMap) : null;
    } catch (e) {
      print('Error getting submission by ID: $e');
      return null;
    }
  }

  // UPDATE - Update submission status
  Future<void> updateSubmissionStatus(int id, String status) async {
    try {
      await _dbHelper.updateSubmissionStatus(id, status);
      await loadSubmissions();
      
      Get.snackbar(
        'Berhasil',
        'Status berhasil diupdate',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal update status: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  // UPDATE - Update entire submission
  Future<void> updateSubmission(int id, Map<String, dynamic> submission) async {
    try {
      final submissionMap = {
        'name': submission['name'],
        'type': submission['type'],
        'location': submission['location'],
        'count': submission['count'],
        'desc': submission['desc'],
        'imagePath': submission['image'],
        'timestamp': submission['timestamp'].toIso8601String(),
        'status': submission['status'],
      };

      await _dbHelper.updateSubmission(id, submissionMap);
      await loadSubmissions();
      
      Get.snackbar(
        'Berhasil',
        'Data berhasil diupdate',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal update data: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  // DELETE - Delete submission
  Future<void> deleteSubmission(int id) async {
    try {
      await _dbHelper.deleteSubmission(id);
      await loadSubmissions();
      
      Get.snackbar(
        'Berhasil',
        'Data berhasil dihapus',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghapus data: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  // SYNC - Sync pending submissions
  Future<void> syncPendingSubmissions() async {
    try {
      print('🔄 Memulai sync ${_pendingSubmissions.length} submissions...');
      
      for (final submission in _pendingSubmissions) {
        if (submission.id != null) {
          await _dbHelper.updateSubmissionStatus(submission.id!, 'Approved');
          await _dbHelper.updateSyncStatus(submission.id!, true);
          print('✅ Synced submission: ${submission.name}');
        }
      }
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastUpdateKey, DateTime.now().toIso8601String());
      
      await loadSubmissions();
      
      print('✅ Sync completed successfully');
    } catch (e) {
      print('❌ Error syncing submissions: $e');
      rethrow;
    }
  }

  // Get last update time from SharedPreferences
  Future<DateTime?> getLastUpdateTime() async {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdate = prefs.getString(_lastUpdateKey);
    return lastUpdate != null ? DateTime.parse(lastUpdate) : null;
  }

  // Clear all data
  Future<void> clearAllData() async {
    try {
      await _dbHelper.deleteAllSubmissions();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_lastUpdateKey);
      await loadSubmissions();
      
      Get.snackbar(
        'Berhasil',
        'Semua data berhasil dihapus',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghapus data: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  // Get submissions count
  Future<int> getSubmissionsCount() async {
    return await _dbHelper.getSubmissionsCount();
  }

  // === METHOD HEWAN (DIMODIFIKASI UNTUK GUNAKAN DATA GABUNGAN) ===
  void addProtectedAnimal(Map<String, dynamic> newAnimal) {
    try {
      // Tambah ke data lokal saja (tidak ke API)
      _protectedAnimals.add({
        ...newAnimal,
        'timestamp': DateTime.now(),
      });
      notifyListeners();
      Get.snackbar(
        'Berhasil',
        'Hewan baru berhasil ditambahkan',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menambahkan hewan: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  List<Map<String, dynamic>> getAnimalsSortedByDate(bool newestFirst) {
    try {
      final sorted = [...allAnimals];
      sorted.sort((a, b) {
        final dateA = a['timestamp'] as DateTime;
        final dateB = b['timestamp'] as DateTime;
        return newestFirst ? dateB.compareTo(dateA) : dateA.compareTo(dateB);
      });
      return sorted;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengurutkan data: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return allAnimals;
    }
  }

  List<Map<String, dynamic>> filterByLocation(String location) {
    try {
      return allAnimals.where((e) => e['location'] == location).toList();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memfilter data: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return allAnimals;
    }
  }

  // === HELPER METHODS ===
  Map<String, dynamic> _submissionToMap(Submission submission) {
    return {
      'id': submission.id,
      'name': submission.name,
      'type': submission.type,
      'location': submission.location,
      'count': submission.count,
      'desc': submission.desc,
      'image': submission.imagePath,
      'timestamp': submission.timestamp,
      'status': submission.status,
      'isSynced': submission.isSynced,
    };
  }
}

// === FORM CONTROLLER (TIDAK BERUBAH) ===
class FormController extends GetxController {
  final formKey = GlobalKey<FormBuilderState>();
  final nameController = TextEditingController();
  final countController = TextEditingController();
  final descController = TextEditingController();
  
  final selectedType = ''.obs;
  final selectedLocation = ''.obs;
  final isAgreed = false.obs;

  void resetForm() {
    formKey.currentState?.reset();
    nameController.clear();
    countController.clear();
    descController.clear();
    selectedType.value = '';
    selectedLocation.value = '';
    isAgreed.value = false;
  }

  bool validateForm() {
    if (formKey.currentState?.saveAndValidate() ?? false) {
      if (selectedType.value.isEmpty || selectedLocation.value.isEmpty) {
        Get.snackbar(
          'Form Tidak Lengkap',
          'Harap pilih jenis dan lokasi hewan',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return false;
      }
      return true;
    }
    return false;
  }

  @override
  void onClose() {
    nameController.dispose();
    countController.dispose();
    descController.dispose();
    super.onClose();
  }
  
}


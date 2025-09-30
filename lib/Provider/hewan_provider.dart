import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class HewanProvider extends ChangeNotifier {
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
    // Hewan tidak dilindungi
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
  
  final List<Map<String, dynamic>> _submissions = [];

  // Form Controller using GetX
  final FormController formController = FormController();

  // Getters
  List<Map<String, dynamic>> get allAnimals => [..._protectedAnimals];
  List<Map<String, dynamic>> get protectedAnimals =>
      _protectedAnimals.where((e) => e['status'] == 'Dilindungi').toList();
  List<Map<String, dynamic>> get submissions => [..._submissions];

  // Checkbox states (keep your existing checkbox logic)
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

  // Data untuk chart
  static const List<List<double>> _chartData = [
    [12000, 15000, 6000], // Pasifik
    [8000, 10000, 4000],  // Atlantik
    [7500, 9500, 4000],   // Hindia
    [3500, 4500, 1000],   // Selatan
    [2000, 2500, 500],    // Arktik
  ];

  List<BarChartGroupData> get barChartGroups => List.generate(
    _chartData.length,
    (index) => BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
          toY: _chartData[index][0], 
          color: Colors.red,
          width: 12,
        ),
        BarChartRodData(
          toY: _chartData[index][1], 
          color: Colors.blueAccent,
          width: 12,
        ),
        BarChartRodData(
          toY: _chartData[index][2], 
          color: Colors.green,
          width: 12,
        ),
      ],
    ),
  );

  // Filter states (keep your existing filter logic)
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

  // Welcome banner state (keep your existing banner logic)
  bool _showWelcomeBanner = true;
  bool get showWelcomeBanner => _showWelcomeBanner;
  set showWelcomeBanner(bool value) {
    _showWelcomeBanner = value;
    notifyListeners();
  }

  // 1. Improved Animal Addition Method
  void addProtectedAnimal(Map<String, dynamic> newAnimal) {
    try {
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

  // 2. Improved Submission Method
  void addSubmission(Map<String, dynamic> submission) {
    try {
      _submissions.add({
        ...submission,
        'status': 'Pending',
        'timestamp': DateTime.now(),
      });
      notifyListeners();
      
      // Reset form after successful submission
      formController.resetForm();
      
      Get.snackbar(
        'Berhasil',
        'Pengajuan berhasil dikirim',
        duration: Duration(seconds: 3),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengirim pengajuan: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // 3. Enhanced Sorting Method
  List<Map<String, dynamic>> getAnimalsSortedByDate(bool newestFirst) {
    try {
      final sorted = [..._protectedAnimals];
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
      return _protectedAnimals;
    }
  }

  // 4. Enhanced Filter Method
  List<Map<String, dynamic>> filterByLocation(String location) {
    try {
      return _protectedAnimals.where((e) => e['location'] == location).toList();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memfilter data: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return _protectedAnimals;
    }
  }
}

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
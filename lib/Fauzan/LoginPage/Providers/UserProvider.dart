import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic>? _userData;
  bool _isLoading = false;

  Map<String, dynamic>? get userData => _userData;
  bool get isLoading => _isLoading;

  /// Ambil data user dari Firestore berdasarkan UID
  Future<void> fetchUserData(String uid) async {
    _isLoading = true;
    notifyListeners();

    try {
      final doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .get();
      _userData = doc.data();
    } catch (e) {
      debugPrint("Gagal mengambil data user: $e");
      _userData = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Update data user di Firestore
  Future<void> updateUserData(String uid, Map<String, dynamic> updates) async {
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .update(updates);

      // Perbarui data lokal juga
      _userData?.addAll(updates);
      notifyListeners();
    } catch (e) {
      debugPrint("Gagal memperbarui data user: $e");
    }
  }

  /// Reset semua data (misalnya saat logout)
  void clearUserData() {
    _userData = null;
    notifyListeners();
  }
}

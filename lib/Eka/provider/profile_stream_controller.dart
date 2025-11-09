import 'dart:async';

class ProfileStreamController {
  // Singleton instance (hanya ada satu di seluruh aplikasi)
  static final ProfileStreamController _instance =
      ProfileStreamController._internal();

  factory ProfileStreamController() => _instance;

  ProfileStreamController._internal();

  // StreamController dengan broadcast agar bisa didengar dari banyak halaman
  final StreamController<Map<String, dynamic>> _controller =
      StreamController<Map<String, dynamic>>.broadcast();

  // Stream untuk mendengarkan perubahan data profil
  Stream<Map<String, dynamic>> get stream => _controller.stream;

  // Fungsi untuk mengirim data profil baru ke semua listener
  void updateData(Map<String, dynamic> data) {
    _controller.add(data);
  }

  // Menutup stream jika tidak digunakan
  void dispose() {
    _controller.close();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// 🔹 Simpan atau update data profil (termasuk Base64 gambar)
  Future<void> saveProfileData(
    Map<String, dynamic> data, [
    String? userId,
  ]) async {
    try {
      // Jika userId tidak diberikan, ambil dari FirebaseAuth
      userId ??= FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception("User belum login.");

      await _db
          .collection('Users') // ✅ diganti dari 'profiles' → 'Users'
          .doc(userId)
          .set(
            data,
            SetOptions(merge: true),
          ); // merge agar tidak hapus field lain
    } catch (e) {
      throw Exception("Gagal menyimpan data profil: $e");
    }
  }

  /// 🔹 Stream realtime untuk perubahan data profil
  Stream<Map<String, dynamic>> getProfileStream([String? userId]) {
    userId ??= FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return const Stream.empty();
    }

    print(
      "📡 Mendengarkan data dari Firestore → Collection: Users/$userId",
    ); // Debug log
    return _db
        .collection('Users') // ✅ diganti dari 'profiles' → 'Users'
        .doc(userId)
        .snapshots()
        .map((snapshot) => snapshot.data() ?? {});
  }

  /// 🔹 Ambil data profil sekali (non-realtime)
  Future<Map<String, dynamic>> getProfileOnce([String? userId]) async {
    try {
      userId ??= FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception("User belum login.");

      final doc = await _db.collection('Users').doc(userId).get(); // ✅
      return doc.data() ?? {};
    } catch (e) {
      throw Exception("Gagal mengambil data profil: $e");
    }
  }

  /// 🔹 Hapus seluruh data profil user
  Future<void> deleteProfile([String? userId]) async {
    try {
      userId ??= FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception("User belum login.");

      await _db.collection('Users').doc(userId).delete(); // ✅
    } catch (e) {
      throw Exception("Gagal menghapus profil: $e");
    }
  }
}

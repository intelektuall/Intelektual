import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Simpan atau update data profil (termasuk Base64 gambar)
  Future<void> saveProfileData(Map<String, dynamic> data, String userId) async {
    try {
      await _db
          .collection('profiles')
          .doc(userId)
          .set(data, SetOptions(merge: true));
    } catch (e) {
      throw Exception("Gagal menyimpan data profil: $e");
    }
  }

  // Stream realtime untuk perubahan data profil
  Stream<Map<String, dynamic>> getProfileStream(String userId) {
    return _db.collection('profiles').doc(userId).snapshots().map(
          (snapshot) => snapshot.data() ?? {},
        );
  }

  // Ambil data profil sekali
  Future<Map<String, dynamic>> getProfileOnce(String userId) async {
    try {
      final doc = await _db.collection('profiles').doc(userId).get();
      return doc.data() ?? {};
    } catch (e) {
      throw Exception("Gagal mengambil data profil: $e");
    }
  }

  // Hapus seluruh data profil
  Future<void> deleteProfile(String userId) async {
    try {
      await _db.collection('profiles').doc(userId).delete();
    } catch (e) {
      throw Exception("Gagal menghapus profil: $e");
    }
  }
}

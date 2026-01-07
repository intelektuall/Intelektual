import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firestore_service_base.dart';

class FirestoreService implements FirestoreServiceBase {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// 🔹 Simpan / update data profil
  @override
  Future<void> saveProfileData(
    Map<String, dynamic> data, [
    String? userId,
  ]) async {
    try {
      userId ??= FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception("User belum login.");

      await _db
          .collection('Users')
          .doc(userId)
          .set(data, SetOptions(merge: true));
    } catch (e) {
      throw Exception("Gagal menyimpan data profil: $e");
    }
  }

  /// 🔹 Stream realtime profil
  @override
  Stream<Map<String, dynamic>> getProfileStream([String? userId]) {
    userId ??= FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return const Stream.empty();
    }

    return _db
        .collection('Users')
        .doc(userId)
        .snapshots()
        .map((snapshot) => snapshot.data() ?? {});
  }

  /// 🔹 Ambil data sekali
  @override
  Future<Map<String, dynamic>> getProfileOnce([String? userId]) async {
    try {
      userId ??= FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception("User belum login.");

      final doc = await _db.collection('Users').doc(userId).get();
      return doc.data() ?? {};
    } catch (e) {
      throw Exception("Gagal mengambil data profil: $e");
    }
  }

  /// 🔹 Hapus profil
  @override
  Future<void> deleteProfile([String? userId]) async {
    try {
      userId ??= FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) throw Exception("User belum login.");

      await _db.collection('Users').doc(userId).delete();
    } catch (e) {
      throw Exception("Gagal menghapus profil: $e");
    }
  }
}

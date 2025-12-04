// file: login_google_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 🔹 Tambahkan ini

class LoginGoogleHelper {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  /// 🔹 Sign in dengan Google + sinkron ke Firestore
  static Future<User?> signInWithGoogle() async {
    try {
      // Pastikan sesi Google lama dilepas agar popup pilih akun muncul
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // pengguna batal login

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      final user = userCredential.user;

      // 🔹 Jika login berhasil, pastikan dokumen Firestore user dibuat
      if (user != null) {
        final userDoc = FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid);

        final snapshot = await userDoc.get();

        if (!snapshot.exists) {
          await userDoc.set({
            'nama': user.displayName ?? '',
            'email': user.email ?? '',
            'alamatRumah': '',
            'bio': '',
            'hobi': [],
            'pekerjaan': '',
            'profileImage': user.photoURL ?? '',
            'profileImageBase64': '',
            'status': 'active',
            'nomorHP': '',
            'jenisKelamin': '',
            'umur': '',
            'tempatTanggalLahir': '',
            'statusPernikahan': '',
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }

      return user;
    } catch (e) {
      throw Exception("Login Google gagal: $e");
    }
  }

  /// Logout dari Firebase dan Google (bersihkan sesi sehingga popup muncul lagi)
  static Future<void> signOutGoogle() async {
    try {
      // Pastikan Firebase signOut dulu
      await FirebaseAuth.instance.signOut();

      // signOut dari GoogleSignIn (hapus sesi lokal)
      await _googleSignIn.signOut();

      // disconnect untuk memastikan sesi OAuth dihapus (force reselect)
      await _googleSignIn.disconnect();
    } catch (e) {
      // aman diabaikan, cukup log di debug mode
      // print("Logout Google gagal: $e");
    }
  }
}

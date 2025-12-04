import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Auth {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // 🔹 Fungsi untuk login dengan email & password
  Future<String> logIn(String email, String password) async {
    UserCredential authResult = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = authResult.user;

    // Cek jika user baru pertama kali login → pastikan data Firestore ada
    if (user != null) {
      await _createUserDocumentIfNotExists(user);
      return user.uid;
    } else {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'User tidak ditemukan.',
      );
    }
  }

  // 🔹 Fungsi untuk sign up (buat akun baru)
  Future<String> signUp(String email, String password) async {
    UserCredential authResult = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    User? user = authResult.user;

    if (user != null) {
      // Setelah akun berhasil dibuat → buat dokumen user di Firestore
      await _createUserDocumentIfNotExists(user);
      return user.uid;
    } else {
      throw FirebaseAuthException(
        code: 'signup-failed',
        message: 'Gagal membuat akun.',
      );
    }
  }

  // 🔹 Fungsi sign out
  Future<void> signOut() async {
    return firebaseAuth.signOut();
  }

  // 🔹 Dapatkan user saat ini
  Future<User?> getUser() async {
    return firebaseAuth.currentUser;
  }

  // ===========================================================
  // 🔹 Bagian tambahan: buat dokumen Firestore untuk user baru
  // ===========================================================
  Future<void> _createUserDocumentIfNotExists(User user) async {
    final docRef = firestore.collection('Users').doc(user.uid);
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      await docRef.set({
        'nama': user.displayName ?? '',
        'email': user.email ?? '',
        'alamatRumah': '',
        'bio': '',
        'hobi': [],
        'pekerjaan': '',
        'profileImage': user.photoURL ?? '',
        'profileImageBase64': '',
        'status': 'active',
        // 🔹 Field tambahan profil
        'nomorHP': '',
        'jenisKelamin': '',
        'umur': '',
        'tempatTanggalLahir': '',
        'statusPernikahan': '',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }
}

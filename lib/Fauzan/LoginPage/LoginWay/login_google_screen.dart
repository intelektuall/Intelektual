// file: login_google_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginGoogleHelper {
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  /// Sign in dengan Google
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
      return userCredential.user;
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
      // Jangan lempar kecuali kamu mau crash app — cukup log
      // developer bisa melihat ini di debug console
      // print("Logout Google gagal: $e");
    }
  }
}

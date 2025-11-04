import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<String> logIn(String email, String password) async {
    UserCredential authResult = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = authResult.user;
    return user!.uid;
  }

  Future<String> signUp(String email, String password) async {
    UserCredential authResult = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    User? user = authResult.user;
    return user!.uid;
  }

  Future<void> signOut() async {
    return firebaseAuth.signOut();
  }

  Future<User?> getUSer() async {
    User? user = await firebaseAuth.currentUser;
    return user;
  }
}

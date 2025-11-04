import 'package:flutter/material.dart';

class LoginPhoneScreen extends StatelessWidget {
  const LoginPhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login with Phone Number')),
      body: const Center(
        child: Text(
          'Halaman login menggunakan nomor HP (belum diimplementasi)',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

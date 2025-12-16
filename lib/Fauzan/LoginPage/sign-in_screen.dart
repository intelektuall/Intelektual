import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:sopan_santun_app/Fauzan/LoginPage/Firebase_Auth/auth.dart';
import '/Activity/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MySignin extends StatelessWidget {
  const MySignin({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SignUpPage());
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  final TextEditingController txtConfirmPassword = TextEditingController();

  String message = '';
  late Auth auth;
  bool isLoading = false;

  @override
  void initState() {
    auth = Auth();
    super.initState();
  }

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<void> submit() async {
    setState(() {
      message = '';
      isLoading = true;
    });

    if (txtName.text.isEmpty ||
        txtEmail.text.isEmpty ||
        txtPassword.text.isEmpty ||
        txtConfirmPassword.text.isEmpty) {
      setState(() {
        message = 'Semua field harus diisi!';
        isLoading = false;
      });
      return;
    }

    if (txtPassword.text != txtConfirmPassword.text) {
      setState(() {
        message = 'Password dan Confirm Password tidak sama!';
        isLoading = false;
      });
      return;
    }

    try {
      final userID = await auth.signUp(txtEmail.text, txtPassword.text);

      // 🔹 Setelah user berhasil dibuat, tambahkan ke Firestore
      await FirebaseFirestore.instance.collection('Users').doc(userID).set({
        'nama': txtName.text,
        'email': txtEmail.text,
        'alamatRumah': '',
        'bio': '',
        'hobi': [],
        'pekerjaan': '',
        'profileImage': '',
        'profileImageBase64': '',
        'status': 'active',
        'nomorHP': '',
        'jenisKelamin': '',
        'umur': '',
        'tempatTanggalLahir': '',
        'statusPernikahan': '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        await analytics.logLogin(loginMethod: 'email_password');
        await analytics.setUserId(id: userID);
        await analytics.setUserProperty(name: 'login_type', value: 'manual');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(userID)),
        );
      }
    } catch (e) {
      setState(() {
        message = e.toString();
        isLoading = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    txtName.dispose();
    txtEmail.dispose();
    txtPassword.dispose();
    txtConfirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.blueAccent[50],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "DeepBlue",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[850] : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isDark
                      ? []
                      : [
                          const BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            spreadRadius: 2,
                            offset: Offset(0, 3),
                          ),
                        ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(txtName, "Nama", isDark),
                    const SizedBox(height: 10),
                    _buildTextField(
                      txtEmail,
                      "Email",
                      isDark,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      txtPassword,
                      "Password",
                      isDark,
                      obscure: true,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      txtConfirmPassword,
                      "Confirm Password",
                      isDark,
                      obscure: true,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: isLoading ? null : submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              "Sign Up",
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                    if (message.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 15),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Text(
                          message,
                          style: TextStyle(color: Colors.red.shade700),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        "Sudah punya akun? Login",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Helper builder textfield
  Widget _buildTextField(
    TextEditingController controller,
    String label,
    bool isDark, {
    bool obscure = false,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
        labelStyle: TextStyle(color: isDark ? Colors.white70 : null),
      ),
      style: TextStyle(color: isDark ? Colors.white : null),
    );
  }
}

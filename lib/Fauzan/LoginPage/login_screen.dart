import '/Fauzan/LoginPage/Providers/LoginValidation.dart';
import '/Fauzan/LoginPage/Providers/ProviderLogin.dart';
import '/Fauzan/LoginPage/sign-in_screen.dart';
import '/Activity/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sopan_santun_app/Fauzan/LoginPage/Firebase_Auth/auth.dart';
import 'package:sopan_santun_app/Fauzan/LoginPage/LoginWay/login_google_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class MyLoginAndSignin extends StatefulWidget {
  const MyLoginAndSignin({super.key});

  @override
  State<MyLoginAndSignin> createState() => _MyLoginAndSigninState();
}

class _MyLoginAndSigninState extends State<MyLoginAndSignin> {
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  String message = '';
  late Auth auth;
  bool isLoading = false;
  bool isGoogleLoading = false;

  @override
  void initState() {
    auth = Auth();
    super.initState();
  }

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  Future<void> submit() async {
    final termsProv = Provider.of<AgreeTermsProvider>(context, listen: false);
    final loginProv = Provider.of<LoginValidationProvider>(
      context,
      listen: false,
    );

    final isFormValid = loginProv.validate();
    final isTermsChecked = termsProv.validate();
    await analytics.logEvent(
      name: 'login_button_pressed',
      parameters: {
        'email_entered': txtEmail.text.isNotEmpty ? 'true' : 'false',
        'terms_checked': isTermsChecked ? 'true' : 'false',
        'timestamp': DateTime.now().toIso8601String(),
      },
    );

    if (!isFormValid || !isTermsChecked) {
      return;
    }

    setState(() {
      message = '';
      isLoading = true;
    });

    try {
      final userID = await auth.logIn(txtEmail.text, txtPassword.text);
      if (userID != null && mounted) {
        await analytics.logLogin(loginMethod: 'email_password');
        await analytics.setUserId(id: userID);
        await analytics.setUserProperty(name: 'login_type', value: 'manual');

        await analytics.logEvent(
          name: 'login_success',
          parameters: {'user_id': userID},
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(userID)),
        );
      }
    } catch (e) {
      await analytics.logEvent(
        name: 'login_failed',
        parameters: {'error_message': e.toString()},
      );
      setState(() {
        message = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> signInWithGoogle() async {
    setState(() {
      message = '';
      isGoogleLoading = true;
    });

    try {
      final user = await LoginGoogleHelper.signInWithGoogle();
      if (user != null && mounted) {
        await FirebaseAnalytics.instance.logLogin(loginMethod: 'google');
        await FirebaseAnalytics.instance.setUserId(id: user.uid);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(user.uid)),
        );
      } else {
        setState(() {
          message = 'Login dibatalkan.';
          isGoogleLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        message = e.toString();
        isGoogleLoading = false;
      });
    }
  }

  @override
  void dispose() {
    txtEmail.dispose();
    txtPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final termsProv = Provider.of<AgreeTermsProvider>(context);
    final loginProv = Provider.of<LoginValidationProvider>(context);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.blueAccent[50],
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                "DeepBlue",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.lightBlueAccent : Colors.blueAccent,
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[850] : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isDark
                      ? []
                      : [
                          BoxShadow(
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
                      "Login",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: txtEmail,
                      onChanged: (value) => loginProv.setEmail(value),
                      enabled: !isLoading && !isGoogleLoading,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Email",
                        errorText: loginProv.emailError,
                        labelStyle: TextStyle(
                          color: isDark ? Colors.white70 : null,
                        ),
                      ),
                      style: TextStyle(color: isDark ? Colors.white : null),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: txtPassword,
                      onChanged: (value) => loginProv.setPassword(value),
                      obscureText: true,
                      enabled: !isLoading && !isGoogleLoading,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Password",
                        errorText: loginProv.passwordError,
                        suffixIcon: Icon(
                          Icons.visibility_off,
                          color: isDark ? Colors.white70 : null,
                        ),
                        labelStyle: TextStyle(
                          color: isDark ? Colors.white70 : null,
                        ),
                      ),
                      style: TextStyle(color: isDark ? Colors.white : null),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: (isLoading || isGoogleLoading) ? null : submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                      ),
                      child: isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              "Login",
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: termsProv.agreeToTerms,
                              onChanged: (isLoading || isGoogleLoading)
                                  ? null
                                  : (value) {
                                      termsProv.agreeToTerms = value ?? false;
                                    },
                              activeColor: Colors.blueAccent,
                            ),
                            Expanded(
                              child: Text(
                                "I have read and agree to the Terms and Conditions",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        if (termsProv.termsError != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Text(
                              termsProv.termsError!,
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                    if (message.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Text(
                          message,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                    SizedBox(height: 10),
                    Text(
                      "or sign-in with",
                      style: TextStyle(
                        color: isDark ? Colors.white60 : Colors.grey,
                      ),
                    ),
                    SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: (isLoading || isGoogleLoading)
                          ? null
                          : signInWithGoogle,
                      icon: isGoogleLoading
                          ? SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.blueAccent,
                                ),
                              ),
                            )
                          : Image.asset(
                              'assets/icons/google_icon.png',
                              height: 24,
                              width: 24,
                            ),
                      label: Text(
                        isGoogleLoading
                            ? "Signing in..."
                            : "Continue with Google",
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        side: BorderSide(
                          color: isDark
                              ? Colors.grey.shade600
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: (isLoading || isGoogleLoading)
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUpPage(),
                                ),
                              );
                            },
                      child: Text(
                        "Belum punya akun? Daftar Sekarang",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: (isLoading || isGoogleLoading)
                              ? Colors.grey
                              : Colors.blueAccent,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: (isLoading || isGoogleLoading) ? null : () {},
                      child: Text(
                        "Lupa Password?",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: (isLoading || isGoogleLoading)
                              ? Colors.grey.shade400
                              : (isDark ? Colors.white60 : Colors.grey),
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
}

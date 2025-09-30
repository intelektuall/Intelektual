import '/Fauzan/LoginPage/Providers/LoginValidation.dart';
import '/Fauzan/LoginPage/Providers/ProviderLogin.dart';
import '/Fauzan/LoginPage/sign-in_screen.dart';
import '/Activity/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyLoginAndSignin extends StatefulWidget {
  @override
  State<MyLoginAndSignin> createState() => _MyLoginAndSigninState();
}

class _MyLoginAndSigninState extends State<MyLoginAndSignin> {
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
                      onChanged: (value) => loginProv.setEmail(value),
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
                      onChanged: (value) => loginProv.setPassword(value),
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Password",
                        errorText: loginProv.passwordError,
                        suffixIcon: Icon(Icons.visibility_off,
                            color: isDark ? Colors.white70 : null),
                        labelStyle: TextStyle(
                          color: isDark ? Colors.white70 : null,
                        ),
                      ),
                      style: TextStyle(color: isDark ? Colors.white : null),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        final isFormValid = loginProv.validate();
                        final isTermsChecked = termsProv.validate();

                        if (isFormValid && isTermsChecked) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                      ),
                      child: Text(
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
                              onChanged: (value) {
                                termsProv.agreeToTerms = value ?? false;
                              },
                              activeColor: Colors.blueAccent,
                            ),
                            Expanded(
                              child: Text(
                                "I have read and agree to the Terms and Conditions",
                                style: TextStyle(
                                  fontSize: 13,
                                  color:
                                      isDark ? Colors.white70 : Colors.black87,
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
                    SizedBox(height: 10),
                    Text(
                      "or sign-in with",
                      style: TextStyle(
                        color: isDark ? Colors.white60 : Colors.grey,
                      ),
                    ),
                    SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: Image.asset(
                        'assets/icons/google_icon.png',
                        height: 24,
                        width: 24,
                      ),
                      label: Text(
                        "Continue with Google",
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      child: Text(
                        "Belum punya akun? Daftar Sekarang",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "Lupa Password?",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white60 : Colors.grey,
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

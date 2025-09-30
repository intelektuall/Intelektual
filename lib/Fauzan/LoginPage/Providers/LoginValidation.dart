import 'package:flutter/material.dart';

class LoginValidationProvider with ChangeNotifier {
  String _email = '';
  String _password = '';
  String? _emailError;
  String? _passwordError;

  String get email => _email;
  String get password => _password;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;

  void setEmail(String value) {
    _email = value;
    _emailError = null;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    _passwordError = null;
    notifyListeners();
  }

  bool validate() {
    bool isValid = true;

    if (_email.isEmpty) {
      _emailError = "Email tidak boleh kosong";
      isValid = false;
    }

    if (_password.isEmpty) {
      _passwordError = "Password tidak boleh kosong";
      isValid = false;
    }

    notifyListeners();
    return isValid;
  }
}

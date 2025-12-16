import 'package:flutter/material.dart';

class AgreeTermsProvider with ChangeNotifier {
  bool _agreeToTerms = false;
  String? _termsError;

  bool get agreeToTerms => _agreeToTerms;
  String? get termsError => _termsError;

  set agreeToTerms(bool value) {
    _agreeToTerms = value;
    if (value) {
      _termsError = null;
    }
    notifyListeners();
  }

  bool validate() {
    if (!_agreeToTerms) {
      _termsError = "Anda harus menyetujui syarat dan ketentuan";
      notifyListeners();
      return false;
    }
    _termsError = null;
    notifyListeners();
    return true;
  }
}

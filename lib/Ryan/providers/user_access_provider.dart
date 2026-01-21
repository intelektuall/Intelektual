import 'package:flutter/material.dart';

class UserAccessProvider extends ChangeNotifier {
  bool _isPremium = false;
  int _coins = 5;

  bool get isPremium => _isPremium;
  int get coins => _coins;

  void togglePremium(bool value) {
    _isPremium = value;
    notifyListeners();
  }

  bool canAccess() {
    if (_isPremium) return true;
    return _coins > 0;
  }

  void consumeCoin() {
    if (!_isPremium && _coins > 0) {
      _coins--;
      notifyListeners();
    }
  }


  void addCoins(int amount) {
    _coins += amount;
    notifyListeners();
  }

  void resetCoins() {
    _coins = 5;
    notifyListeners();
  }
}

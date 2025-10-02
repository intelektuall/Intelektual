// Eka/provider/settings_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  bool _isLockAppOn = true;
  String _backgroundMode = "Putih";
  bool _isNotificationEnabled = false;
  bool _isPowerSavingMode = false;
  String _language = "Indonesia";

  bool get isLockAppOn => _isLockAppOn;
  String get backgroundMode => _backgroundMode;
  bool get isNotificationEnabled => _isNotificationEnabled;
  bool get isPowerSavingMode => _isPowerSavingMode;
  String get language => _language;

  SettingsProvider() {
    _loadSettingsFromPrefs();
  }

  Future<void> _loadSettingsFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isLockAppOn = prefs.getBool("lockApp") ?? true;
      _backgroundMode = prefs.getString("backgroundMode") ?? "Putih";
      _isNotificationEnabled = prefs.getBool("notification") ?? false;
      _isPowerSavingMode = prefs.getBool("powerSaving") ?? false;
      _language = prefs.getString("language") ?? "Indonesia";
      notifyListeners();
    } catch (e) {
      // Jika terjadi error, tetap gunakan nilai default.
      debugPrint("Error loading settings: $e");
    }
  }

  Future<void> _saveToPrefs(String key, dynamic value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is String) {
        await prefs.setString(key, value);
      }
    } catch (e) {
      debugPrint("Error saving $key: $e");
    }
  }

  void setLockApp(bool value) {
    _isLockAppOn = value;
    _saveToPrefs("lockApp", value);
    notifyListeners();
  }

  void setBackgroundMode(String value) {
    _backgroundMode = value;
    _saveToPrefs("backgroundMode", value);
    notifyListeners();
  }

  void setNotification(bool value) {
    _isNotificationEnabled = value;
    _saveToPrefs("notification", value);
    notifyListeners();
  }

  void setPowerSavingMode(bool value) {
    _isPowerSavingMode = value;
    _saveToPrefs("powerSaving", value);
    notifyListeners();
  }

  void setLanguage(String value) {
    _language = value;
    _saveToPrefs("language", value);
    notifyListeners();
  }
}

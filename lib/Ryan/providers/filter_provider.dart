import 'package:flutter/material.dart';

class FilterProvider with ChangeNotifier {

  bool _isFilterActive = false;

  bool get isFilterActive => _isFilterActive;

  void toggleFilter() {
    _isFilterActive = !_isFilterActive;
    notifyListeners();
  }
}

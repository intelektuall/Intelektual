import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/filter_model.dart';
import '../models/category_types.dart';
import '../models/mystery_item.dart';
import '../models/fact_item.dart';

class ContentFilterProvider with ChangeNotifier {
  FilterModel _filters = FilterModel();
  FilterModel _tempFilters = FilterModel.empty(); // untuk perubahan sementara dari UI

  FilterModel get filters => _filters;
  FilterModel get tempFilters => _tempFilters;

  ContentFilterProvider() {
    // otomatis memuat filter saat provider dibuat
    loadFilters();
  }

  // =====================================================
  // 🔹 SIMPAN FILTER KE SHARED PREFERENCES
  // =====================================================
  Future<void> saveFilters() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('showFauna', _filters.showFauna);
    await prefs.setBool('showFlora', _filters.showFlora);
    await prefs.setBool('showFacts', _filters.showFacts);
    await prefs.setBool('showMystery', _filters.showMystery);
    await prefs.setBool('showHuman', _filters.showHuman);

    await prefs.setStringList('selectedOceans', _filters.selectedOceans.toList());
    await prefs.setString('selectedFish', _filters.selectedFish ?? '');

    // Simpan subtype fauna dan flora
    await prefs.setStringList(
      'selectedFaunaSubtypes',
      _filters.selectedSubtypes['fauna']?.toList() ?? [],
    );
    await prefs.setStringList(
      'selectedFloraSubtypes',
      _filters.selectedSubtypes['flora']?.toList() ?? [],
    );
  }

  // =====================================================
  // 🔹 MUAT FILTER DARI SHARED PREFERENCES
  // =====================================================
  Future<void> loadFilters() async {
    final prefs = await SharedPreferences.getInstance();

    _filters.showFauna = prefs.getBool('showFauna') ?? true;
    _filters.showFlora = prefs.getBool('showFlora') ?? true;
    _filters.showFacts = prefs.getBool('showFacts') ?? true;
    _filters.showMystery = prefs.getBool('showMystery') ?? true;
    _filters.showHuman = prefs.getBool('showHuman') ?? true;

    _filters.selectedOceans = prefs.getStringList('selectedOceans')?.toSet() ?? {};
    _filters.selectedFish = prefs.getString('selectedFish');

    _filters.selectedSubtypes['fauna'] =
        prefs.getStringList('selectedFaunaSubtypes')?.toSet() ?? {};
    _filters.selectedSubtypes['flora'] =
        prefs.getStringList('selectedFloraSubtypes')?.toSet() ?? {};

    _tempFilters = _filters.copy();
    notifyListeners();
  }

  // =====================================================
  // 🔹 SINKRONISASI ANTARA FILTER AKTIF DAN TEMPORER
  // =====================================================
  void setTempFilters(FilterModel temp) {
    _tempFilters = temp;
    notifyListeners();
  }

  void applyTempFilters() {
    _filters = _tempFilters.copy();
    saveFilters(); // otomatis simpan ke SharedPreferences
    notifyListeners();
  }

  void resetFilters() {
    _filters.reset();
    _tempFilters = _filters.copy();
    saveFilters(); // simpan hasil reset ke SharedPreferences
    notifyListeners();
  }

  // =====================================================
  // 🔹 CEK AKTIVASI KATEGORI
  // =====================================================
  bool isCategoryActive(String category) {
    switch (category) {
      case CategoryTypes.fauna:
        return _filters.showFauna;
      case CategoryTypes.flora:
        return _filters.showFlora;
      case CategoryTypes.facts:
        return _filters.showFacts;
      case CategoryTypes.mystery:
        return _filters.showMystery;
      case CategoryTypes.human:
        return _filters.showHuman;
      default:
        return false;
    }
  }

  // =====================================================
  // 🔹 LOGIKA FILTER
  // =====================================================
  bool shouldShowOcean(String ocean) {
    if (_filters.selectedOceans.isEmpty) return true;
    return _filters.selectedOceans.contains(ocean);
  }

  bool shouldShowSubtype(String type, String subtype) {
    final selected = _filters.selectedSubtypes[type];
    if (selected == null || selected.isEmpty) return true;
    return selected.contains(subtype);
  }

  bool shouldShowFish(String fishName) {
    return _filters.selectedFish == null || _filters.selectedFish == fishName;
  }

  bool shouldShowFactItem(FactItem fact) {
    return _filters.showFacts && shouldShowOcean(fact.title);
  }

  bool shouldShowMysteryItem(MysteryItem mystery) {
    return _filters.showMystery && shouldShowOcean(mystery.ocean);
  }

  // =====================================================
  // 🔹 TOGGLE & SELECT FUNCTION (DIPAKAI DI UI)
  // =====================================================
  void toggleCategory(String category, bool value, {bool useTemp = false}) {
    final target = useTemp ? _tempFilters : _filters;

    switch (category) {
      case CategoryTypes.fauna:
        target.showFauna = value;
        break;
      case CategoryTypes.flora:
        target.showFlora = value;
        break;
      case CategoryTypes.facts:
        target.showFacts = value;
        break;
      case CategoryTypes.mystery:
        target.showMystery = value;
        break;
      case CategoryTypes.human:
        target.showHuman = value;
        break;
    }

    saveFilters();
    notifyListeners();
  }

  void toggleOcean(String ocean, {bool useTemp = false}) {
    final target = useTemp ? _tempFilters.selectedOceans : _filters.selectedOceans;

    if (target.contains(ocean)) {
      target.remove(ocean);
    } else {
      target.add(ocean);
    }

    saveFilters();
    notifyListeners();
  }

  void toggleSubtype(String type, String subtype, {bool useTemp = false}) {
    final model = useTemp ? _tempFilters : _filters;
    final selected = model.selectedSubtypes[type] ?? <String>{};

    if (selected.contains(subtype)) {
      selected.remove(subtype);
    } else {
      selected.add(subtype);
    }

    model.selectedSubtypes[type] = selected;

    saveFilters();
    notifyListeners();
  }

  void selectFish(String? fishName, {bool useTemp = false}) {
    if (useTemp) {
      _tempFilters.selectedFish = fishName;
    } else {
      _filters.selectedFish = fishName;
      saveFilters();
    }
    notifyListeners();
  }
}

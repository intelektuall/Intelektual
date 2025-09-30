import 'package:flutter/material.dart';
import '../models/filter_model.dart';
import '../models/category_types.dart';
import '../models/mystery_item.dart';
import '../models/fact_item.dart';

class ContentFilterProvider with ChangeNotifier {
  FilterModel _filters = FilterModel();
  FilterModel _tempFilters = FilterModel.empty(); // ✅ Untuk perubahan sementara dari UI

  FilterModel get filters => _filters;
  FilterModel get tempFilters => _tempFilters;

  // ====== SINKRONKAN FILTER TEMPORER ======
  void setTempFilters(FilterModel temp) {
    _tempFilters = temp;
    notifyListeners();
  }

  void applyTempFilters() {
    _filters = _tempFilters.copy(); // Simpan perubahan
    notifyListeners();
  }

  void resetFilters() {
    _filters.reset();
    _tempFilters = _filters.copy(); // Reset juga temp agar sinkron
    notifyListeners();
  }

  // ====== CATEGORY CHECK ======
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

  // ====== OCEAN FILTER ======
  bool shouldShowOcean(String ocean) {
    if (_filters.selectedOceans.isEmpty) return true;
    return _filters.selectedOceans.contains(ocean);
  }

  // ====== SUBTYPE FILTER (Flora / Fauna) ======
  bool shouldShowSubtype(String type, String subtype) {
    final selected = _filters.selectedSubtypes[type];
    if (selected == null || selected.isEmpty) return true;
    return selected.contains(subtype);
  }

  // ====== JENIS IKAN (Fish Dropdown) ======
  bool shouldShowFish(String fishName) {
    return _filters.selectedFish == null || _filters.selectedFish == fishName;
  }

  // ====== FILTER ITEM CHECKERS ======
  bool shouldShowFactItem(FactItem fact) {
    return _filters.showFacts && shouldShowOcean(fact.title);
  }

  bool shouldShowMysteryItem(MysteryItem mystery) {
    return _filters.showMystery && shouldShowOcean(mystery.ocean);
  }

  // ====== TOGGLE & SELECT FUNCTION UNTUK TEMPORARY FILTER (dipakai di UI) ======

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
    notifyListeners();
  }

  void toggleOcean(String ocean, {bool useTemp = false}) {
    final target = useTemp ? _tempFilters.selectedOceans : _filters.selectedOceans;

    if (target.contains(ocean)) {
      target.remove(ocean);
    } else {
      target.add(ocean);
    }
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
    notifyListeners();
  }

  void selectFish(String? fishName, {bool useTemp = false}) {
    if (useTemp) {
      _tempFilters.selectedFish = fishName;
    } else {
      _filters.selectedFish = fishName;
    }
    notifyListeners();
  }

}

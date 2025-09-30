// models/filter_model.dart
import 'category_types.dart';

class FilterModel {
  bool showFauna;
  bool showFlora;
  bool showFacts;
  bool showMystery;
  bool showHuman;

  Set<String> selectedOceans;
  Map<String, Set<String>> selectedSubtypes;

  String? selectedFish;
  String? selectedFaunaSpecies; // ✅ Baru: Ikan, Mamalia, Moluska
  String? selectedFloraSpecies; // ✅ Baru: Kelp, Rumput Laut, Mangrove

  FilterModel({
    this.showFauna = true,
    this.showFlora = true,
    this.showFacts = true,
    this.showMystery = true,
    this.showHuman = true,
    Set<String>? selectedOceans,
    Map<String, Set<String>>? selectedSubtypes,
    this.selectedFish,
    this.selectedFaunaSpecies,
    this.selectedFloraSpecies,
  })  : selectedOceans = selectedOceans ?? {},
        selectedSubtypes = selectedSubtypes ?? {
          CategoryTypes.fauna: {},
          CategoryTypes.flora: {},
        };

  void reset() {
    showFauna = false;
    showFlora = false;
    showFacts = false;
    showMystery = false;
    showHuman = false;
    selectedFish = null;
    selectedFaunaSpecies = null;
    selectedFloraSpecies = null;
    selectedOceans.clear();
    selectedSubtypes.forEach((key, value) => value.clear());
  }

  FilterModel copy() {
    return FilterModel(
      showFauna: showFauna,
      showFlora: showFlora,
      showFacts: showFacts,
      showMystery: showMystery,
      showHuman: showHuman,
      selectedOceans: Set<String>.from(selectedOceans),
      selectedSubtypes: {
        for (var key in selectedSubtypes.keys)
          key: Set<String>.from(selectedSubtypes[key]!),
      },
      selectedFish: selectedFish,
      selectedFaunaSpecies: selectedFaunaSpecies,
      selectedFloraSpecies: selectedFloraSpecies,
    );
  }

  static FilterModel empty() {
    return FilterModel(
      showFauna: false,
      showFlora: false,
      showFacts: false,
      showMystery: false,
      showHuman: false,
      selectedOceans: {},
      selectedSubtypes: {
        CategoryTypes.fauna: {},
        CategoryTypes.flora: {},
      },
      selectedFish: null,
      selectedFaunaSpecies: null,
      selectedFloraSpecies: null,
    );
  }

  FilterModel copyWith({
    bool? showFauna,
    bool? showFlora,
    bool? showFacts,
    bool? showMystery,
    bool? showHuman,
    Set<String>? selectedOceans,
    Map<String, Set<String>>? selectedSubtypes,
    String? selectedFish,
    String? selectedFaunaSpecies,
    String? selectedFloraSpecies,
  }) {
    return FilterModel(
      showFauna: showFauna ?? this.showFauna,
      showFlora: showFlora ?? this.showFlora,
      showFacts: showFacts ?? this.showFacts,
      showMystery: showMystery ?? this.showMystery,
      showHuman: showHuman ?? this.showHuman,
      selectedOceans: selectedOceans ?? Set.from(this.selectedOceans),
      selectedSubtypes: selectedSubtypes ?? {
        for (var key in this.selectedSubtypes.keys)
          key: Set.from(this.selectedSubtypes[key]!),
      },
      selectedFish: selectedFish ?? this.selectedFish,
      selectedFaunaSpecies: selectedFaunaSpecies ?? this.selectedFaunaSpecies,
      selectedFloraSpecies: selectedFloraSpecies ?? this.selectedFloraSpecies,
    );
  }

  bool shouldShowCategory(String category) {
    switch (category) {
      case CategoryTypes.fauna:
        return showFauna;
      case CategoryTypes.flora:
        return showFlora;
      case CategoryTypes.facts:
        return showFacts;
      case CategoryTypes.mystery:
        return showMystery;
      case CategoryTypes.human:
        return showHuman;
      default:
        return false;
    }
  }

  bool shouldShowOcean(String ocean) {
    return selectedOceans.isEmpty || selectedOceans.contains(ocean);
  }

  bool shouldShowSubtype(String category, String subtype) {
    if (!selectedSubtypes.containsKey(category)) return true;
    final selected = selectedSubtypes[category]!;
    return selected.isEmpty || selected.contains(subtype);
  }

  bool shouldShowFish(String fishName) {
    return selectedFish == null || selectedFish == fishName;
  }

  bool shouldShowFaunaSpecies(String name) {
    return selectedFaunaSpecies == null || selectedFaunaSpecies == name;
  }

  bool shouldShowFloraSpecies(String name) {
    return selectedFloraSpecies == null || selectedFloraSpecies == name;
  }
}

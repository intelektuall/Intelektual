import 'package:flutter/material.dart';
import '../models/coral_species.dart';
import 'content_filter_provider.dart';

class CoralSpeciesProvider with ChangeNotifier {
  final List<CoralSpecies> _allSpecies = coralSpeciesList;
  List<CoralSpecies> _filteredSpecies = coralSpeciesList;

  List<CoralSpecies> get species => _filteredSpecies;

  void applyFilter(ContentFilterProvider filterProvider) {
    final filters = filterProvider.filters;
    _filteredSpecies = _allSpecies.where((species) {
      final showCategory = filters.shouldShowCategory(species.category); // 'Flora Laut'
      final showOcean = filters.shouldShowOcean(species.ocean);
      final showSubtype = filters.shouldShowSubtype(species.category, species.subtype); // ← sudah sesuai
      return showCategory && showOcean && showSubtype;
    }).toList();

    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import '../models/marine_species.dart';
import 'content_filter_provider.dart';

class MarineSpeciesProvider with ChangeNotifier {
  List<MarineSpecies> _allSpecies = marineSpeciesList;
  List<MarineSpecies> _filteredSpecies = marineSpeciesList;

  List<MarineSpecies> get species => _filteredSpecies;

  void applyFilter(ContentFilterProvider filterProvider) {
    final filters = filterProvider.filters;
    _filteredSpecies = _allSpecies.where((species) {
      final showCategory = filters.shouldShowCategory(species.category); // 'Fauna Laut'
      final showOcean = filters.shouldShowOcean(species.ocean);
      final showSubtype = filters.shouldShowSubtype(species.category, species.subtype);
      return showCategory && showOcean && showSubtype;
    }).toList();

    notifyListeners();
  }
}

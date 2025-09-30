import 'package:flutter/material.dart';
import '../../models/marine_species.dart';

class CardOverlayProvider extends ChangeNotifier {
  MarineSpecies? _selectedSpecies;
  Rect? _selectedRect;

  MarineSpecies? get selectedSpecies => _selectedSpecies;
  Rect? get selectedRect => _selectedRect;

  void selectCard(MarineSpecies species, Rect rect) {
    _selectedSpecies = species;
    _selectedRect = rect;
    notifyListeners();
  }

  void clearSelection() {
    _selectedSpecies = null;
    _selectedRect = null;
    notifyListeners();
  }
}

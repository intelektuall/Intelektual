import 'package:flutter/material.dart';
import '../../models/coral_species.dart';

class CardOverlayCProvider extends ChangeNotifier {
  CoralSpecies? _selectedSpecies;
  Rect? _selectedRect;

  CoralSpecies? get selectedSpecies => _selectedSpecies;
  Rect? get selectedRect => _selectedRect;

  void selectCard(CoralSpecies species, Rect rect) {
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

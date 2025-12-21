import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/content_filter_provider.dart';
import '../models/filter_model.dart';
import '../models/category_types.dart';
import '../models/marine_species.dart';
import '../models/coral_species.dart';
import '../services/analytics_mixin.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> with AnalyticsScreenTracking{
  late FilterModel tempFilters;
  bool _isDarkTheme = false;
  late SharedPreferences prefs;
  late Future<void> _initFuture;

  ThemeData get _currentTheme =>
      _isDarkTheme ? ThemeData.dark() : ThemeData.light();

  final List<String> floraSubtypes = ['Rumput Laut', 'Kelp', 'Alga'];
  final List<String> faunaSubtypes = [
    'Ikan', 'Mamalia Laut', 'Moluska', 'Reptil Laut',
    'Krustasea', 'Cnidaria', 'Burung Laut',
  ];

  @override
  String get screenName => 'FilterScreen';

  @override
  void initState() {
    super.initState();
    _initFuture = _initializePreferences(); // dipanggil hanya sekali
  }

  Future<void> _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
    final original = Provider.of<ContentFilterProvider>(context, listen: false).filters;
    tempFilters = original.copy();

    _isDarkTheme = prefs.getBool('darkMode') ?? false;
    tempFilters.selectedOceans = prefs.getStringList('selectedOceans')?.toSet() ?? {};
    tempFilters.selectedSubtypes[CategoryTypes.flora] =
        prefs.getStringList('floraSubtypes')?.toSet() ?? {};
    tempFilters.selectedSubtypes[CategoryTypes.fauna] =
        prefs.getStringList('faunaSubtypes')?.toSet() ?? {};
    tempFilters.showFlora = prefs.getBool('showFlora') ?? true;
    tempFilters.showFauna = prefs.getBool('showFauna') ?? true;
    tempFilters.showFacts = prefs.getBool('showFacts') ?? true;
    tempFilters.showMystery = prefs.getBool('showMystery') ?? true;
    tempFilters.showHuman = prefs.getBool('showHuman') ?? true;
  }

  Future<void> _savePreferences() async {
    await prefs.setBool('darkMode', _isDarkTheme);
    await prefs.setStringList('selectedOceans', tempFilters.selectedOceans.toList());
    await prefs.setStringList(
        'floraSubtypes', tempFilters.selectedSubtypes[CategoryTypes.flora]?.toList() ?? []);
    await prefs.setStringList(
        'faunaSubtypes', tempFilters.selectedSubtypes[CategoryTypes.fauna]?.toList() ?? []);
    await prefs.setBool('showFlora', tempFilters.showFlora);
    await prefs.setBool('showFauna', tempFilters.showFauna);
    await prefs.setBool('showFacts', tempFilters.showFacts);
    await prefs.setBool('showMystery', tempFilters.showMystery);
    await prefs.setBool('showHuman', tempFilters.showHuman);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _currentTheme,
      child: FutureBuilder<void>(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          }

          // Setelah future selesai, tampilkan isi utama
          final selectedFaunaSubtypes =
              tempFilters.selectedSubtypes[CategoryTypes.fauna] ?? {};
          final filteredMarineSpecies = marineSpeciesList
              .where((item) => selectedFaunaSubtypes.contains(item.subtype))
              .toList();

          final selectedFloraSubtypes =
              tempFilters.selectedSubtypes[CategoryTypes.flora] ?? {};
          final filteredCoralSpecies = coralSpeciesList
              .where((item) => selectedFloraSubtypes.contains(item.subtype))
              .toList();

          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.85,
            minChildSize: 0.4,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _currentTheme.scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _isDarkTheme ? Icons.dark_mode : Icons.light_mode,
                              color: _currentTheme.colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Mode Tampilan',
                              style: _currentTheme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: _isDarkTheme,
                          onChanged: (val) async {
                            setState(() => _isDarkTheme = val);
                            await prefs.setBool('darkMode', val);
                          },
                          activeColor: Colors.blue,
                        ),
                      ],
                    ),

                    _buildSectionTitle("Kategori Konten"),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: CategoryTypes.all.map((category) {
                        final isActive = tempFilters.shouldShowCategory(category);
                        return ChoiceChip(
                          label: Text(category),
                          selected: isActive,
                          onSelected: (val) {
                            setState(() {
                              _toggleCategoryInTemp(category, val);
                              _savePreferences();
                            });
                          },
                          selectedColor: Colors.blue,
                          backgroundColor: Colors.grey[300],
                          labelStyle: TextStyle(
                            color: isActive ? Colors.white : Colors.black,
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),
                    _buildSectionTitle("Pilih Samudra"),
                    Column(
                      children: ['Hindia', 'Pasifik', 'Atlantik', 'Arktik', 'Antartika']
                          .map((ocean) => CheckboxListTile(
                                title: Text(ocean),
                                value: tempFilters.selectedOceans.contains(ocean),
                                onChanged: (val) {
                                  setState(() {
                                    if (val == true) {
                                      tempFilters.selectedOceans.add(ocean);
                                    } else {
                                      tempFilters.selectedOceans.remove(ocean);
                                    }
                                    _savePreferences();
                                  });
                                },
                              ))
                          .toList(),
                    ),

                    const SizedBox(height: 24),
                    _buildSectionTitle("Jenis Flora & Fauna"),

                    const Text("Flora Laut", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ...floraSubtypes.map((type) {
                      return CheckboxListTile(
                        title: Text(type),
                        value: tempFilters.selectedSubtypes[CategoryTypes.flora]?.contains(type) ?? false,
                        onChanged: (val) {
                          setState(() {
                            _toggleSubtype(CategoryTypes.flora, type, val ?? false);
                            tempFilters.selectedFloraSpecies = null;
                            _savePreferences();
                          });
                        },
                      );
                    }).toList(),

                    const SizedBox(height: 16),
                    const Text("Fauna Laut", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ...faunaSubtypes.map((type) {
                      return CheckboxListTile(
                        title: Text(type),
                        value: tempFilters.selectedSubtypes[CategoryTypes.fauna]?.contains(type) ?? false,
                        onChanged: (val) {
                          setState(() {
                            _toggleSubtype(CategoryTypes.fauna, type, val ?? false);
                            tempFilters.selectedFaunaSpecies = null;
                            _savePreferences();
                          });
                        },
                      );
                    }).toList(),

                    if (selectedFaunaSubtypes.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Spesies Fauna:", style: TextStyle(fontWeight: FontWeight.bold)),
                          DropdownButton<String>(
                            value: tempFilters.selectedFaunaSpecies,
                            hint: const Text("Pilih Fauna Laut"),
                            isExpanded: true,
                            items: filteredMarineSpecies.map((item) {
                              return DropdownMenuItem<String>(
                                value: item.name,
                                child: Text(item.name),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                tempFilters.selectedFaunaSpecies = val;
                              });
                            },
                          ),
                        ],
                      ),

                    if (selectedFloraSubtypes.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Spesies Flora:", style: TextStyle(fontWeight: FontWeight.bold)),
                          DropdownButton<String>(
                            value: tempFilters.selectedFloraSpecies,
                            hint: const Text("Pilih Flora Laut"),
                            isExpanded: true,
                            items: filteredCoralSpecies.map((item) {
                              return DropdownMenuItem<String>(
                                value: item.name,
                                child: Text(item.name),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                tempFilters.selectedFloraSpecies = val;
                              });
                            },
                          ),
                        ],
                      ),

                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        final provider = Provider.of<ContentFilterProvider>(context, listen: false);
                        provider.setTempFilters(tempFilters);
                        provider.applyTempFilters();
                        Navigator.pop(context);
                      },
                      child: const Text("Terapkan Filter"),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          tempFilters = FilterModel.empty();
                          _savePreferences();
                        });
                      },
                      child: const Text("Reset Filter"),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _toggleCategoryInTemp(String category, bool val) {
    switch (category) {
      case CategoryTypes.fauna:
        tempFilters.showFauna = val;
        break;
      case CategoryTypes.flora:
        tempFilters.showFlora = val;
        break;
      case CategoryTypes.facts:
        tempFilters.showFacts = val;
        break;
      case CategoryTypes.mystery:
        tempFilters.showMystery = val;
        break;
      case CategoryTypes.human:
        tempFilters.showHuman = val;
        break;
    }
  }

  void _toggleSubtype(String category, String subtype, bool isSelected) {
    final selectedSet = tempFilters.selectedSubtypes[category] ?? <String>{};
    if (isSelected) {
      selectedSet.add(subtype);
    } else {
      selectedSet.remove(subtype);
    }
    tempFilters.selectedSubtypes[category] = selectedSet;
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            const Expanded(child: Divider(thickness: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: _currentTheme.textTheme.bodyLarge?.color,
                ),
              ),
            ),
            const Expanded(child: Divider(thickness: 1)),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

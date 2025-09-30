import 'package:flutter/material.dart';
import '/Ryan/screens/saved_actions_screen.dart';
import '/Ryan/widgets/coral_species_card.dart';
import 'package:provider/provider.dart';
import '../models/mystery_item.dart';
import '../providers/marine_species_provider.dart';
import '../providers/coral_species_provider.dart';
import '../widgets/marine_species_card.dart';
import '../widgets/mystery_card.dart';
import '../widgets/fact_card.dart';
import '../models/fact_item.dart';
import '../models/human_item.dart';
import '../models/category_types.dart';
import '../widgets/human_action.dart';
import '../providers/content_filter_provider.dart';
import '../providers/filter_provider.dart';
import 'filter_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'detailScreens/marine_species_detail_screen.dart';
import 'detailScreens/coral_species_detail_screen.dart';
import 'detailScreens/fact_detail_screen.dart';
import 'detailScreens/human_detail_screen.dart';
import 'detailScreens/mystery_detail_screen.dart';

class DetailEducationScreen extends StatefulWidget {
  const DetailEducationScreen({super.key});

  @override
  State<DetailEducationScreen> createState() => _DetailEducationScreenState();
}

class _DetailEducationScreenState extends State<DetailEducationScreen> {
  @override
  Widget build(BuildContext context) {
    final marineSpeciesProvider = Provider.of<MarineSpeciesProvider>(context);
    final coralSpeciesProvider = Provider.of<CoralSpeciesProvider>(context);
    final contentFilterProvider = Provider.of<ContentFilterProvider>(context);
    final filterProvider = Provider.of<FilterProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredMarineSpecies = marineSpeciesProvider.species.where(
      (species) {
        return (contentFilterProvider.isCategoryActive('Fauna Laut') ||
                !filterProvider.isFilterActive) &&
            contentFilterProvider.shouldShowOcean(species.ocean) &&
            contentFilterProvider.shouldShowSubtype(
              'Fauna Laut',
              species.subtype,
            );
      },
    ).toList();

    final filteredCoralSpecies = coralSpeciesProvider.species.where(
      (species) {
        return (contentFilterProvider.isCategoryActive('Flora Laut') ||
                !filterProvider.isFilterActive) &&
            contentFilterProvider.shouldShowOcean(species.ocean) &&
            contentFilterProvider.shouldShowSubtype(
              'Flora Laut',
              species.subtype,
            );
      },
    ).toList();

    final filteredFacts = factList.where(
      (fact) =>
          contentFilterProvider.shouldShowOcean(fact.ocean) &&
          contentFilterProvider.isCategoryActive('Fakta Samudra'),
    ).toList();

    final filteredMysteries = mysteryList.where(
      (mystery) =>
          contentFilterProvider.shouldShowOcean(mystery.ocean) &&
          contentFilterProvider.isCategoryActive('Misteri Samudra'),
    ).toList();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Image.asset(
                "assets/images/logoOcean-removebg.png",
                height: 40,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                "Life Below Water",
                style: GoogleFonts.oswald(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Tooltip(
            message: 'Collection',
            child: IconButton(
              icon: const Icon(Icons.collections_bookmark_outlined, size: 28),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SavedActionsScreen(),
                  ),
                );
              },
              color: Colors.white,
            ),
          ),
          Tooltip(
            message: 'Filter',
            child: IconButton(
              icon: const Icon(Icons.filter_alt_outlined, size: 28),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const FilterScreen(),
                );
              },
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [
                        Colors.black87,
                        Colors.black54,
                        Colors.black45,
                      ]
                    : [
                        Colors.white.withOpacity(0.2),
                        Colors.white.withOpacity(0.4),
                        Colors.white.withOpacity(0.5),
                      ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 70),

                  if (contentFilterProvider.isCategoryActive(
                    CategoryTypes.fauna,
                  )) ...[
                    sectionTitle("Fauna Laut", isDark),
                    buildGrid(
                      filteredMarineSpecies,
                      (item) => MarineSpeciesCard(
                        species: item,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MarineSpeciesDetailScreen(species: item),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],

                  if (contentFilterProvider.isCategoryActive(
                    CategoryTypes.flora,
                  )) ...[
                    sectionTitle("Flora Laut", isDark),
                    buildGrid(
                      filteredCoralSpecies,
                      (item) => CoralSpeciesCard(
                        species: item,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CoralSpeciesDetailScreen(species: item),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],

                  if (contentFilterProvider.isCategoryActive(
                    'Fakta Samudra',
                  )) ...[
                    sectionTitle("Fakta Samudra", isDark),
                    Column(
                      children: filteredFacts
                          .map(
                            (fact) => FactCard(
                              title: fact.title,
                              icon: fact.icon,
                              description: fact.description,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FactOceanDetailScreen(fact: fact),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],

                  if (contentFilterProvider.isCategoryActive(
                    'Misteri Samudra',
                  )) ...[
                    sectionTitle("Misteri Samudra", isDark),
                    Column(
                      children: filteredMysteries
                          .map(
                            (mystery) => MysteryCard(
                              title: mystery.title,
                              icon: mystery.icon,
                              description: mystery.description,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MysteryDetailScreen(mystery: mystery),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],

                  if (contentFilterProvider.isCategoryActive(
                    'Peran Manusia',
                  )) ...[
                    sectionTitle("Peran Manusia", isDark),
                    Column(
                      children: humanList
                          .map(
                            (human) => HumanAction(
                              title: human.title,
                              icon: human.icon,
                              description: human.description,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      HumanDetailScreen(human: human),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(String title, bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black;
    final dividerColor = isDark ? Colors.white70 : Colors.black87;
    return Row(
      children: [
        Expanded(
          child: Divider(color: dividerColor, thickness: 1, endIndent: 10),
        ),
        Text(
          title,
          style: GoogleFonts.poppins(
            color: textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        Expanded(
          child: Divider(color: dividerColor, thickness: 1, indent: 10),
        ),
      ],
    );
  }

  Widget buildGrid<T>(List<T> items, Widget Function(T) builder) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.1,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => builder(items[index]),
    );
  }
}

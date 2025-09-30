import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/marine_provider_card.dart';
import '../models/marine_species.dart';
import 'pressable_icon_button.dart';
import 'actions/like_button_action.dart';
import '../providers/cardOverlay/card_overlay_provider.dart';
import '../providers/marine_species_action_provider.dart';
import 'overlayMenu/overlay_menu.dart';
import 'overlayMenu/overlay_menu_manager.dart';

class MarineSpeciesCard extends StatefulWidget {
  final MarineSpecies species;
  final VoidCallback onTap;

  const MarineSpeciesCard({
    super.key,
    required this.species,
    required this.onTap,
  });

  @override
  State<MarineSpeciesCard> createState() => _MarineSpeciesCardState();
}

class _MarineSpeciesCardState extends State<MarineSpeciesCard> {
  final GlobalKey _cardKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MarineSpeciesCardProvider(),
      child: Consumer2<MarineSpeciesCardProvider, CardOverlayProvider>(
        builder: (context, provider, overlayProvider, child) {
          final isSelected = overlayProvider.selectedSpecies == widget.species;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTapDown: (_) => provider.setPressed(true),
                onTapUp: (_) {
                  provider.setPressed(false);
                  widget.onTap();
                },
                onTapCancel: () => provider.setPressed(false),
                child: AnimatedScale(
                  scale: provider.isPressed ? 0.95 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  child: AnimatedContainer(
                    key: _cardKey,
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow:
                          isSelected
                              ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ]
                              : [],
                    ),
                    child: Card(
                      color: Colors.grey.shade800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: provider.isPressed ? 12 : 6,
                      shadowColor: Colors.black,
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                              child: Image.asset(
                                widget.species.imagePath,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 6.0,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.species.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Consumer<MarineSpeciesActionProvider>(
                                  builder: (context, provider, _) {
                                    final isLiked = provider.isLiked(
                                      widget.species,
                                    );
                                    return LikeButtonAction(
                                      species: widget.species,
                                      isLiked: isLiked,
                                      iconSize: 22,
                                    );
                                  },
                                ),
                                // const SizedBox(width: 1),
                                PressableIconButton(
                                  icon: Icons.more_vert,
                                  onPressed: () {
                                    final renderBox =
                                        _cardKey.currentContext
                                                ?.findRenderObject()
                                            as RenderBox?;
                                    if (renderBox != null) {
                                      final position = renderBox.localToGlobal(
                                        Offset.zero,
                                      );
                                      final size = renderBox.size;
                                      final rect = position & size;

                                      Provider.of<CardOverlayProvider>(
                                        context,
                                        listen: false,
                                      ).selectCard(widget.species, rect);

                                      OverlayMenuManager.showOrbitMenu(
                                        context: context,
                                        species: widget.species,
                                        selectedCard: _buildSelectedCard(
                                          context,
                                        ),
                                        cardRect: rect,
                                        onDismiss: () {
                                          Provider.of<CardOverlayProvider>(
                                            context,
                                            listen: false,
                                          ).clearSelection();
                                          OverlayMenuManager.dismiss();
                                        },
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (isSelected && overlayProvider.selectedRect != null)
                Positioned.fill(
                  child: OverlayBackgroundMenu(
                    species: widget.species,
                    selectedCard: _buildSelectedCard(context),
                    cardRect: overlayProvider.selectedRect!,
                    onDismiss: () => overlayProvider.clearSelection(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSelectedCard(BuildContext context) {
    return Stack(
      children: [
        Card(
          color: Colors.black.withOpacity(0.50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 10,
          child: Column(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  child: Image.asset(
                    widget.species.imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 6.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          widget.species.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.more_vert,
                      color: Colors.black87,
                    ), // ⬅️ WARNA LEBIH GELAP
                  ],
                ),
              ),
            ],
          ),
        ),

        // ⬛ Overlay Gelap Transparan
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.30), // Efek gelap
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ],
    );
  }
}

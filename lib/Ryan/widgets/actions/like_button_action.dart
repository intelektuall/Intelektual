import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/marine_species_action_provider.dart';
import '../customSnackbar/custom_snackbar.dart';
import '../../models/marine_species.dart';

class LikeButtonAction extends StatefulWidget {
  final MarineSpecies species;
  final bool isLiked;
  final double iconSize;

  const LikeButtonAction({
    super.key,
    required this.species,
    required this.isLiked,
    this.iconSize = 24.0,
  });

  @override
  State<LikeButtonAction> createState() => _LikeButtonActionState();
}

class _LikeButtonActionState extends State<LikeButtonAction> {
  double _scale = 1.0;

  void _triggerLikeAnimation() {
    setState(() => _scale = 1.3);
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        setState(() => _scale = 1.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MarineSpeciesActionProvider>(
      builder: (context, provider, _) {
        final isLiked = provider.isLiked(widget.species);
        final likeCount = widget.species.likeCount;

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 1.0, end: _scale),
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutBack,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: GestureDetector(
                onTap: () {
                  final wasLiked = isLiked;
                  provider.toggleLike(widget.species);
                  _triggerLikeAnimation();

                  showCustomSnackbar(
                    context,
                    message: wasLiked
                        ? 'Like removed'
                        : 'You liked this species',
                    onUndo: () => provider.toggleLike(widget.species),
                  );
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.redAccent : Colors.white,
                      size: widget.iconSize,
                    ),
                    if (likeCount > 0)
                      Positioned(
                        top: -6,
                        right: -6,
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: const BoxDecoration(
                            color: Colors.blueAccent,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: FittedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Text(
                                likeCount > 99 ? '99+' : '$likeCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

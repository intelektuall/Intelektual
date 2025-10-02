import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../models/marine_species.dart';
import '../../providers/marine_species_action_provider.dart';
import '../customSnackbar/custom_snackbar.dart';
import '../customSnackbar/customC_snackbar.dart';
import '../bottomSheets/share_options_bottom_sheet.dart';
import '../commentModal/comment_modal.dart';
import '../report_dialog.dart';

class OverlayBackgroundMenu extends StatefulWidget {
  final MarineSpecies species;
  final Widget selectedCard;
  final Rect cardRect;
  final VoidCallback onDismiss;

  const OverlayBackgroundMenu({
    super.key,
    required this.species,
    required this.selectedCard,
    required this.cardRect,
    required this.onDismiss,
  });

  @override
  State<OverlayBackgroundMenu> createState() => _OverlayBackgroundMenuState();
}

class _MenuItemData {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  _MenuItemData({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class _OverlayBackgroundMenuState extends State<OverlayBackgroundMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool _showTutorialOverlay = false; // <== TAMBAH INI

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _controller.forward();

    // Cek apakah tutorial sudah pernah ditampilkan
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFirstTime();
    });
  }

  Future<void> _checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeen = prefs.getBool('hasSeenOrbitTutorial') ?? false;

    if (!hasSeen) {
      setState(() {
        _showTutorialOverlay = true;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isActive(String label, MarineSpeciesActionProvider provider) {
    switch (label) {
      case 'Save':
        return provider.isPinned(widget.species);
      case 'Share':
        return provider.isShared(widget.species);
      case 'Report':
        return provider.isReported(widget.species);
      case 'Repost':
        return provider.isReposted(widget.species);
      case 'Comment':
        return provider.hasCommented(widget.species);
      default:
        return false;
    }
  }

  int _getBadgeCount(String label, MarineSpeciesActionProvider provider) {
    switch (label) {
      case 'Comment':
        return widget.species.commentCount;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    const double orbitRadius = 130;
    final double centerX = widget.cardRect.center.dx;
    final double centerY = widget.cardRect.center.dy;
    final double screenWidth = MediaQuery.of(context).size.width;

    final bool orbitRight = centerX < screenWidth / 2;
    final double startAngle = orbitRight ? -pi / 2 : pi / 2;
    final double endAngle = orbitRight ? pi / 2 : 3 * pi / 2;

    final List<_MenuItemData> items = [
      _MenuItemData(
        icon: Icons.bookmark_border,
        activeIcon: Icons.bookmark,
        label: 'Save',
      ),
      _MenuItemData(
        icon: Icons.flag_outlined,
        activeIcon: Icons.flag,
        label: 'Report',
      ),
      _MenuItemData(
        icon: Icons.share_outlined,
        activeIcon: Icons.share,
        label: 'Share',
      ),
      _MenuItemData(
        icon: Icons.repeat_outlined,
        activeIcon: Icons.repeat,
        label: 'Repost',
      ),
      _MenuItemData(
        icon: Icons.forum_outlined,
        activeIcon: Icons.forum,
        label: 'Comment',
      ),
    ];

    return Consumer<MarineSpeciesActionProvider>(
      builder: (context, provider, _) {
        return Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              // Background blur
              Positioned.fill(
                child: GestureDetector(
                  onTap: widget.onDismiss,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(color: Colors.black.withOpacity(0.5)),
                  ),
                ),
              ),

              // Selected card
              Positioned(
                left: widget.cardRect.left,
                top: widget.cardRect.top,
                width: widget.cardRect.width,
                height: widget.cardRect.height,
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.antiAlias,
                  child: widget.selectedCard,
                ),
              ),

              // Orbit items
              Positioned.fill(
                child: ScaleTransition(
                  scale: _animation,
                  child: Stack(
                    children: [
                      for (int i = 0; i < items.length; i++)
                        _buildOrbitItem(
                          index: i,
                          total: items.length,
                          centerX: centerX,
                          centerY: centerY,
                          radius: orbitRadius,
                          item: items[i],
                          angleStart: startAngle,
                          angleEnd: endAngle,
                          provider: provider,
                        ),
                    ],
                  ),
                ),
              ),

              // 👇 Tutorial overlay (shown once)
              if (_showTutorialOverlay)
                Positioned.fill(
                  child: SafeArea(
                    child: Container(
                      color: Colors.black.withOpacity(0.75),
                      child: Center(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 32,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.touch_app,
                                  size: 64,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Ketuk ikon orbit untuk menyimpan, komentar, lapor, dan lainnya.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton(
                                  onPressed: () async {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setBool(
                                      'hasSeenOrbitTutorial',
                                      true,
                                    );
                                    setState(() {
                                      _showTutorialOverlay = false;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                  child: const Text(
                                    "Mengerti",
                                    style: TextStyle(
                                      color:
                                          Colors
                                              .white, // ganti sesuai kebutuhan, misalnya Colors.black atau warna kustom
                                      fontWeight:
                                          FontWeight
                                              .bold, // opsional, untuk mempercantik
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrbitItem({
    required int index,
    required int total,
    required double radius,
    required double centerX,
    required double centerY,
    required _MenuItemData item,
    required double angleStart,
    required double angleEnd,
    required MarineSpeciesActionProvider provider,
  }) {
    final double angle =
        angleStart + (angleEnd - angleStart) * (index / (total - 1));
    final double dx = radius * cos(angle);
    final double dy = radius * sin(angle);

    final bool isActive = _isActive(item.label, provider);
    final IconData displayIcon = isActive ? item.activeIcon : item.icon;
    final Color bgColor = isActive ? Colors.blueAccent.shade100 : Colors.white;
    final Color iconColor = isActive ? Colors.blueAccent : Colors.black;

    return Positioned(
      left: centerX + dx - 20,
      top: centerY + dy - 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              if (item.label == 'Share') {
                Future.delayed(const Duration(milliseconds: 100), () async {
                  widget.onDismiss();

                  await showCupertinoModalBottomSheet(
                    context: context,
                    builder:
                        (_) => ShareOptionsBottomSheet(
                          species: widget.species,
                          provider: provider,
                        ),
                    expand: false,
                    backgroundColor: Colors.transparent,
                    enableDrag: true,
                    topRadius: const Radius.circular(30),
                  );
                });
                return;
              }

              widget.onDismiss();

              switch (item.label) {
                case 'Save':
                  provider.pin(widget.species);
                  showCustomSnackbar(
                    context,
                    message: 'Species tucked safely in your collection',
                    onUndo: () => provider.unpin(widget.species),
                  );
                  break;
                case 'Report':
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder:
                        (_) => ReportDialog(
                          onReport: () {
                            provider.report(widget.species);
                            noUndoCustomSnackbar(
                              context,
                              message: 'Species reported. Thank you!',
                            );
                          },
                        ),
                  );
                  break;
                case 'Repost':
                  provider.repost(widget.species);
                  showCustomSnackbar(
                    context,
                    message: 'Reposted! Added to your items',
                    onUndo: () => provider.unrepost(widget.species),
                  );
                  break;
                case 'Comment':
                  widget.onDismiss();
                  Future.microtask(() {
                    if (!context.mounted) return;
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (dialogContext) {
                        return CommentModal(
                          species: widget.species,
                          onComment: (commentText) async {
                            await dialogContext
                                .read<MarineSpeciesActionProvider>()
                                .addComment(
                                  widget.species,
                                  commentText,
                                  'Anonymous',
                                );
                          },
                        );
                      },
                    ).then((result) {
                      if (result == 'success' && context.mounted) {
                        noUndoCustomSnackbar(
                          context,
                          message: 'Comment sent successfully!',
                        );
                      }
                    });
                  });
                  break;
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 4),
                ],
              ),
              padding: const EdgeInsets.all(8),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      displayIcon,
                      key: ValueKey(displayIcon),
                      color: iconColor,
                      size: 20,
                    ),
                  ),
                  if (item.label == 'Comment' &&
                      _getBadgeCount(item.label, provider) > 0)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 10,
                          minHeight: 10,
                        ),
                        child: Text(
                          '${_getBadgeCount(item.label, provider)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 7,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white,
              shadows: [Shadow(blurRadius: 6, color: Colors.black)],
            ),
          ),
        ],
      ),
    );
  }
}

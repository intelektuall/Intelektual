import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/coral_species_action_provider.dart';
import '../providers/marine_species_action_provider.dart';
import '../widgets/species_card.dart';
import '../models/marine_species.dart';
import '../widgets/customSnackbar/custom_snackbar.dart';
import 'newpage_unlocked.dart';

Widget buildGrid<T>({
  required List<T> items,
  required Widget Function(T) builder,
  int crossAxisCount = 2,
  double spacing = 10,
  double childAspectRatio = 0.9,
  bool shrinkWrap = false,
  ScrollPhysics physics = const ScrollPhysics(),
}) {
  return GridView.builder(
    padding: const EdgeInsets.all(12),
    itemCount: items.length,
    shrinkWrap: shrinkWrap,
    physics: physics,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: spacing,
      mainAxisSpacing: spacing,
      childAspectRatio: childAspectRatio,
    ),
    itemBuilder: (context, index) => builder(items[index]),
  );
}

enum SortingType { latest, newest }
enum ActionType { pinned, reposted, shared }

class SavedActionsScreen extends StatefulWidget {
  const SavedActionsScreen({super.key});

  @override
  State<SavedActionsScreen> createState() => _SavedActionsScreenState();
}

class _SavedActionsScreenState extends State<SavedActionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isGrid = true;
  SortingType sorting = SortingType.latest;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  void _changeView(bool grid) {
    setState(() {
      isGrid = grid;
    });
  }

  void _changeSorting(SortingType sort) {
    setState(() {
      sorting = sort;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appBarColor = isDark ? Colors.blueAccent: Colors.blueAccent;
    final textColor = isDark ? Colors.white : Colors.black87;
    final emptyContentColor = isDark ? Colors.white70 : Colors.black54;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              color: theme.scaffoldBackgroundColor,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.6),
                          Colors.black.withOpacity(0.8),
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
              padding: const EdgeInsets.only(top: kToolbarHeight + 72),
              child: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: [
                  _ActionTabContent(
                    type: ActionType.pinned,
                    isGrid: isGrid,
                    sorting: sorting,
                    textColor: textColor,
                  ),
                  _ActionTabContent(
                    type: ActionType.reposted,
                    isGrid: isGrid,
                    sorting: sorting,
                    textColor: textColor,
                  ),
                  _ActionTabContent(
                    type: ActionType.shared,
                    isGrid: isGrid,
                    sorting: sorting,
                    textColor: textColor,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                decoration: BoxDecoration(
                  color: appBarColor,
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black : Colors.blueAccent,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            left: .0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/logoOcean-removebg.png",
                                height: 40,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                "Life Below Water",
                                style: GoogleFonts.oswald(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 23,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            right: 12.0,
                            child: PopupMenuButton<int>(
                              icon: const Icon(
                                Icons.filter_list,
                                color: Colors.white,
                                size: 28,
                              ),
                              color: isDark ? Colors.grey[800] : Colors.black87,
                              onSelected: (value) {
                                if (value == 0) {
                                  _changeView(true);
                                } else if (value == 1)
                                  _changeView(false);
                                else if (value == 2)
                                  _changeSorting(SortingType.latest);
                                else if (value == 3)
                                  _changeSorting(SortingType.newest);
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 0,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.grid_view,
                                        color: isGrid
                                            ? Colors.cyanAccent
                                            : (isDark ? Colors.white : Colors.black87),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Grid View',
                                        style: TextStyle(
                                          color: isDark ? Colors.white : Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 1,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.list,
                                        color: !isGrid
                                            ? Colors.cyanAccent
                                            : (isDark ? Colors.white : Colors.black87),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'List View',
                                        style: TextStyle(
                                          color: isDark ? Colors.white : Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuDivider(
                                  color: isDark ? Colors.grey[600] : Colors.grey[300],
                                ),
                                PopupMenuItem(
                                  value: 2,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.update,
                                        color: sorting == SortingType.latest
                                            ? Colors.cyanAccent
                                            : (isDark ? Colors.white : Colors.black87),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Latest',
                                        style: TextStyle(
                                          color: isDark ? Colors.white : Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 3,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.new_releases,
                                        color: sorting == SortingType.newest
                                            ? Colors.cyanAccent
                                            : (isDark ? Colors.white : Colors.black87),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Newest',
                                        style: TextStyle(
                                          color: isDark ? Colors.white : Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TabBar(
                        controller: _tabController,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white60,
                        indicatorColor: Colors.cyanAccent,
                        tabs: [
                          Tab(icon: Icon(Icons.bookmark_border), text: 'Saved'),
                          Tab(
                            icon: Icon(Icons.repeat_outlined),
                            text: 'Reposted',
                          ),
                          Tab(icon: Icon(Icons.share_outlined), text: 'Shared'),
                        ],
                        onTap: (_) {
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionTabContent extends StatelessWidget {
  final ActionType type;
  final bool isGrid;
  final SortingType sorting;
  final Color textColor;

  const _ActionTabContent({
    required this.type,
    required this.isGrid,
    required this.sorting,
    required this.textColor,
  });

  List<dynamic> _applySorting(List<dynamic> items) {
    return sorting == SortingType.newest ? items.reversed.toList() : items;
  }

  String _getSnackbarMessage(ActionType type) {
    switch (type) {
      case ActionType.pinned:
        return 'Unmarked for later viewing';
      case ActionType.reposted:
        return 'Species taken off your repost list';
      case ActionType.shared:
        return 'Removed from shared list';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final coralProvider = Provider.of<CoralSpeciesActionProvider>(
      context,
      listen: true,
    );
    final marineProvider = Provider.of<MarineSpeciesActionProvider>(
      context,
      listen: true,
    );

    List<dynamic> coralList;
    List<dynamic> marineList;

    switch (type) {
      case ActionType.pinned:
        coralList = coralProvider.pinned;
        marineList = marineProvider.pinned;
        break;
      case ActionType.reposted:
        coralList = coralProvider.reposted;
        marineList = marineProvider.reposted;
        break;
      case ActionType.shared:
        coralList = coralProvider.shared;
        marineList = marineProvider.shared;
        break;
    }

    final parentContext = context;

    final allItems = [
      ..._applySorting(coralList),
      ..._applySorting(marineList),
    ];

    if (allItems.isEmpty) {
      return Center(
        child: Text(
          'Belum ada konten disimpan.',
          style: TextStyle(color: textColor.withOpacity(0.7)),
        ),
      );
    }

    return isGrid
        ? buildGrid(
            items: allItems,
            crossAxisCount: 2,
            spacing: 10,
            childAspectRatio: 0.9,
            builder: (item) => SpeciesCard(
              title: item.name,
              subtitle: '',
              imagePath: item.imagePath ?? 'assets/images/default_species.jpg',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NewPageUnlocked(),
                ),
              ),
              onTapDelete: () {
                final provider = item is MarineSpecies
                    ? Provider.of<MarineSpeciesActionProvider>(
                        context,
                        listen: false,
                      )
                    : Provider.of<CoralSpeciesActionProvider>(
                        context,
                        listen: false,
                      );

                final dynamic p = provider;

                late VoidCallback undo;
                switch (type) {
                  case ActionType.pinned:
                    p.unpin(item);
                    undo = () => p.pin(item);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showCustomSnackbar(
                        context,
                        message: 'Unmarked for later viewing',
                        onUndo: undo,
                      );
                    });
                    break;
                  case ActionType.reposted:
                    p.unrepost(item);
                    undo = () => p.repost(item);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showCustomSnackbar(
                        context,
                        message: 'Species taken off your repost list',
                        onUndo: undo,
                      );
                    });
                    break;
                  case ActionType.shared:
                    p.unshare(item);
                    undo = () => p.share(item);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showCustomSnackbar(
                        context,
                        message: 'Removed from shared list',
                        onUndo: undo,
                      );
                    });
                    break;
                }
              },
              isGrid: true,
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: allItems.length,
            itemBuilder: (context, index) {
              final item = allItems[index];
              return SpeciesCard(
                title: item.name,
                subtitle: item.description ?? 'Deskripsi tidak tersedia',
                imagePath: item.imagePath ?? 'assets/images/default_species.jpg',
                onTap: () => Navigator.push(
                  parentContext,
                  MaterialPageRoute(builder: (_) => const NewPageUnlocked()),
                ),
                onTapDelete: () {
                  final provider = item is MarineSpecies
                      ? Provider.of<MarineSpeciesActionProvider>(
                          parentContext,
                          listen: false,
                        )
                      : Provider.of<CoralSpeciesActionProvider>(
                          parentContext,
                          listen: false,
                        );

                  final dynamic p = provider;

                  late VoidCallback undo;
                  switch (type) {
                    case ActionType.pinned:
                      p.unpin(item);
                      undo = () => p.pin(item);
                      break;
                    case ActionType.reposted:
                      p.unrepost(item);
                      undo = () => p.repost(item);
                      break;
                    case ActionType.shared:
                      p.unshare(item);
                      undo = () => p.share(item);
                      break;
                  }
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showCustomSnackbar(
                      parentContext,
                      message: _getSnackbarMessage(type),
                      onUndo: undo,
                    );
                  });
                },
                isGrid: false,
              );
            },
          );
  }
}
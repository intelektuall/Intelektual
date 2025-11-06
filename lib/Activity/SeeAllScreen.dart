import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:provider/provider.dart';
import '../Provider/hewan_provider.dart';
import 'DetailScreen.dart';
import 'add_animal_screen.dart';
import 'pengajuan.dart';

class SeeAllScreen extends StatefulWidget {
  const SeeAllScreen({super.key});

  @override
  _SeeAllScreenState createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends State<SeeAllScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isGrid = false;
  bool _sortNewest = true;

  @override 
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);

    // Pastikan data di-load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<HewanProvider>();
      if (provider.apiAnimals.isEmpty && !provider.isLoadingApi) {
        print('SeeAllScreen: Memuat data dari API...');
        provider.fetchAnimalsFromAPI();
      } else {
        print(
          'SeeAllScreen: Data sudah tersedia: ${provider.allAnimals.length} hewan',
        );
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getFilteredAnimals(
    HewanProvider provider,
    int tabIndex,
  ) {
    List<Map<String, dynamic>> data = provider.allAnimals;

    if (tabIndex == 1) {
      data = provider.protectedAnimals;
    } else if (tabIndex >= 2) {
      final lokasi = [
        'Samudra Pasifik',
        'Samudra Atlantik',
        'Samudra Hindia',
        'Samudra Arktik',
        'Samudra Selatan',
      ][tabIndex - 2];
      data = data.where((e) => e['location'] == lokasi).toList();
    }

    // 🔧 FIX: Safe sorting dengan error handling
    try {
      data.sort((a, b) {
        DateTime aDate;
        DateTime bDate;

        // Handle jika timestamp adalah DateTime object
        if (a['timestamp'] is DateTime) {
          aDate = a['timestamp'];
          bDate = b['timestamp'];
        }
        // Handle jika timestamp adalah String
        else if (a['timestamp'] is String) {
          aDate = DateTime.parse(a['timestamp']);
          bDate = DateTime.parse(b['timestamp']);
        }
        // Fallback ke DateTime.now()
        else {
          aDate = DateTime.now();
          bDate = DateTime.now();
        }

        return _sortNewest ? bDate.compareTo(aDate) : aDate.compareTo(bDate);
      });
    } catch (e) {
      print('❌ Error sorting data: $e');
      // Tetap return data meski sorting gagal
    }

    return data;
  }

  // 🔄 UPDATE: Widget untuk loading indicator
  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Memuat data dari server...', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  // 🔄 UPDATE: Widget untuk error state
  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.orange),
          SizedBox(height: 16),
          Text(
            'Gagal memuat data',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Menggunakan data lokal',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              context.read<HewanProvider>().fetchAnimalsFromAPI();
            },
            icon: Icon(Icons.refresh),
            label: Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  // UPDATE: Widget untuk menampilkan list/grid animals
  Widget _buildAnimalList(List<Map<String, dynamic>> animals, bool isDark) {
    if (animals.isEmpty) {
      return Center(
        child: Text(
          'Tidak ada data',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    if (_isGrid) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = 2;
            if (constraints.maxWidth < 360) {
              crossAxisCount = 1;
            }
            double spacing = 8.0;
            double width =
                (constraints.maxWidth - ((crossAxisCount - 1) * spacing)) /
                crossAxisCount;
            double height = width * 1.1;
            double ratio = width / height;
            return GridView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: animals.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
                childAspectRatio: ratio,
              ),
              itemBuilder: (context, index) =>
                  AnimalCard(animal: animals[index], isDark: isDark),
            );
          },
        ),
      );
    } else {
      return ListView.separated(
        padding: EdgeInsets.all(10),
        itemCount: animals.length,
        itemBuilder: (context, index) =>
            AnimalCard(animal: animals[index], isDark: isDark),
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: isDark ? Colors.grey[700] : Colors.grey[300],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final provider = context.watch<HewanProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Spesies Langka",
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
            // UPDATE: Tambah loading indicator kecil di appbar
            if (provider.isLoadingApi) ...[
              SizedBox(width: 8),
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ],
          ],
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        actions: [
          // UPDATE: Tambah refresh button
          if (!provider.isLoadingApi)
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: isDark ? Colors.white : Colors.black,
              ),
              onPressed: () => provider.fetchAnimalsFromAPI(),
              tooltip: 'Refresh Data',
            ),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                if (value == 'Grid') {
                  _isGrid = true;
                } else if (value == 'List') {
                  _isGrid = false;
                } else if (value == 'Terbaru') {
                  _sortNewest = true;
                } else if (value == 'Terlama') {
                  _sortNewest = false;
                }
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'Grid',
                child: Row(
                  children: [
                    Icon(
                      Icons.grid_view,
                      color: _isGrid
                          ? Colors.blueAccent
                          : (isDark ? Colors.white : Colors.black),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Tampilan Grid',
                      style: TextStyle(
                        color: _isGrid
                            ? Colors.blueAccent
                            : (isDark ? Colors.white : Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'List',
                child: Row(
                  children: [
                    Icon(
                      Icons.view_list,
                      color: !_isGrid
                          ? Colors.blueAccent
                          : (isDark ? Colors.white : Colors.black),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Tampilan List',
                      style: TextStyle(
                        color: !_isGrid
                            ? Colors.blueAccent
                            : (isDark ? Colors.white : Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuDivider(
                color: isDark ? Colors.grey[700] : Colors.grey[300],
              ),
              PopupMenuItem<String>(
                value: 'Terbaru',
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_downward,
                      color: _sortNewest
                          ? Colors.blueAccent
                          : (isDark ? Colors.white : Colors.black),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Urutkan Terbaru',
                      style: TextStyle(
                        color: _sortNewest
                            ? Colors.blueAccent
                            : (isDark ? Colors.white : Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'Terlama',
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      color: !_sortNewest
                          ? Colors.blueAccent
                          : (isDark ? Colors.white : Colors.black),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Urutkan Terlama',
                      style: TextStyle(
                        color: !_sortNewest
                            ? Colors.blueAccent
                            : (isDark ? Colors.white : Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            icon: Icon(Icons.sort, color: isDark ? Colors.white : Colors.black),
            tooltip: 'Pengaturan Tampilan',
            color: isDark ? Colors.grey[800] : Colors.white,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.blueAccent,
          labelColor: Colors.blueAccent,
          unselectedLabelColor: isDark ? Colors.grey[400] : Colors.grey[700],
          tabs: [
            Tab(text: 'Semua'),
            Tab(text: 'Dilindungi'),
            Tab(text: 'Pasifik'),
            Tab(text: 'Atlantik'),
            Tab(text: 'Hindia'),
            Tab(text: 'Arktik'),
            Tab(text: 'Selatan'),
          ],
        ),
      ),
      //UPDATE: Body dengan kondisi loading/error/data
      body: provider.isLoadingApi && provider.allAnimals.isEmpty
          ? _buildLoadingIndicator()
          : provider.apiError != null && provider.allAnimals.isEmpty
          ? _buildErrorWidget(provider.apiError!)
          : Container(
              color: isDark ? Colors.grey[900] : Colors.white,
              child: TabBarView(
                controller: _tabController,
                children: List.generate(7, (index) {
                  final animals = _getFilteredAnimals(provider, index);
                  return _buildAnimalList(animals, isDark);
                }),
              ),
            ),
      floatingActionButton: ExpandableFab(
        distance: 112,
        children: [
          FloatingActionButton.small(
            heroTag: 'addAnimal',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddAnimalScreen()),
            ),
            tooltip: 'Ajukan Hewan Baru',
            backgroundColor: isDark ? Colors.grey[800] : Colors.blueAccent,
            foregroundColor: isDark ? Colors.white : Colors.white,
            child: Icon(Icons.add),
          ),
          FloatingActionButton.small(
            heroTag: 'viewHistory',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SubmissionHistoryScreen()),
            ),
            tooltip: 'Riwayat Pengajuan',
            backgroundColor: isDark ? Colors.grey[800] : Colors.blueAccent,
            foregroundColor: isDark ? Colors.white : Colors.white,
            child: Icon(Icons.history),
          ),
        ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
    );
  }
}

class AnimalCard extends StatelessWidget {
  final Map<String, dynamic> animal;
  final bool isDark;

  const AnimalCard({super.key, required this.animal, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailScreen(animalName: animal['name']),
        ),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 2,
        color: isDark ? Colors.grey[800] : Colors.white,
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 10,
              child: Image.asset(
                animal['image'],
                fit: BoxFit.cover,
                width: double.infinity,
                //UPDATE: Tambah error builder untuk handle image error
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Icon(Icons.image, color: Colors.grey[600]),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    animal['name'],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 2),
                  Text(
                    animal['location'],
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey[400] : Colors.grey[700],
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Chip(
                          label: FittedBox(
                            child: Text(
                              animal['status'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          backgroundColor: animal['status'] == 'Dilindungi'
                              ? Colors.redAccent
                              : Colors.green,
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                        ),
                      ),
                      SizedBox(width: 6),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            "${animal['count']} ekor",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

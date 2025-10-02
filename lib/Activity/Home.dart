import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sopan_santun_app/Eka/activity/Profile_Page.dart';
import 'package:sopan_santun_app/Ryan/screens/home_screen.dart';
import 'SeeAllScreen.dart';
import 'DetailScreen.dart';
import '../Fauzan/News/home_screen.dart';
import '../Fauzan/Event/EventPage.dart';
import 'NotificationsScreen.dart';
import 'SettingsScreen.dart';
import '../Provider/hewan_provider.dart';
import '../legend.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeContent(),
    FauzanNewsHomeScreen(),
    EventLautPage(),
    RyanHomeScreen(),
    MyProfile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HewanProvider(),
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: _buildBottomNavBar(context),
      ),
    );
  }

  BottomNavigationBar _buildBottomNavBar(BuildContext context) {
    final theme = Theme.of(context);
    return BottomNavigationBar(
      backgroundColor: theme.colorScheme.surface,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: theme.colorScheme.primary,
      unselectedItemColor: theme.unselectedWidgetColor,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(fontSize: 12),
      unselectedLabelStyle: TextStyle(fontSize: 12),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.article_outlined),
          activeIcon: Icon(Icons.article),
          label: 'Berita',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event_outlined),
          activeIcon: Icon(Icons.event),
          label: 'Event',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school_outlined),
          activeIcon: Icon(Icons.school),
          label: 'Edukasi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(context), body: _buildBody(context));
  }

  AppBar _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor:
          theme.appBarTheme.backgroundColor ??
          (theme.brightness == Brightness.dark
              ? Colors.blueAccent
              : Colors.blueAccent),
      title: _buildSearchField(context),
      actions: [_buildProfileButton(context)],
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      decoration: InputDecoration(
        hintText: "Cari tahu tentang laut...",
        hintStyle: TextStyle(
          color: theme.brightness == Brightness.dark
              ? Colors.white70
              : Colors.white.withOpacity(0.7),
        ),
        prefixIcon: Icon(Icons.search, color: Colors.white),
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(vertical: 12),
      ),
      style: TextStyle(color: Colors.white),
    );
  }

  Widget _buildProfileButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.account_circle, size: 28),
      onPressed: null,
      tooltip: "Profil Pengguna",
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildWelcomeBanner(context),
          _buildBiodiversityChart(context),
          _buildAnimalListHeader(context),
          const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
          _buildAnimalList(context),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildWelcomeBanner(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<HewanProvider>(
      builder: (context, provider, _) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: provider.showWelcomeBanner
              ? Container(
                  key: ValueKey('welcome-banner'),
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.dark
                        ? Colors.blueAccent[700]
                        : Colors.lightBlue[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.waving_hand, color: Colors.amber),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Selamat Datang!",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Temukan keanekaragaman hayati laut di seluruh dunia",
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.textTheme.bodyMedium?.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, size: 18),
                        onPressed: () => provider.showWelcomeBanner = false,
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ],
                  ),
                )
              : SizedBox.shrink(key: ValueKey('empty-banner')),
        );
      },
    );
  }

  Widget _buildBiodiversityChart(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? Colors.grey[800]
            : Colors.lightBlue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Keanekaragaman Hayati di Tiap Samudra",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const LegendWidget(),
          const SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: Consumer<HewanProvider>(
              builder: (context, provider, _) => BarChart(
                BarChartData(
                  barGroups: provider.barChartGroups,
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: 5000,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${(value ~/ 1000)}K',
                            style: TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          List<String> samudra = [
                            "Pasifik",
                            "Atlantik",
                            "Hindia",
                            "Selatan",
                            "Arktik",
                          ];
                          return Text(
                            samudra[value.toInt()],
                            style: TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimalListHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Hewan yang Dilindungi",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SeeAllScreen()),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text("Lihat Semua"),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimalList(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<HewanProvider>(
      builder: (context, provider, _) {
        return ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: provider.protectedAnimals.length,
          separatorBuilder: (context, index) => SizedBox(height: 8),
          itemBuilder: (context, index) {
            final animal = provider.protectedAnimals[index];
            return ProtectedAnimal(
              name: animal['name']!,
              count: animal['count']!,
              location: animal['location']!,
              image: animal['image']!,
              status: animal['status']!,
            );
          },
        );
      },
    );
  }
}

class ProtectedAnimal extends StatefulWidget {
  final String name, count, location, image, status;

  const ProtectedAnimal({super.key, 
    required this.name,
    required this.count,
    required this.location,
    required this.image,
    required this.status,
  });

  @override
  _ProtectedAnimalState createState() => _ProtectedAnimalState();
}

class _ProtectedAnimalState extends State<ProtectedAnimal> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      elevation: 1,
      color: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(animalName: widget.name),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  widget.image,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            widget.location,
                            style: TextStyle(color: Colors.grey[600]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Chip(
                      label: Text(
                        widget.status,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      backgroundColor: widget.status == 'Dilindungi'
                          ? (Theme.of(context).brightness == Brightness.dark
                                ? Colors.green[800]
                                : Colors.lightGreen[100])
                          : (Theme.of(context).brightness == Brightness.dark
                                ? Colors.orange[800]
                                : Colors.orange[100]),
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Tooltip(
                    message: "Jumlah populasi",
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.brightness == Brightness.dark
                            ? Colors.blueAccent[700]
                            : Colors.lightBlue[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(widget.count, style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : Colors.grey[600],
                    ),
                    onPressed: () {
                      setState(() => _isFavorite = !_isFavorite);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _isFavorite
                                ? "${widget.name} ditambahkan ke favorit"
                                : "${widget.name} dihapus dari favorit",
                          ),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              setState(() => _isFavorite = !_isFavorite);
                            },
                          ),
                        ),
                      );
                    },
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    iconSize: 24,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

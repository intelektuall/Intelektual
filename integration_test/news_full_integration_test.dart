import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:sopan_santun_app/Fauzan/News/home_screen.dart';
import 'package:sopan_santun_app/Fauzan/News/Models/news_model.dart';
import 'package:sopan_santun_app/Fauzan/News/Models/news_provider.dart';
import 'package:sopan_santun_app/Fauzan/News/Widgets/news_card.dart';
import 'package:sopan_santun_app/Fauzan/News/detail_screen.dart';

/// --------------------------------------------------
/// FAKE PROVIDER (DATA PALSU UNTUK TEST)
/// --------------------------------------------------
class FakeNewsProvider extends ChangeNotifier implements NewsProvider {
  @override
  List<News> newsList = [];

  @override
  bool isLoading = false;

  @override
  String? errorMessage;

  @override
  Future<void> fetchNews() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));

    newsList = [
      News(
        id: '1',
        headline: 'Berita Trending Hari Ini',
        content: 'Isi berita trending...',
        date: DateTime.now(),
        imageUrl: 'assets/images/anjglaut.webp',
        category: 'trending',
      ),
      News(
        id: '2',
        headline: 'Berita Recommended',
        content: 'Isi berita recommended...',
        date: DateTime.now().subtract(const Duration(days: 1)),
        imageUrl: 'assets/images/lumba.webp',
        category: 'recommended',
      ),
      News(
        id: '3',
        headline: 'Berita Latest',
        content: 'Isi berita terbaru...',
        date: DateTime.now().subtract(const Duration(days: 2)),
        imageUrl: 'assets/images/paus.webp',
        category: 'trending',
      ),
      News(
        id: '4',
        headline: 'Penguin Lucu',
        content: 'Pennguinnnn...',
        date: DateTime.now().subtract(const Duration(days: 2)),
        imageUrl: 'assets/images/penguin.webp',
        category: 'recommended',
      ),
      News(
        id: '5',
        headline: 'Penyunyuuu',
        content: 'Penyuuuuuuuuuuuuuuu...',
        date: DateTime.now().subtract(const Duration(days: 2)),
        imageUrl: 'assets/images/penyu.webp',
        category: 'latest',
      ),
    ];

    isLoading = false;
    notifyListeners();
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Widget buildTestApp() {
    return ChangeNotifierProvider<NewsProvider>(
      create: (_) => FakeNewsProvider(),
      child: const MaterialApp(home: FauzanNewsHomeScreen()),
    );
  }

  group('Fauzan News – Full Integration Test', () {
    testWidgets('TEST 1 – Aplikasi terbuka & berita dimuat', (tester) async {
      debugPrint('TEST 1 – Menguji aplikasi terbuka dan load berita');

      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(find.text('DeepNews'), findsOneWidget);
      expect(find.byType(CarouselSlider), findsOneWidget);
      expect(find.byType(NewsCard), findsWidgets);
    });

    testWidgets('TEST 2 – User memilih kategori Trending', (tester) async {
      debugPrint('TEST 2 – Menguji filter kategori Trending');

      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Trending'));
      await tester.pumpAndSettle();

      expect(find.text('Berita Trending Hari Ini'), findsWidgets);
    });

    testWidgets('TEST 3 – User mengganti tampilan List ke Grid', (
      tester,
    ) async {
      debugPrint('TEST 3 – Menguji perubahan tampilan List ke Grid');

      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.grid_view));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('TEST 4 – User scroll membaca berita', (tester) async {
      debugPrint('TEST 4 – Menguji scroll daftar berita');

      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();

      expect(find.byType(NewsCard), findsWidgets);
    });

    testWidgets('TEST 5 – User membuka detail berita', (tester) async {
      debugPrint('TEST 5 – Menguji navigasi ke halaman detail');

      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(NewsCard).first);

      // ⏳ COOLDOWN agar animasi route terlihat
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();

      expect(find.byType(DetailScreen), findsOneWidget);
    });

    testWidgets('TEST 6 – User kembali dari detail ke home', (tester) async {
      debugPrint('TEST 6 – Menguji navigasi kembali ke home');

      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(NewsCard).first);
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpAndSettle();

      await tester.pageBack();

      // ⏳ cooldown kembali ke home
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      expect(find.text('DeepNews'), findsOneWidget);
    });
  });
  testWidgets('TEST 7 – User menekan tombol Share di halaman detail', (
    tester,
  ) async {
    debugPrint('TEST 7 – Menguji tombol share di halaman detail');

    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    // Masuk ke detail
    await tester.tap(find.byType(NewsCard).first);
    await tester.pump(); // mulai transisi
    await tester.pump(
      const Duration(seconds: 2),
    ); // ⏳ tunggu loading palsu selesai

    // Pastikan tombol share ada
    expect(find.byKey(const Key('share_button')), findsOneWidget);

    // Tap tombol share
    await tester.tap(find.byKey(const Key('share_button')));
    await tester.pumpAndSettle();

    // BottomSheet share muncul
    expect(find.text('Bagikan ke...'), findsOneWidget);
  });

  testWidgets('TEST 8 – Rotate screen (portrait ↔ landscape)', (tester) async {
    debugPrint('TEST 8 – Menguji rotasi layar');

    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    // =============================
    // PORTRAIT
    // =============================
    await tester.binding.setSurfaceSize(const Size(400, 800));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    expect(find.byType(FauzanNewsHomeScreen), findsOneWidget);

    // =============================
    // LANDSCAPE
    // =============================
    await tester.binding.setSurfaceSize(const Size(800, 400));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    // UI tetap hidup (tidak crash)
    expect(find.byType(NewsCard), findsWidgets);

    // =============================
    // RESET (WAJIB & LANGSUNG)
    // =============================
    await tester.binding.setSurfaceSize(null);
  });
}

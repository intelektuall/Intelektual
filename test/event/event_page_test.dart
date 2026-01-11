import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:sopan_santun_app/Fauzan/Event/Providers/event_provider.dart';
import 'package:sopan_santun_app/Fauzan/Event/Widget/event_list_section.dart';

/// ===============================
/// TEST EVENT PROVIDER
/// ===============================
class TestEventProvider extends EventProvider {
  final List<Event> initialEvents;

  TestEventProvider({List<Event>? events})
    : initialEvents = events ?? [],
      super() {
    this.events.addAll(initialEvents);
  }

  @override
  Future<void> loadEvents() async {
    events.clear();
    events.addAll(initialEvents);
    notifyListeners();
  }

  @override
  Future<void> toggleJoin(Event event) async {
    event.joined = !event.joined;
    notifyListeners();
  }
}

void _dummyNotify() {}

Widget _buildTestWidget({
  required List<Event> events,
  String? selectedLocation,
  String? selectedCategory,
  bool showJoinedOnly = false,
}) {
  return ChangeNotifierProvider<EventProvider>(
    create: (_) => TestEventProvider(events: events),
    child: MaterialApp(
      home: Scaffold(
        body: EventListSection(
          loadingFuture: Future.value(),
          selectedLocation: selectedLocation,
          selectedCategory: selectedCategory,
          showJoinedOnly: showJoinedOnly,
          onNotify: _dummyNotify,
        ),
      ),
    ),
  );
}

// === GLOBAL VARIABLES ===
int totalTests = 0;
int passedTests = 0;

void main() {
  print('🚀 MEMULAI TEST EVENT PAGE...\n');

  /// ===============================
  /// UNIT TEST EVENT MODEL
  /// ===============================
  group('Unit Test Event Model', () {
    test('Test 1: Mengecek event default memiliki status joined = false', () {
      totalTests++;
      final event = Event(
        title: 'Test',
        location: 'Jakarta',
        category: 'Edukasi',
        city: 'Jakarta Selatan',
      );
      expect(event.joined, false);
      passedTests++;
      print('   ✅ Test 1: PASSED - Event default joined = false');
    });

    test('Test 2: Mengecek event dapat memiliki status joined = true', () {
      totalTests++;
      final event = Event(
        title: 'Test',
        location: 'Jakarta',
        category: 'Edukasi',
        city: 'Jakarta Selatan',
        joined: true,
      );
      expect(event.joined, true);
      passedTests++;
      print('   ✅ Test 2: PASSED - Event bisa memiliki joined = true');
    });

    test('Test 3: Mengecek title event sesuai dengan yang di-set', () {
      totalTests++;
      final event = Event(
        title: 'Event Test',
        location: 'Jakarta',
        category: 'Sosial',
        city: 'Jakarta Selatan',
      );
      expect(event.title, 'Event Test');
      passedTests++;
      print('   ✅ Test 3: PASSED - Title event sesuai');
    });
  });

  /// ===============================
  /// WIDGET TEST EVENT PAGE
  /// ===============================
  group('Widget Test Event Page', () {
    testWidgets('Test 4: Mengecek pesan kosong tampil saat list kosong', (
      tester,
    ) async {
      totalTests++;
      await tester.pumpWidget(_buildTestWidget(events: []));
      await tester.pump();
      expect(find.text('Tidak ada event ditemukan'), findsOneWidget);
      passedTests++;
      print('   ✅ Test 4: PASSED - Pesan kosong tampil');
    });

    testWidgets('Test 5: Mengecek event berhasil ditampilkan dalam list', (
      tester,
    ) async {
      totalTests++;
      await tester.pumpWidget(
        _buildTestWidget(
          events: [
            Event(
              title: 'Event Test',
              location: 'DKI Jakarta',
              category: 'Edukasi',
              city: 'Jakarta Selatan',
            ),
          ],
        ),
      );
      await tester.pump();
      expect(find.text('Event Test'), findsAtLeastNWidgets(1));
      passedTests++;
      print('   ✅ Test 5: PASSED - Event berhasil ditampilkan');
    });

    testWidgets('Test 6: Mengecek filter lokasi bekerja', (tester) async {
      totalTests++;
      await tester.pumpWidget(
        _buildTestWidget(
          events: [
            Event(
              title: 'Jakarta Event',
              location: 'DKI Jakarta',
              category: 'Edukasi',
              city: 'Jakarta Selatan',
            ),
            Event(
              title: 'Bali Event',
              location: 'Bali',
              category: 'Edukasi',
              city: 'Denpasar',
            ),
          ],
          selectedLocation: 'DKI Jakarta',
        ),
      );
      await tester.pump();
      expect(find.text('Jakarta Event'), findsAtLeastNWidgets(1));
      expect(find.text('Bali Event'), findsNothing);
      passedTests++;
      print('   ✅ Test 6: PASSED - Filter lokasi bekerja');
    });

    testWidgets('Test 7: Mengecek filter kategori bekerja', (tester) async {
      totalTests++;
      await tester.pumpWidget(
        _buildTestWidget(
          events: [
            Event(
              title: 'Event Edukasi',
              location: 'DKI Jakarta',
              category: 'Edukasi',
              city: 'Jakarta Selatan',
            ),
            Event(
              title: 'Event Sosial',
              location: 'DKI Jakarta',
              category: 'Sosial',
              city: 'Jakarta Selatan',
            ),
          ],
          selectedCategory: 'Edukasi',
        ),
      );
      await tester.pump();
      expect(find.text('Event Edukasi'), findsAtLeastNWidgets(1));
      expect(find.text('Event Sosial'), findsNothing);
      passedTests++;
      print('   ✅ Test 7: PASSED - Filter kategori bekerja');
    });

    testWidgets('Test 8: Mengecek filter "hanya yang diikuti" bekerja', (
      tester,
    ) async {
      totalTests++;
      await tester.pumpWidget(
        _buildTestWidget(
          events: [
            Event(
              title: 'Joined Event',
              location: 'DKI Jakarta',
              category: 'Edukasi',
              city: 'Jakarta Selatan',
              joined: true,
            ),
            Event(
              title: 'Not Joined Event',
              location: 'DKI Jakarta',
              category: 'Edukasi',
              city: 'Jakarta Selatan',
              joined: false,
            ),
          ],
          showJoinedOnly: true,
        ),
      );
      await tester.pump();
      expect(find.text('Joined Event'), findsAtLeastNWidgets(1));
      expect(find.text('Not Joined Event'), findsNothing);
      passedTests++;
      print('   ✅ Test 8: PASSED - Filter "hanya yang diikuti" bekerja');
    });

    testWidgets(
      'Test 9: Mengecek event dengan semua field berhasil ditampilkan',
      (tester) async {
        totalTests++;
        await tester.pumpWidget(
          _buildTestWidget(
            events: [
              Event(
                title: 'Full Event',
                location: 'DKI Jakarta',
                category: 'Lingkungan',
                city: 'Jakarta Selatan',
                date: DateTime(2025, 7, 15),
                startTime: '08:00',
                endTime: '10:00',
                joined: true,
              ),
            ],
          ),
        );
        await tester.pump();
        expect(find.text('Full Event'), findsAtLeastNWidgets(1));
        passedTests++;
        print(
          '   ✅ Test 9: PASSED - Event dengan semua field berhasil ditampilkan',
        );
      },
    );
  });

  /// ===============================
  /// SUMMARY - Dipanggil SETELAH semua test selesai
  /// ===============================
  // Tambahkan callback untuk dijalankan setelah semua test
}

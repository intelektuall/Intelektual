//GUNAKAN PERINTAH INI UNTUK MENJALANKAN TEST : flutter test integration_test/profile_flow_test.dart --dart-define=INTEGRATION_TEST=true

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';

import 'package:sopan_santun_app/Eka/provider/settings_provider.dart';
import 'package:sopan_santun_app/Eka/activity/Profile_Page.dart';

import 'mocks/mock_firestore_profile_edit.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpApp(
    WidgetTester tester,
    MockFirestoreProfileEdit mock,
  ) async {
    debugPrint('→ Pumping application...');
    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => SettingsProvider())],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MyProfile(firestore: mock),
        ),
      ),
    );
    await tester.pumpAndSettle();
    debugPrint('✓ Application ready');
  }

  group('PROFILE FLOW – 8 INTEGRATION TESTS (WITH LOG)', () {
    // 1️⃣ PROFILE LOAD
    testWidgets('1️⃣ Profile loads initial data', (tester) async {
      debugPrint('\n[TEST 1] Profile loads initial data');
      final mock = MockFirestoreProfileEdit();
      await pumpApp(tester, mock);

      expect(find.text('Mock User'), findsOneWidget);
      expect(find.text('mock@mail.com'), findsOneWidget);

      debugPrint('✓ TEST 1 PASSED');
    });

    // 2️⃣ AVATAR EXISTS
    testWidgets('2️⃣ Avatar widget exists', (tester) async {
      debugPrint('\n[TEST 2] Avatar widget exists');
      final mock = MockFirestoreProfileEdit();
      await pumpApp(tester, mock);

      expect(find.byType(CircleAvatar), findsWidgets);

      debugPrint('✓ TEST 2 PASSED');
    });

    // 3️⃣ OPEN EDIT PAGE
    testWidgets('3️⃣ Navigate to edit profile', (tester) async {
      debugPrint('\n[TEST 3] Navigate to Edit Profile');
      final mock = MockFirestoreProfileEdit();
      await pumpApp(tester, mock);

      await tester.tap(find.byKey(const Key('test_edit_profile')));
      await tester.pumpAndSettle();

      expect(find.text('Edit Profil'), findsOneWidget);
      debugPrint('✓ TEST 3 PASSED');
    });

    // 4️⃣ PREFILLED DATA
    testWidgets('4️⃣ Edit form prefilled from Firestore', (tester) async {
      debugPrint('\n[TEST 4] Prefilled edit form');
      final mock = MockFirestoreProfileEdit();
      await pumpApp(tester, mock);

      await tester.tap(find.byKey(const Key('test_edit_profile')));
      await tester.pumpAndSettle();

      final pekerjaan = tester.widget<TextField>(
        find.byKey(const Key('field_pekerjaan')),
      );

      debugPrint('→ Loaded pekerjaan: ${pekerjaan.controller!.text}');
      expect(pekerjaan.controller!.text, 'QA Engineer');

      debugPrint('✓ TEST 4 PASSED');
    });

    // 5️⃣ SAVE DISABLED
    testWidgets('5️⃣ Save button disabled by default', (tester) async {
      debugPrint('\n[TEST 5] Save button disabled without agreement');
      final mock = MockFirestoreProfileEdit();
      await pumpApp(tester, mock);

      await tester.tap(find.byKey(const Key('test_edit_profile')));
      await tester.pumpAndSettle();

      final btn = tester.widget<ElevatedButton>(
        find.byKey(const Key('btn_save_profile')),
      );

      expect(btn.onPressed, isNull);
      debugPrint('✓ Save button correctly disabled');
      debugPrint('✓ TEST 5 PASSED');
    });

    // 6️⃣ SAVE LOGIC
    testWidgets('6️⃣ Save updates firestore data (logic)', (tester) async {
      debugPrint('\n[TEST 6] Save updates Firestore data');
      final mock = MockFirestoreProfileEdit();

      debugPrint('→ Saving mock data...');
      await mock.saveProfileData({
        'pekerjaan': 'Flutter Engineer',
        'bio': 'Integration test berjalan',
      });

      final data = await mock.getProfileOnce();
      debugPrint('→ Data after save: $data');

      expect(data['pekerjaan'], 'Flutter Engineer');
      expect(data['bio'], 'Integration test berjalan');

      debugPrint('✓ TEST 6 PASSED');
    });

    // 7️⃣ STREAM UPDATE
    testWidgets('7️⃣ Firestore stream reflects updated data', (tester) async {
      debugPrint('\n[TEST 7] Firestore stream update');
      final mock = MockFirestoreProfileEdit();

      await mock.saveProfileData({'pekerjaan': 'Updated via Stream'});

      final streamData = await mock.getProfileStream().first;
      debugPrint('→ Stream emitted: $streamData');

      expect(streamData['pekerjaan'], 'Updated via Stream');
      debugPrint('✓ TEST 7 PASSED');
    });

    // 8️⃣ LOGOUT BUTTON
    testWidgets('8️⃣ Logout button exists on profile page', (tester) async {
      debugPrint('\n[TEST 8] Logout button visibility');
      final mock = MockFirestoreProfileEdit();
      await pumpApp(tester, mock);

      expect(
        find.byKey(const Key('btn_logout'), skipOffstage: false),
        findsOneWidget,
      );

      debugPrint('✓ Logout button found');
      debugPrint('✓ TEST 8 PASSED');
    });
  });
}

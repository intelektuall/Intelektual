// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:provider/provider.dart';

// import 'package:sopan_santun_app/Eka/activity/Profile_Page.dart';
// import 'package:sopan_santun_app/Eka/provider/settings_provider.dart';

// import '../mock/mock_firestore_service.dart';

// void main() {
//   Widget buildTestable() {
//     return ChangeNotifierProvider(
//       create: (_) => SettingsProvider(),
//       child: MaterialApp(
//         home: MyProfile(
//           firestore: MockFirestoreService(),
//         ),
//       ),
//     );
//   }

//   /// ================= 1 =================
//   testWidgets('1. Halaman MyProfile tampil', (tester) async {
//     await tester.pumpWidget(buildTestable());
//     await tester.pump();
//     expect(find.byType(Scaffold), findsOneWidget);
//   });

//   /// ================= 2 =================
//   testWidgets('2. AppBar menampilkan Profile Page', (tester) async {
//     await tester.pumpWidget(buildTestable());
//     await tester.pump();
//     expect(find.text('Profile Page'), findsOneWidget);
//   });

//   /// ================= 3 =================
//   testWidgets('3. Nama user tampil dari stream', (tester) async {
//     await tester.pumpWidget(buildTestable());
//     await tester.pump();
//     expect(find.text('Test User'), findsOneWidget);
//   });

//   /// ================= 4 =================
//   testWidgets('4. Email user tampil', (tester) async {
//     await tester.pumpWidget(buildTestable());
//     await tester.pump();
//     expect(find.text('test@mail.com'), findsOneWidget);
//   });

//   /// ================= 5 =================
//   testWidgets('5. Label Nomor HP tampil', (tester) async {
//     await tester.pumpWidget(buildTestable());
//     await tester.pump();
//     expect(find.text('Nomor HP'), findsOneWidget);
//   });

//   /// ================= 6 =================
//   testWidgets('6. Label Jenis Kelamin tampil', (tester) async {
//     await tester.pumpWidget(buildTestable());
//     await tester.pump();
//     expect(find.text('Jenis Kelamin'), findsOneWidget);
//   });

//   /// ================= 7 =================
//   testWidgets('7. Label Pekerjaan tampil', (tester) async {
//     await tester.pumpWidget(buildTestable());
//     await tester.pump();
//     expect(find.text('Pekerjaan'), findsOneWidget);
//   });

//   /// ================= 8 =================
//   testWidgets('8. Popup menu tersedia', (tester) async {
//     await tester.pumpWidget(buildTestable());
//     await tester.pump();
//     expect(find.byType(PopupMenuButton<String>), findsOneWidget);
//   });

//   /// ================= 9 =================
//   testWidgets('9. Popup menu berisi Edit, Settings, About', (tester) async {
//     await tester.pumpWidget(buildTestable());
//     await tester.pump();

//     await tester.tap(find.byType(PopupMenuButton<String>));
//     await tester.pumpAndSettle();

//     expect(find.text('Edit Profil'), findsOneWidget);
//     expect(find.text('Settings'), findsOneWidget);
//     expect(find.text('About Us'), findsOneWidget);
//   });

//   /// ================= 10 =================
//   testWidgets('10. Bottom sheet edit foto muncul', (tester) async {
//     await tester.pumpWidget(buildTestable());
//     await tester.pump();

//     await tester.tap(find.byIcon(Icons.edit).first);
//     await tester.pumpAndSettle();

//     expect(find.text('Buka Kamera'), findsOneWidget);
//     expect(find.text('Pilih dari Galeri'), findsOneWidget);
//     expect(find.text('Hapus Foto Profil'), findsOneWidget);
//   });

//   /// ================= 11 =================
//   testWidgets('11. Tombol Log Out tersedia (scroll)', (tester) async {
//     await tester.pumpWidget(buildTestable());
//     await tester.pump();

//     await tester.drag(
//       find.byType(ListView),
//       const Offset(0, -1000),
//     );
//     await tester.pumpAndSettle();

//     expect(find.text('Log Out'), findsOneWidget);
//     expect(find.byIcon(Icons.logout), findsOneWidget);
//   });

//   /// ================= 12 =================
//   testWidgets('12. Ikon edit foto tersedia', (tester) async {
//     await tester.pumpWidget(buildTestable());
//     await tester.pump();
//     expect(find.byIcon(Icons.edit), findsWidgets);
//   });
// }

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:sopan_santun_app/Eka/activity/Profile_Page.dart';
import 'package:sopan_santun_app/Eka/provider/settings_provider.dart';

import '../mock/mock_firestore_service.dart';

/// ================= PROGRESS BAR HELPER =================
const int totalTests = 12;
int completedTests = 0;

void printProgress(String testName) {
  completedTests++;
  final percent = (completedTests / totalTests * 100).round();
  final filled = (completedTests / totalTests * 20).round();
  final bar = '█' * filled + '░' * (20 - filled);

  print('[$bar] $percent% ($completedTests/$totalTests) ✓ $testName');
}

void main() {
  setUpAll(() {
    completedTests = 0;
  });

  Widget buildTestable() {
    return ChangeNotifierProvider(
      create: (_) => SettingsProvider(),
      child: MaterialApp(
        home: MyProfile(
          firestore: MockFirestoreService(),
        ),
      ),
    );
  }

  /// ================= 1 =================
  testWidgets('1. Halaman MyProfile tampil', (tester) async {
    await tester.pumpWidget(buildTestable());
    await tester.pump();
    expect(find.byType(Scaffold), findsOneWidget);
    printProgress('Halaman MyProfile tampil');
  });

  /// ================= 2 =================
  testWidgets('2. AppBar menampilkan Profile Page', (tester) async {
    await tester.pumpWidget(buildTestable());
    await tester.pump();
    expect(find.text('Profile Page'), findsOneWidget);
    printProgress('AppBar menampilkan Profile Page');
  });

  /// ================= 3 =================
  testWidgets('3. Nama user tampil dari stream', (tester) async {
    await tester.pumpWidget(buildTestable());
    await tester.pump();
    expect(find.text('Test User'), findsOneWidget);
    printProgress('Nama user tampil dari stream');
  });

  /// ================= 4 =================
  testWidgets('4. Email user tampil', (tester) async {
    await tester.pumpWidget(buildTestable());
    await tester.pump();
    expect(find.text('test@mail.com'), findsOneWidget);
    printProgress('Email user tampil');
  });

  /// ================= 5 =================
  testWidgets('5. Label Nomor HP tampil', (tester) async {
    await tester.pumpWidget(buildTestable());
    await tester.pump();
    expect(find.text('Nomor HP'), findsOneWidget);
    printProgress('Label Nomor HP tampil');
  });

  /// ================= 6 =================
  testWidgets('6. Label Jenis Kelamin tampil', (tester) async {
    await tester.pumpWidget(buildTestable());
    await tester.pump();
    expect(find.text('Jenis Kelamin'), findsOneWidget);
    printProgress('Label Jenis Kelamin tampil');
  });

  /// ================= 7 =================
  testWidgets('7. Label Pekerjaan tampil', (tester) async {
    await tester.pumpWidget(buildTestable());
    await tester.pump();
    expect(find.text('Pekerjaan'), findsOneWidget);
    printProgress('Label Pekerjaan tampil');
  });

  /// ================= 8 =================
  testWidgets('8. Popup menu tersedia', (tester) async {
    await tester.pumpWidget(buildTestable());
    await tester.pump();
    expect(find.byType(PopupMenuButton<String>), findsOneWidget);
    printProgress('Popup menu tersedia');
  });

  /// ================= 9 =================
  testWidgets('9. Popup menu berisi Edit, Settings, About', (tester) async {
    await tester.pumpWidget(buildTestable());
    await tester.pump();

    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();

    expect(find.text('Edit Profil'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('About Us'), findsOneWidget);
    printProgress('Popup menu berisi Edit, Settings, About');
  });

  /// ================= 10 =================
  testWidgets('10. Bottom sheet edit foto muncul', (tester) async {
    await tester.pumpWidget(buildTestable());
    await tester.pump();

    await tester.tap(find.byIcon(Icons.edit).first);
    await tester.pumpAndSettle();

    expect(find.text('Buka Kamera'), findsOneWidget);
    expect(find.text('Pilih dari Galeri'), findsOneWidget);
    expect(find.text('Hapus Foto Profil'), findsOneWidget);
    printProgress('Bottom sheet edit foto muncul');
  });

  /// ================= 11 =================
  testWidgets('11. Tombol Log Out tersedia (scroll)', (tester) async {
    await tester.pumpWidget(buildTestable());
    await tester.pump();

    await tester.drag(
      find.byType(ListView),
      const Offset(0, -1000),
    );
    await tester.pumpAndSettle();

    expect(find.text('Log Out'), findsOneWidget);
    expect(find.byIcon(Icons.logout), findsOneWidget);
    printProgress('Tombol Log Out tersedia');
  });

  /// ================= 12 =================
  testWidgets('12. Ikon edit foto tersedia', (tester) async {
    await tester.pumpWidget(buildTestable());
    await tester.pump();
    expect(find.byIcon(Icons.edit), findsWidgets);
    printProgress('Ikon edit foto tersedia');
  });
}

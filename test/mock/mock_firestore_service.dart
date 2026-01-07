import 'dart:async';
import 'package:sopan_santun_app/Eka/provider/firestore_service_base.dart';

class MockFirestoreService implements FirestoreServiceBase {
  final _controller = StreamController<Map<String, dynamic>>();

  MockFirestoreService() {
    _controller.add({
      'nama': 'Test User',
      'email': 'test@mail.com',
      'nomorHP': '08123456789',
      'jenisKelamin': 'Laki-laki',
      'umur': '20',
      'alamatRumah': 'Jakarta',
      'statusPernikahan': 'Belum Kawin',
      'bio': 'User testing',
      'profileImageBase64': '',
    });
  }

  @override
  Stream<Map<String, dynamic>> getProfileStream([String? userId]) {
    return _controller.stream;
  }

  @override
  Future<void> saveProfileData(Map<String, dynamic> data, [String? userId]) async {}

  @override
  Future<Map<String, dynamic>> getProfileOnce([String? userId]) async {
    return {};
  }

  @override
  Future<void> deleteProfile([String? userId]) async {}
}

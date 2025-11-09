// /Eka/provider/profile_stream.dart
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileStreamProvider {
  static final ProfileStreamProvider _instance =
      ProfileStreamProvider._internal();
  factory ProfileStreamProvider() => _instance;

  ProfileStreamProvider._internal() {
    _stream = Stream<Map<String, dynamic>>.multi((controller) {
      // kirim snapshot saat ini segera
      controller.add(_currentData);
      final sub = _controller.stream.listen(
        (data) => controller.add(data),
        onError: (e, s) => controller.addError(e, s),
      );
      controller.onCancel = () => sub.cancel();
    }, isBroadcast: true);
  }

  final StreamController<Map<String, dynamic>> _controller =
      StreamController<Map<String, dynamic>>.broadcast();

  late final Stream<Map<String, dynamic>> _stream;
  Stream<Map<String, dynamic>> get stream => _stream;

  Map<String, dynamic> _currentData = {
    "pekerjaan": "Penjaga Galaksi",
    "alamatRumah": "Base Alpha, Mars",
    "hobi": "Berlatih bela diri",
    "status": "Single",
    "bio": "Ultraman dari masa depan. Penyuka keadilan dan cahaya.",
  };

  /// Muat data dari SharedPreferences (jika belum ada, simpan default)
  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('profile_data');
    if (dataString != null && dataString.isNotEmpty) {
      try {
        final decoded = jsonDecode(dataString) as Map<String, dynamic>;
        _currentData = {..._currentData, ...decoded};
      } catch (e) {
        // biarkan default jika gagal decode
      }
    } else {
      await prefs.setString('profile_data', jsonEncode(_currentData));
    }

    _controller.add(_currentData);
  }

  /// Ambil data profil hanya sekali tanpa stream
  Future<Map<String, dynamic>> getProfileOnce() async {
    final prefs = await SharedPreferences.getInstance();
    final dataString = prefs.getString('profile_data');

    if (dataString != null && dataString.isNotEmpty) {
      try {
        final decoded = jsonDecode(dataString) as Map<String, dynamic>;
        _currentData = {..._currentData, ...decoded};
      } catch (e) {
        // abaikan error decode
      }
    }

    return Map<String, dynamic>.from(_currentData);
  }

  /// Update data, simpan ke SharedPreferences, dan kirim ke stream
  Future<void> updateProfile(Map<String, dynamic> newData) async {
    _currentData = {..._currentData, ...newData};
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_data', jsonEncode(_currentData));
    _controller.add(_currentData);
  }

  Map<String, dynamic> get currentData => _currentData;

  void dispose() {
    try {
      _controller.close();
    } catch (_) {}
  }
}

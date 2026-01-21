import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  /// Cek & minta permission lokasi
  static Future<bool> requestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // bisa juga tampilkan snackbar/toast agar user nyalakan GPS
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    // 🔹 Pastikan kita menangani semua kondisi yang mungkin
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever ||
        permission == LocationPermission.unableToDetermine) {
      permission = await Geolocator.requestPermission();
    }

    // 🔹 Kadang "only this time" akan kembali jadi denied saat app dibuka ulang
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  /// Ambil nama provinsi dari GPS
  static Future<String?> getProvinceFromGPS() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        return placemarks.first.administrativeArea;
      }
      return null;
    } catch (e) {
      // Kalau gagal (misalnya GPS mati / izin ditolak)
      print("❌ Gagal mendapatkan provinsi: $e");
      return null;
    }
  }
}

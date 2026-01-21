import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../Services/location_services.dart';
import '../Utils/location_dialog.dart';
import '../EventDataList/event_constants.dart';

class EventLocationHelper {
  static Future<String?> detectProvince(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // 1️⃣ Tampilkan dialog izin logis (popup buatan sendiri)
    final agreed = await LocationDialogHelper.showLocationDialog(context);
    if (!agreed) return null;

    // 2️⃣ Cek & minta izin sistem lokasi
    final granted = await LocationService.requestPermission();
    if (!granted) return null;

    // 3️⃣ Tampilkan dialog loading agar user tahu aplikasi bekerja
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text("Mendeteksi lokasi Anda..."),
          ],
        ),
      ),
    );

    try {
      // 4️⃣ Ambil lokasi
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // Tutup loading dialog
      Navigator.of(context, rootNavigator: true).pop();

      if (placemarks.isEmpty) return null;

      final rawProvince = placemarks.first.administrativeArea ?? '';
      final normalized = normalizeProvince(rawProvince);

      return provinces.contains(normalized) ? normalized : null;
    } catch (e) {
      // Tutup loading kalau error
      Navigator.of(context, rootNavigator: true).pop();
      debugPrint("❌ Gagal mendeteksi lokasi: $e");
      return null;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static int cameraDenyCount = 0;
  static int galleryDenyCount = 0;
  static int notificationDenyCount = 0;
  static int contactDenyCount = 0;
  static int callDenyCount = 0;

  // ==========================================================
  // CAMERA
  // ==========================================================
  static Future<bool> requestCamera(BuildContext context) async {
    final status = await Permission.camera.request();

    if (status.isGranted) {
      cameraDenyCount = 0;
      return true;
    }

    if (status.isPermanentlyDenied) {
      _showDialog(context, "Izin Kamera Dibutuhkan",
          "Aplikasi membutuhkan izin kamera. Aktifkan melalui pengaturan.");
      return false;
    }

    cameraDenyCount++;
    if (cameraDenyCount >= 3) {
      _showDialog(context, "Izin Kamera Dibutuhkan",
          "Kamu sudah menolak izin kamera berkali-kali. Buka pengaturan.");
    }

    return false;
  }

  // ==========================================================
  // GALLERY
  // ==========================================================
  static Future<bool> requestGallery(BuildContext context) async {
    final status = await Permission.photos.request();

    if (status.isGranted) {
      galleryDenyCount = 0;
      return true;
    }

    if (status.isPermanentlyDenied) {
      _showDialog(context, "Izin Galeri Dibutuhkan",
          "Aplikasi membutuhkan akses galeri. Aktifkan melalui pengaturan.");
      return false;
    }

    galleryDenyCount++;
    if (galleryDenyCount >= 3) {
      _showDialog(context, "Izin Galeri Dibutuhkan",
          "Kamu sudah menolak izin galeri berkali-kali. Buka pengaturan.");
    }

    return false;
  }

  // ==========================================================
  // NOTIFICATION
  // ==========================================================
  static Future<bool> requestNotification(BuildContext context) async {
    final status = await Permission.notification.request();

    if (status.isGranted) {
      notificationDenyCount = 0;
      return true;
    }

    if (status.isPermanentlyDenied) {
      _showDialog(context, "Izin Notifikasi Diperlukan",
          "Aktifkan izin notifikasi di pengaturan aplikasi.");
      return false;
    }

    notificationDenyCount++;
    if (notificationDenyCount >= 3) {
      _showDialog(context, "Izin Notifikasi Diperlukan",
          "Kamu sudah menolak izin notifikasi berkali-kali. Buka pengaturan.");
    }

    return false;
  }

  // ==========================================================
  // ==================== CONTACT PERMISSION ==================
  // ==========================================================
  static Future<bool> requestContacts(BuildContext context) async {
    final status = await Permission.contacts.request();

    if (status.isGranted) {
      contactDenyCount = 0;
      return true;
    }

    if (status.isPermanentlyDenied) {
      _showDialog(context, "Izin Kontak Dibutuhkan",
          "Aplikasi membutuhkan izin kontak untuk membuka WhatsApp.");
      return false;
    }

    contactDenyCount++;
    if (contactDenyCount >= 3) {
      _showDialog(context, "Izin Kontak Dibutuhkan",
          "Kamu sudah menolak izin kontak beberapa kali. Buka pengaturan.");
    }

    return false;
  }

  // ==========================================================
  // ==================== CALL PERMISSION =====================
  // ==========================================================
  static Future<bool> requestCall(BuildContext context) async {
    final status = await Permission.phone.request();

    if (status.isGranted) {
      callDenyCount = 0;
      return true;
    }

    if (status.isPermanentlyDenied) {
      _showDialog(context, "Izin Telepon Diperlukan",
          "Aplikasi membutuhkan izin telepon untuk melakukan panggilan.");
      return false;
    }

    callDenyCount++;
    if (callDenyCount >= 3) {
      _showDialog(context, "Izin Telepon Diperlukan",
          "Kamu sudah menolak izin telepon berkali-kali. Buka pengaturan.");
    }

    return false;
  }

  // ==========================================================
  // DIALOG POPUP
  // ==========================================================
  static void _showDialog(BuildContext context, String title, String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              openAppSettings();
            },
            child: const Text("Buka Pengaturan"),
          ),
        ],
      ),
    );
  }
}

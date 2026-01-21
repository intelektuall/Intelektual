import 'package:flutter/material.dart';

class LocationDialogHelper {
  // variabel statis untuk menyimpan status sementara
  static bool _hasAgreed = false;
  static bool _hasAsked = false;

  static Future<bool> showLocationDialog(BuildContext context) async {
    // jika user sudah pernah menjawab di sesi ini, langsung kembalikan hasilnya
    if (_hasAsked) return _hasAgreed;

    final result =
        await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: const Text("Akses Lokasi"),
            content: const Text(
              "Aplikasi membutuhkan akses lokasi untuk menampilkan event laut "
              "yang relevan berdasarkan provinsi Anda.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("OK"),
              ),
            ],
          ),
        ) ??
        false;

    // simpan sementara selama app masih hidup
    _hasAsked = true;
    _hasAgreed = result;

    return result;
  }

  // opsional: reset manual kalau perlu
  static void reset() {
    _hasAsked = false;
    _hasAgreed = false;
  }
}

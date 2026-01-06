import 'package:flutter/material.dart';

Future<bool> showLocationDialog(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: Text("Akses Lokasi"),
          content: Text(
            "Aplikasi membutuhkan akses lokasi untuk menampilkan event laut "
            "yang relevan berdasarkan provinsi Anda.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text("OK"),
            ),
          ],
        ),
      ) ??
      false;
}

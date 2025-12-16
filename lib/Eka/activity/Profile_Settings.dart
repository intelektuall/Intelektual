import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/Eka/provider/settings_provider.dart';
import '/Eka/provider/firebase_helper.dart';
import '/Eka/provider/permission_helper.dart';

class ProfileSettings extends StatelessWidget {
  const ProfileSettings({super.key});

  void showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.grey,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  // ==========================================================
  // PRE-PERMISSION DIALOG (BARU)
  // ==========================================================
  Future<bool> _showPermissionReasonDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text("Lanjutkan"),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final text = Theme.of(context).textTheme.bodyLarge;
    final surface = dark ? Colors.grey[900] : Colors.white;

    FirebaseAnalyticsHelper.setCurrentScreen(
      screenName: "ProfileSettings",
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan"),
        backgroundColor: Colors.blueAccent,
        leading: const BackButton(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ================= NOTIFIKASI =================
          ListTile(
            tileColor: surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text("Notifikasi", style: text),
            trailing: Switch(
              value: settings.isNotificationEnabled,
              activeColor: Colors.blueAccent,
              onChanged: (val) async {
                if (val) {
                  // ---- PRE DIALOG ----
                  final agree = await _showPermissionReasonDialog(
                    context,
                    "Izin Notifikasi",
                    "Aplikasi membutuhkan izin notifikasi untuk "
                        "memberikan informasi dan pembaruan penting.",
                  );
                  if (!agree) return;

                  // ---- SYSTEM PERMISSION ----
                  final granted =
                      await PermissionHelper.requestNotification(context);
                  if (!granted) {
                    showSnack(context, "Izin notifikasi ditolak");
                    return;
                  }
                }

                settings.setNotification(val);
                showSnack(
                  context,
                  "Notifikasi ${val ? "diaktifkan" : "dinonaktifkan"}",
                );

                FirebaseAnalyticsHelper.logEvent(
                  name: "setting_changed",
                  parameters: {
                    "setting": "notification",
                    "value": val,
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // ================= MODE LATAR =================
          ListTile(
            tileColor: surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text("Mode Latar Belakang", style: text),
            subtitle: Text(settings.backgroundMode),
            trailing: Switch(
              value: settings.backgroundMode == "Hitam",
              activeColor: Colors.blueAccent,
              onChanged: (val) {
                final mode = val ? "Hitam" : "Putih";
                settings.setBackgroundMode(mode);
                showSnack(context, "Mode latar belakang $mode");

                FirebaseAnalyticsHelper.logEvent(
                  name: "setting_changed",
                  parameters: {
                    "setting": "background_mode",
                    "value": mode,
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // ================= BAHASA =================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text("Bahasa Aplikasi", style: text),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: settings.language,
            decoration: InputDecoration(
              filled: true,
              fillColor: surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: const [
              DropdownMenuItem(
                  value: "Indonesia", child: Text("Indonesia")),
              DropdownMenuItem(
                  value: "English", child: Text("English")),
            ],
            onChanged: (val) {
              if (val != null) {
                settings.setLanguage(val);
                showSnack(context, "Bahasa diubah ke $val");

                FirebaseAnalyticsHelper.logEvent(
                  name: "setting_changed",
                  parameters: {
                    "setting": "language",
                    "value": val,
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

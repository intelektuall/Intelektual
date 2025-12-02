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
        duration: Duration(seconds: 2),
        backgroundColor: Colors.grey,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final text = Theme.of(context).textTheme.bodyLarge;
    final surface = dark ? Colors.grey[900] : Colors.white;
    FirebaseAnalyticsHelper.setCurrentScreen(screenName: "ProfileSettings");

    return Scaffold(
      appBar: AppBar(
        title: Text("Pengaturan"),
        backgroundColor: Colors.blueAccent,
        leading: BackButton(color: Colors.white),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // NOTIFIKASI + PERMISSION
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
                  final ok = await PermissionHelper.requestNotification(context);
                  if (!ok) {
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
                  parameters: {"setting": "notification", "value": val},
                );
              },
            ),
          ),
          SizedBox(height: 12),

          // MODE LATAR BELAKANG
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
                  parameters: {"setting": "background_mode", "value": mode},
                );
              },
            ),
          ),
          SizedBox(height: 24),

          // BAHASA
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text("Bahasa Aplikasi", style: text),
          ),
          SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: settings.language,
            decoration: InputDecoration(
              filled: true,
              fillColor: surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: [
              DropdownMenuItem(value: "Indonesia", child: Text("Indonesia")),
              DropdownMenuItem(value: "English", child: Text("English")),
            ],
            onChanged: (val) {
              if (val != null) {
                settings.setLanguage(val);
                showSnack(context, "Bahasa diubah ke $val");

                FirebaseAnalyticsHelper.logEvent(
                  name: "setting_changed",
                  parameters: {"setting": "language", "value": val},
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

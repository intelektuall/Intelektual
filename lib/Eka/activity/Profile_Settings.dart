// Eka/activity/Profile_Settings.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/Eka/provider/settings_provider.dart';

class ProfileSettings extends StatelessWidget {
  const ProfileSettings({super.key});

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.grey,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textStyle = Theme.of(context).textTheme.bodyLarge;
    final surfaceColor = isDark ? Colors.grey[900] : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan"),
        backgroundColor: Colors.blueAccent,
        leading: const BackButton(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // === Kunci Aplikasi ===
          ListTile(
            tileColor: surfaceColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text("Kunci Aplikasi", style: textStyle),
            trailing: Switch(
              value: settings.isLockAppOn,
              activeColor: Colors.blueAccent,
              onChanged: (val) {
                settings.setLockApp(val);
                showSnackBar(context, "Kunci aplikasi ${val ? "diaktifkan" : "dinonaktifkan"}");
              },
            ),
          ),
          const SizedBox(height: 12),

          // === Mode Latar Belakang ===
          ListTile(
            tileColor: surfaceColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text("Mode Latar Belakang", style: textStyle),
            subtitle: Text(settings.backgroundMode),
            trailing: Switch(
              value: settings.backgroundMode == "Hitam",
              activeColor: Colors.blueAccent,
              onChanged: (val) {
                final newMode = val ? "Hitam" : "Putih";
                settings.setBackgroundMode(newMode);
                showSnackBar(context, "Mode latar belakang diubah ke $newMode");
              },
            ),
          ),
          const SizedBox(height: 12),

          // === Notifikasi ===
          ListTile(
            tileColor: surfaceColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text("Notifikasi", style: textStyle),
            trailing: Switch(
              value: settings.isNotificationEnabled,
              activeColor: Colors.blueAccent,
              onChanged: (val) {
                settings.setNotification(val);
                showSnackBar(context, "Notifikasi ${val ? "diaktifkan" : "dinonaktifkan"}");
              },
            ),
          ),
          const SizedBox(height: 12),

          // === Mode Hemat Daya ===
          ListTile(
            tileColor: surfaceColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text("Mode Hemat Daya", style: textStyle),
            trailing: Switch(
              value: settings.isPowerSavingMode,
              activeColor: Colors.blueAccent,
              onChanged: (val) {
                settings.setPowerSavingMode(val);
                showSnackBar(context, "Mode hemat daya ${val ? "diaktifkan" : "dinonaktifkan"}");
              },
            ),
          ),
          const SizedBox(height: 24),

          // === Bahasa Aplikasi ===
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text("Bahasa Aplikasi", style: textStyle),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: settings.language,
            decoration: InputDecoration(
              filled: true,
              fillColor: surfaceColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: const [
              DropdownMenuItem(value: "Indonesia", child: Text("Indonesia")),
              DropdownMenuItem(value: "English", child: Text("English")),
            ],
            onChanged: (val) {
              if (val != null) {
                settings.setLanguage(val);
                showSnackBar(context, "Bahasa diubah ke $val");
              }
            },
          ),
        ],
      ),
    );
  }
}

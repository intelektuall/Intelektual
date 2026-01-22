import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '/Eka/provider/settings_provider.dart';
import '/Eka/provider/firebase_helper.dart';
import '/Eka/provider/permission_helper.dart';
import '../../Ryan/providers/locale_provider.dart';
import '../../l10n/app_localizations.dart';

class ProfileSettings extends StatelessWidget {
  const ProfileSettings({super.key});

  // ================= SNACKBAR =================
  void showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.grey[800],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  /// ================= LANGUAGE MAP =================
  static const Map<String, Locale> languageMap = {
    'English': Locale('en'),
    'Indonesia': Locale('id'),
    'Español': Locale('es'),
    'Français': Locale('fr'),
    'हिन्दी': Locale('hi'),
    '中文': Locale('zh'),
    'Русский': Locale('ru'),
  };

  String _labelFromLocale(Locale locale) {
    return languageMap.entries
        .firstWhere(
          (e) => e.value.languageCode == locale.languageCode,
          orElse: () => const MapEntry('English', Locale('en')),
        )
        .key;
  }

  // ================= PERMISSION DIALOG =================
  Future<bool> _showPermissionReasonDialog(
    BuildContext context,
    String title,
    String messageLine1,
    String messageLine2,
  ) async {
    final l10n = AppLocalizations.of(context)!;

    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(messageLine1),
                const SizedBox(height: 8),
                Text(messageLine2),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(l10n.ctn),
              ),
            ],
          ),
        ) ??
        false;
  }

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = context.watch<SettingsProvider>();
    final localeProvider = context.watch<LocaleProvider>();

    final dark = Theme.of(context).brightness == Brightness.dark;
    final surface = dark ? Colors.grey[900] : Colors.white;
    final textStyle = Theme.of(context).textTheme.bodyLarge;

    FirebaseAnalyticsHelper.setCurrentScreen(screenName: 'ProfileSettings');

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        backgroundColor: Colors.blueAccent,
        leading: const BackButton(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ================= NOTIFICATION =================
          ListTile(
            tileColor: surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(l10n.notification, style: textStyle),
            trailing: Switch(
              value: settings.isNotificationEnabled,
              activeColor: Colors.blueAccent,
              onChanged: (val) async {
                if (val) {
                  final status = await Permission.notification.status;

                  if (!status.isGranted) {
                    final agree = await _showPermissionReasonDialog(
                      context,
                      l10n.notification,
                      l10n.notifPermissionDescLine1,
                      l10n.notifPermissionDescLine2,
                    );
                    if (!agree) return;

                    final granted = await PermissionHelper.requestNotification(
                      context,
                    );

                    if (!granted) {
                      showSnack(context, l10n.accessDenied);
                      return;
                    }
                  }
                }

                settings.setNotification(val);

                showSnack(
                  context,
                  "${l10n.notification} "
                  "${val ? l10n.enabled : l10n.disabled}",
                );

                FirebaseAnalyticsHelper.logEvent(
                  name: "setting_changed",
                  parameters: {"setting": "notification", "value": val},
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          // ================= BACKGROUND MODE =================
          ListTile(
            tileColor: surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(l10n.backgroundMode, style: textStyle),
            subtitle: Text(
              settings.backgroundMode == "Hitam" ? l10n.black : l10n.white,
            ),
            trailing: Switch(
              value: settings.backgroundMode == "Hitam",
              activeColor: Colors.blueAccent,
              onChanged: (val) {
                final modeLabel = val ? l10n.black : l10n.white;
                settings.setBackgroundMode(val ? "Hitam" : "Putih");

                showSnack(context, "${l10n.backgroundMode} $modeLabel");

                FirebaseAnalyticsHelper.logEvent(
                  name: "setting_changed",
                  parameters: {"setting": "background_mode", "value": val},
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // ================= LANGUAGE =================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(l10n.appLanguage, style: textStyle),
          ),
          const SizedBox(height: 8),

          DropdownButtonFormField<String>(
            value: _labelFromLocale(localeProvider.locale),
            decoration: InputDecoration(
              filled: true,
              fillColor: surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: languageMap.keys
                .map(
                  (label) => DropdownMenuItem(value: label, child: Text(label)),
                )
                .toList(),
            onChanged: (label) {
              if (label == null) return;

              final locale = languageMap[label]!;
              localeProvider.setLocale(locale);
              settings.setLanguage(label);
              // 2️⃣ TUNGGU frame berikutnya
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final newL10n = AppLocalizations.of(context)!;

                showSnack(context, "${newL10n.languageChangedTo} $label");
              });

              FirebaseAnalyticsHelper.logEvent(
                name: "setting_changed",
                parameters: {
                  "setting": "language",
                  "value": locale.languageCode,
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';

class LanguageSelectorSheet extends StatelessWidget {
  const LanguageSelectorSheet({super.key});

  static const _languages = [
    _Lang('id', 'Bahasa Indonesia', '🇮🇩'),
    _Lang('en', 'English', '🇬🇧'),
    _Lang('zh', '中文', '🇨🇳'),
    _Lang('es', 'Español', '🇪🇸'),
    _Lang('fr', 'Français', '🇫🇷'),
    _Lang('hi', 'हिन्दी', '🇮🇳'),
    _Lang('ru', 'Русский', '🇷🇺'),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LocaleProvider>();
    final current = provider.locale.languageCode;

    final maxHeight = MediaQuery.of(context).size.height * 0.75;

    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.55),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SafeArea(
              top: false,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxHeight),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Drag Indicator
                    Container(
                      width: 36,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    /// Header (Cupertino-style)
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.close,
                              color: CupertinoColors.white,
                            ),
                          ),
                        ),
                        const Text(
                          'Select Language',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: CupertinoColors.white,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    /// Language List (SCROLL ONLY IF NEEDED)
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: _languages.length,
                        separatorBuilder: (_, __) =>
                            const Divider(color: Colors.white24, height: 1),
                        itemBuilder: (context, index) {
                          final lang = _languages[index];
                          final isActive = current == lang.code;

                          return ListTile(
                            leading: Text(
                              lang.flag,
                              style: const TextStyle(fontSize: 22),
                            ),
                            title: Text(
                              lang.label,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            trailing: isActive
                                ? const Icon(
                                    Icons.check_circle,
                                    color: CupertinoColors.activeGreen,
                                  )
                                : null,
                            onTap: () {
                              provider.setLocale(Locale(lang.code));
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Lang {
  final String code;
  final String label;
  final String flag;

  const _Lang(this.code, this.label, this.flag);
}

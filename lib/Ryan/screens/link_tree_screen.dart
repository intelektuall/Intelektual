import 'package:flutter/material.dart';
import '../screens/detail_education_screen.dart';
import '../services/analytics_mixin.dart';
import 'package:provider/provider.dart';
import '../providers/link_provider.dart';
import '../widgets/link_button.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/language_selector_sheet.dart';

class LinkTreeScreen extends StatefulWidget {
  const LinkTreeScreen({super.key});

  @override
  State<LinkTreeScreen> createState() => _LinkTreeScreenState();
}

class _LinkTreeScreenState extends State<LinkTreeScreen>
    with AnalyticsScreenTracking {
  @override
  String get screenName => 'LinkTreeScreen';

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final linkProvider = Provider.of<LinkProvider>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final shadowColor = isDark ? Colors.black54 : Colors.black87;


    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          /// 🌊 Background Image
           Container(
            color: theme.scaffoldBackgroundColor,
          ),

          /// 🔹 Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.8),
                      ]
                    : [
                        Colors.white.withOpacity(0.2),
                        Colors.white.withOpacity(0.4),
                        Colors.white.withOpacity(0.5),
                      ],
              ),
            ),
          ),

          /// 🔝 Top Actions (Back + Language)
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// ⬅ Back Button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.3),
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: isDark ? Colors.white : Colors.black,
                      size: 26,
                    ),
                  ),
                ),

                /// 🌐 Language Button
                IconButton(
                  icon: Icon(
                    Icons.translate,
                    color: isDark ? Colors.white : Colors.black,
                    size: 26,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      builder: (_) => const LanguageSelectorSheet(),
                    );
                  },
                ),
              ],
            ),
          ),

          /// 📦 Konten Utama
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 55,
                  backgroundImage: AssetImage(
                    "assets/images/logoOcean-removebg.png",
                  ),
                  backgroundColor: Colors.transparent,
                ),
                const SizedBox(height: 16),

                /// 🏷 Title (Localized)
                Text(
                  t.appTitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredoka(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color:isDark ? Colors.white : Colors.black,
                    letterSpacing: 1.5,
                    shadows: [
                      Shadow(blurRadius: 8, color: shadowColor),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                /// 👋 Greeting (Localized)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    t.welcomeMessage,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.baloo2(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                      letterSpacing: 1.0,
                      shadows: [
                        Shadow(blurRadius: 5, color: shadowColor),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                /// 🔗 Navigation Cards
                ...linkProvider.links.map(
                  (item) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: LinkButton(
                      item: item,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const DetailEducationScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

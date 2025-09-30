import 'package:flutter/material.dart';
import '/Ryan/screens/detail_education_screen.dart';
import 'package:provider/provider.dart';
import '../providers/link_provider.dart';
import '../widgets/link_button.dart';
import 'package:google_fonts/google_fonts.dart';

class LinkTreeScreen extends StatefulWidget {
  const LinkTreeScreen({super.key});

  @override
  State<LinkTreeScreen> createState() => _LinkTreeScreenState();
}

class _LinkTreeScreenState extends State<LinkTreeScreen> {
  @override
  Widget build(BuildContext context) {
    final linkProvider = Provider.of<LinkProvider>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          /// 🔹 Background
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

          /// 🔹 Back Button
          Positioned(
            top: 40,
            left: 20,
            child: GestureDetector(
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
          ),

          /// 🔹 Main Content
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

                /// 🔸 Title
                Text(
                  "Life Below Water",
                  style: GoogleFonts.fredoka(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 20),

                /// 🔸 Greeting
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    "Halo! Yuk, jelajahi misteri kehidupan bawah laut bersama kami",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.baloo2(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white70 : Colors.black,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                /// 🔸 Link Buttons
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SeaLifeCard extends StatefulWidget {
  final String imagePath;
  final String title;
  final VoidCallback onTap;

  const SeaLifeCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.onTap,
  });

  @override
  State<SeaLifeCard> createState() => _SeaLifeCardState();
}

class _SeaLifeCardState extends State<SeaLifeCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Card(
            color: Colors.grey.shade800,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 6,
            shadowColor: Colors.black,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 🔹 Gambar diperluas proporsional
                Expanded(
                  flex: 4, // Lebih besar, misalnya 4:1
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    child: Image.asset(
                      widget.imagePath,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // 🔹 Title dipadatkan
                Expanded(
                  flex: 1, // Lebih kecil dari gambar
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 8.0,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.title,
                      style: GoogleFonts.poppins(
                        fontSize: 24, // Sedikit lebih kecil
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

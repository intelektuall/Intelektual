// Eka/model_eka/team_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/Eka/model_eka/team_member.dart';

class TeamCard extends StatelessWidget {
  final TeamMember member;
  final VoidCallback onWhatsAppTap;

  const TeamCard({
    super.key,
    required this.member,
    required this.onWhatsAppTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColorPrimary = isDark ? Colors.white : Colors.black87;
    final textColorSecondary = isDark ? Colors.white70 : Colors.black54;
    final accentColor = Colors.blueAccent;

    return Card(
      elevation: 6,
      color: isDark ? Colors.grey[850] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Gambar: Bisa lokal (assets) atau dari URL
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: _buildImageWidget(member.image),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    member.name,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColorPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    member.status,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: textColorSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tombol bawah (Team & WhatsApp)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Tooltip(
                  message: "Tim ${member.name}",
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blueAccent[100],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Icon(Icons.people, color: accentColor, size: 18),
                  ),
                ),
                const SizedBox(width: 12),
                Tooltip(
                  message: "Hubungi via WhatsApp",
                  child: GestureDetector(
                    onTap: onWhatsAppTap,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green[100],
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        FontAwesomeIcons.whatsapp,
                        color: Colors.green,
                        size: 18,
                      ),
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

  /// Widget untuk menampilkan gambar dari URL atau lokal
  Widget _buildImageWidget(String imagePath) {
    if (imagePath.startsWith('http')) {
      // Gambar online
      return CachedNetworkImage(
        imageUrl: imagePath,
        height: 120,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) =>
            const Icon(Icons.broken_image, size: 40),
      );
    } else {
      // Gambar lokal (assets)
      return Image.asset(
        imagePath,
        height: 120,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, size: 40),
      );
    }
  }
}

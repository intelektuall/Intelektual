import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/link_item.dart';

class LinkButton extends StatelessWidget {
  final LinkItem item;
  final VoidCallback onTap;

  const LinkButton({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.grey.shade800,
        child: ListTile(
          leading: Icon(item.icon, color: Colors.black, size: 32),
          title: Text(
            item.title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            item.buttonText,
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
        ),
      ),
    );
  }
}

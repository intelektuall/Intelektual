import 'dart:ui';
import 'package:flutter/material.dart';
import '../../models/coral_species.dart';
import 'overlayC_menu.dart';

class OverlayMenuManager {
  static OverlayEntry? _entry;

  static void showOrbitMenu({
    required BuildContext context,
    required CoralSpecies species,
    required Rect cardRect,
    required Widget selectedCard, // ← Tambahan
    required VoidCallback onDismiss,
  }) {
    dismiss(); // Hapus overlay sebelumnya jika ada

    _entry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          // Blur background
          Positioned.fill(
            child: GestureDetector(
              onTap: onDismiss,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(color: Colors.black.withOpacity(0.5)),
              ),
            ),
          ),

          // Orbit menu overlay dengan selectedCard
          OverlayBackgroundMenu(
            species: species,
            selectedCard: selectedCard, // ← Tambahkan parameter ini
            cardRect: cardRect,
            onDismiss: onDismiss,
          ),
        ],
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_entry!);
  }

  static void dismiss() {
    _entry?.remove();
    _entry = null;
  }
}

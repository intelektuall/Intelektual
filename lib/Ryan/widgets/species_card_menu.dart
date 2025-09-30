import 'package:flutter/material.dart';

class SpeciesCardMenu extends StatefulWidget {
  final VoidCallback onDelete;

  const SpeciesCardMenu({super.key, required this.onDelete});

  @override
  State<SpeciesCardMenu> createState() => _SpeciesCardMenuState();
}

class _SpeciesCardMenuState extends State<SpeciesCardMenu> {
  bool _isPressed = false;

  void _handleTap() {
    setState(() {
      _isPressed = true;
    });

    // Delay agar animasi terlihat sebelum melakukan aksi hapus
    Future.delayed(const Duration(milliseconds: 150), () {
      widget.onDelete();

      // Reset kembali ke outline (jika diperlukan ulang)
      setState(() {
        _isPressed = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) => ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
        child: child,
      ),
      child: IconButton(
        key: ValueKey(_isPressed),
        tooltip: _isPressed ? 'Menghapus...' : 'Hapus',
        icon: Icon(
          _isPressed ? Icons.delete : Icons.delete_outline,
          color: _isPressed ? Colors.red : Colors.redAccent,
        ),
        onPressed: _handleTap,
      ),
    );
  }
}

import 'package:flutter/material.dart';

void noUndoCustomSnackbar(
  BuildContext context, {
  required String message,
  Duration duration = const Duration(seconds: 3),
}) {
  final overlay = Overlay.of(context);

  OverlayEntry? overlayEntry; // Deklarasikan dulu sebagai nullable

  overlayEntry = OverlayEntry(
    builder:
        (_) => _AnimatedSnackbar(
          message: message,
          onDismissed: () {
            overlayEntry?.remove(); // Gunakan ?. agar aman
          },
          duration: duration,
        ),
  );

  overlay.insert(overlayEntry);
}

class _AnimatedSnackbar extends StatefulWidget {
  final String message;
  final VoidCallback onDismissed;
  final Duration duration;

  const _AnimatedSnackbar({
    required this.message,
    required this.onDismissed,
    required this.duration,
  });

  @override
  State<_AnimatedSnackbar> createState() => _AnimatedSnackbarState();
}

class _AnimatedSnackbarState extends State<_AnimatedSnackbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1.0),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    Future.delayed(widget.duration, () {
      if (mounted) {
        _controller.reverse().then((_) => widget.onDismissed());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 32,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.grey[900],
            elevation: 10,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.message,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

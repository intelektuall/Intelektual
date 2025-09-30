import 'package:flutter/material.dart';

class PressableIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color normalColor;
  final Color pressedColor;
  final Color pressedBackgroundColor;

  const PressableIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.normalColor = Colors.white,
    this.pressedColor = Colors.grey,
    this.pressedBackgroundColor = const Color.fromRGBO(255, 255, 255, 0.2),
  });

  @override
  _PressableIconButtonState createState() => _PressableIconButtonState();
}

class _PressableIconButtonState extends State<PressableIconButton> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    widget.onPressed();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              _isPressed ? widget.pressedBackgroundColor : Colors.transparent,
          boxShadow: _isPressed
              ? [
                  const BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Icon(
          widget.icon,
          color: _isPressed ? widget.pressedColor : widget.normalColor,
          size: 28,
        ),
      ),
    );
  }
}

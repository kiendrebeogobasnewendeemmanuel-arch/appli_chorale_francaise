import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final ButtonStyle style;

  const MenuButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: style,
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

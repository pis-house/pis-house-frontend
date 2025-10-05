import 'package:flutter/material.dart';

class PisTextButton extends StatelessWidget {
  final Color? color;
  final String label;
  final VoidCallback? onPressed;

  const PisTextButton({
    super.key,
    required this.label,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: color ?? Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: onPressed,
      child: Text(label, style: const TextStyle(fontSize: 16)),
    );
  }
}

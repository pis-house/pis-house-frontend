import 'package:flutter/material.dart';

class PisTextFormField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final double? width;
  final double? height;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final TextEditingController? controller;
  final bool enabled;

  const PisTextFormField({
    super.key,
    required this.label,
    this.obscureText = false,
    this.width,
    this.height,
    this.validator,
    this.onSaved,
    this.controller,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return SizedBox(
      width: width ?? double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: height,
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              validator: validator,
              onSaved: onSaved,
              enabled: enabled,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade500, width: 2),
                ),
                errorStyle: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

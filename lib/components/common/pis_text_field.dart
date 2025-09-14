import 'package:flutter/material.dart';

class PisTextField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final String? errorText;
  final double? width;
  final double? height;
  final ValueChanged<String>? onChanged;

  const PisTextField({
    super.key,
    required this.label,
    this.obscureText = false,
    this.errorText,
    this.width,
    this.height,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textField = TextField(
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
      ),
    );
    final textFieldWidget = height != null
        ? SizedBox(height: height, child: textField)
        : textField;

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textFieldWidget,
          if (errorText != null && errorText!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                errorText!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}

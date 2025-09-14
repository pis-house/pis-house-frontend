import 'package:flutter/material.dart';

class PisButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double? height;
  final double? width;

  const PisButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final button = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading) ...[
            SizedBox(
              width: (height ?? 40) * 0.5,
              height: (height ?? 40) * 0.5,
              child: const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: (height ?? 40) * 0.4,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );

    final buttonWidget = (width != null || height != null)
        ? SizedBox(
            width: width,
            height: height,
            child: IgnorePointer(ignoring: isLoading, child: button),
          )
        : IgnorePointer(ignoring: isLoading, child: button);

    return buttonWidget;
  }
}

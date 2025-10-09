import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PisButton extends HookConsumerWidget {
  final String label;
  final VoidCallback? onPressed;
  final double? height;
  final double? width;

  const PisButton({
    super.key,
    required this.label,
    this.onPressed,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isLoading = useState(false);
    final isDarkMode = theme.brightness == Brightness.dark;

    final button = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: isDarkMode
            ? const BorderSide(color: Colors.white, width: 1.0)
            : BorderSide.none,
      ),
      onPressed: () async {
        if (onPressed == null) {
          return;
        }
        isLoading.value = true;
        await Future.sync(() => onPressed!());
        if (context.mounted) {
          isLoading.value = false;
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading.value) ...[
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

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 40,
      child: IgnorePointer(ignoring: isLoading.value, child: button),
    );
  }
}

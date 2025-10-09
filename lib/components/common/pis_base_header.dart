import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pis_house_frontend/infrastructures/auth_service.dart';

class PisBaseHeader extends HookConsumerWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? extraActions;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? leadingWidth;
  final bool showAction;
  final bool showDarkModeUnderline;

  const PisBaseHeader({
    super.key,
    required this.title,
    this.extraActions,
    this.backgroundColor,
    this.foregroundColor,
    this.leadingWidth,
    this.showAction = true,
    this.showDarkModeUnderline = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
      foregroundColor: foregroundColor ?? Colors.white70,
      shape: isDarkMode && showDarkModeUnderline
          ? const Border(bottom: BorderSide(color: Colors.white70, width: 1.0))
          : null,
      leading: extraActions != null
          ? Row(mainAxisSize: MainAxisSize.min, children: extraActions!)
          : null,
      leadingWidth: leadingWidth,
      actions: showAction
          ? [
              PopupMenuButton<String>(
                onSelected: (String value) {
                  switch (value) {
                    case 'ログアウト':
                      authService.signOut();
                      context.go('/signin');
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => const [
                  PopupMenuItem<String>(value: 'ログアウト', child: Text('ログアウト')),
                ],
              ),
            ]
          : [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

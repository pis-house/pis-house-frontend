import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pis_house_frontend/infrastructures/auth_service.dart';

class PisBaseHeader extends HookConsumerWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? extraActions;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const PisBaseHeader({
    super.key,
    required this.title,
    this.extraActions,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);

    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
      foregroundColor: foregroundColor ?? Colors.white,
      actions: [
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
        // 画面ごとの差分アクション
        if (extraActions != null) ...extraActions!,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

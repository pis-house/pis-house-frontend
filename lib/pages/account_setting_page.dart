import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pis_house_frontend/components/common/pis_base_header.dart';
import 'package:pis_house_frontend/infrastructures/auth_service.dart';

class AccountSettingPage extends HookConsumerWidget {
  const AccountSettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);

    return Scaffold(
      appBar: PisBaseHeader(title: "アカウント設定"),
      body: ListView(
        children: [
          ListTile(
            title: Text('ユーザー名の変更', style: TextStyle(fontSize: 20.0)),
            subtitle: Text(
              authService.user!.displayName,
              style: TextStyle(fontSize: 15.0),
            ),
            leading: Icon(Icons.person, size: 30),
            trailing: Icon(Icons.chevron_right, size: 30),
            onTap: () {
              context.push('/edit-username');
            },
          ),
        ],
      ),
    );
  }
}

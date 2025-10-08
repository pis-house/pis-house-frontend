import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pis_house_frontend/components/common/pis_base_header.dart';
import 'package:pis_house_frontend/infrastructures/auth_service.dart';
import 'package:pis_house_frontend/repositories/firebases/user_repository.dart';
import 'package:pis_house_frontend/schemas/user_model.dart';

class MemberListPage extends HookConsumerWidget {
  const MemberListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);
    final userRepository = ref.watch(userRepositoryProvider);
    final usersFuture = userRepository.getByTenantId(
      authService.user!.tenantId,
    );

    return FutureBuilder<List<UserModel>>(
      future: usersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('不明なエラーが発生しました')));
        }

        final users = snapshot.data;

        return Scaffold(
          appBar: PisBaseHeader(title: "メンバー一覧"),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return ListView.builder(
                itemCount: users!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      users[index].displayName,
                      style: TextStyle(fontSize: 24.0),
                    ),
                    subtitle: Text(
                      users[index].isAdmin ? '管理者' : 'メンバー',
                      style: TextStyle(fontSize: 14.0),
                    ),
                    leading: Icon(
                      users[index].isAdmin
                          ? Icons.manage_accounts
                          : Icons.person,
                      size: 40,
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

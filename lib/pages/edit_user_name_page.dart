import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pis_house_frontend/components/common/pis_base_header.dart';
import 'package:pis_house_frontend/components/form/user_name_form.dart';
import 'package:pis_house_frontend/infrastructures/auth_service.dart';

class EditUserNamePage extends HookConsumerWidget {
  const EditUserNamePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authProvider = ref.watch(authServiceProvider);

    return Scaffold(
      appBar: PisBaseHeader(
        extraActions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              context.pop();
            },
          ),
        ],
        showAction: false,
        title: "デバイス編集",
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return UserNameForm(
            currentUserName: authProvider.user!.displayName,
            onSave: (newUserName) async {
              await authProvider.changeDisplayName(newDisplayName: newUserName);
              if (!context.mounted) return;
              context.go('/setting');
            },
          );
        },
      ),
    );
  }
}

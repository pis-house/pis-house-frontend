import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pis_house_frontend/components/common/pis_button.dart';
import 'package:pis_house_frontend/components/common/pis_text_form_field.dart';

class UserNameForm extends HookConsumerWidget {
  final String currentUserName;
  final Future<void> Function(String) onSave;

  const UserNameForm({
    super.key,
    required this.currentUserName,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final currentUserNameController = useTextEditingController(
      text: currentUserName,
    );
    final newUserNameController = useTextEditingController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 50),
            PisTextFormField(
              label: "現在のユーザー名",
              controller: currentUserNameController,
              enabled: false,
            ),
            const SizedBox(height: 32),
            PisTextFormField(
              label: "新しいユーザー名",
              controller: newUserNameController,
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'エリア名を入力してください。' : null,
            ),
            const SizedBox(height: 32),
            PisButton(
              label: '保存',
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await onSave(newUserNameController.text);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

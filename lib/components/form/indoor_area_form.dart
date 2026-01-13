import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pis_house_frontend/components/common/pis_button.dart';
import 'package:pis_house_frontend/components/common/pis_text_form_field.dart';
import 'package:pis_house_frontend/schemas/indoor_area_model.dart';

class IndoorAreaForm extends HookConsumerWidget {
  final IndoorAreaModel? initialData;
  final Future<void> Function(String) onSave;

  const IndoorAreaForm({super.key, this.initialData, required this.onSave});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final areaNameController = useTextEditingController(
      text: initialData?.name ?? '',
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 50),
            PisTextFormField(
              label: "エリア名",
              controller: areaNameController,
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'エリア名を入力してください。' : null,
            ),
            const SizedBox(height: 32),
            PisButton(
              label: '保存',
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await onSave(areaNameController.text);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

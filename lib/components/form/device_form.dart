import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pis_house_frontend/components/common/pis_button.dart';
import 'package:pis_house_frontend/components/common/pis_dropdown_button.dart';
import 'package:pis_house_frontend/components/common/pis_text_form_field.dart';
import 'package:pis_house_frontend/schemas/device_model.dart';

class DeviceFormData {
  final String name;
  final String type;

  DeviceFormData({required this.name, required this.type});
}

class DeviceForm extends HookConsumerWidget {
  final DeviceModel? initialData;
  final Future<void> Function(DeviceFormData) onSave;

  const DeviceForm({super.key, this.initialData, required this.onSave});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final deviceNameController = useTextEditingController(
      text: initialData?.name ?? '',
    );

    final deviceTypeSelects = {'light': '照明', 'aircon': 'エアコン'};
    final selectDeviceType = useState(initialData?.type ?? 'light');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 50),
            PisTextFormField(
              label: "デバイス名",
              controller: deviceNameController,
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'デバイス名を入力してください。' : null,
            ),
            const SizedBox(height: 32),

            PisDropdownButton<String>(
              label: '種類',
              value: selectDeviceType.value,
              onChanged: (String? newValue) {
                selectDeviceType.value = newValue ?? 'light';
              },
              items: deviceTypeSelects.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            PisButton(
              label: '保存',
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await onSave(
                    DeviceFormData(
                      name: deviceNameController.text,
                      type: selectDeviceType.value,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

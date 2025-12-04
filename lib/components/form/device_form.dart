import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pis_house_frontend/components/common/pis_button.dart';
import 'package:pis_house_frontend/components/common/pis_dropdown_button.dart';
import 'package:pis_house_frontend/components/common/pis_text_form_field.dart';
import 'package:pis_house_frontend/infrastructures/auth_service.dart';
import 'package:pis_house_frontend/repositories/firebases/setup_device_repository.dart';
import 'package:pis_house_frontend/schemas/device_model.dart';
import 'package:pis_house_frontend/schemas/setup_device_model.dart';

class DeviceFormData {
  final String name;
  final String setupDeviceId;

  DeviceFormData({required this.name, required this.setupDeviceId});
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

    final authProvider = ref.watch(authServiceProvider);
    final setupDevicesAsyncValue = ref
        .watch(setupDeviceRepositoryProvider)
        .getAll(authProvider.user!.integrationId);

    final selectSetupDeviceId = useState(initialData?.setupDeviceId);

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
            FutureBuilder<List<SetupDeviceModel>>(
              future: setupDevicesAsyncValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  return const Text('セットアップデバイスの取得に失敗しました。');
                }

                final setupDevices = snapshot.data!;

                return PisDropdownButton<String>(
                  label: 'セットアップデバイス選択',
                  value: selectSetupDeviceId.value,
                  items: setupDevices
                      .map(
                        (device) => DropdownMenuItem<String>(
                          value: device.id,
                          child: Text(device.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    selectSetupDeviceId.value = value;
                  },
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'セットアップデバイスを選択してください。'
                      : null,
                );
              },
            ),
            const SizedBox(height: 32),

            PisButton(
              label: '保存',
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await onSave(
                    DeviceFormData(
                      name: deviceNameController.text,
                      setupDeviceId: selectSetupDeviceId.value!,
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

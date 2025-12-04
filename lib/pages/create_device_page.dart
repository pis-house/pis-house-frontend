import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pis_house_frontend/components/common/pis_base_header.dart';
import 'package:pis_house_frontend/components/form/device_form.dart';
import 'package:pis_house_frontend/infrastructures/auth_service.dart';
import 'package:pis_house_frontend/repositories/firebases/device_repository.dart';
import 'package:pis_house_frontend/schemas/device_model.dart';

class CreateDevicePage extends HookConsumerWidget {
  final String indoorAreaId;
  const CreateDevicePage({super.key, required this.indoorAreaId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceRepository = ref.watch(deviceRepositoryProvider);
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
        title: "デバイス作成",
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return DeviceForm(
            onSave: (formData) async {
              await deviceRepository.create(
                authProvider.user!.tenantId,
                indoorAreaId,
                DeviceModel.create(
                  name: formData.name,
                  setupDeviceId: formData.setupDeviceId,
                ),
              );
              if (!context.mounted) return;
              context.pop();
            },
          );
        },
      ),
    );
  }
}

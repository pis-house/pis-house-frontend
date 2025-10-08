import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pis_house_frontend/components/common/pis_base_header.dart';
import 'package:pis_house_frontend/components/form/device_form.dart';
import 'package:pis_house_frontend/infrastructures/auth_service.dart';
import 'package:pis_house_frontend/repositories/firebases/device_repository.dart';
import 'package:pis_house_frontend/schemas/device_model.dart';

class EditDevicePage extends HookConsumerWidget {
  final String deviceId;
  final String indoorAreaId;
  const EditDevicePage({
    super.key,
    required this.deviceId,
    required this.indoorAreaId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceRepository = ref.watch(deviceRepositoryProvider);
    final authProvider = ref.watch(authServiceProvider);
    final editDataFuture = deviceRepository
        .firstByTenantIdAndIndoorAreaIdAndDeviceId(
          authProvider.user!.tenantId,
          indoorAreaId,
          deviceId,
        );

    return FutureBuilder<DeviceModel?>(
      future: editDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('不明なエラーが発生しました')));
        }

        final data = snapshot.data;

        if (data == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('指定されたデバイスが存在しません。')),
              );
              context.pop();
            }
          });
          return const Scaffold(body: SizedBox.shrink());
        }

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
              return DeviceForm(
                onSave: (formData) async {
                  await deviceRepository.update(
                    authProvider.user!.tenantId,
                    indoorAreaId,
                    DeviceModel.update(
                      id: data.id,
                      name: formData.name,
                      type: formData.type,
                      airconTemperature: data.airconTemperature,
                      isActive: data.isActive,
                      lightBrightnessPercent: data.lightBrightnessPercent,
                      createdAt: data.createdAt,
                    ),
                  );
                  if (!context.mounted) return;
                  context.pop();
                },
              );
            },
          ),
        );
      },
    );
  }
}

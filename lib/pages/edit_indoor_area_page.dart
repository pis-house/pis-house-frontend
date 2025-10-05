import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pis_house_frontend/components/common/pis_base_header.dart';
import 'package:pis_house_frontend/components/form/indoor_area_form.dart';
import 'package:pis_house_frontend/infrastructures/auth_service.dart';
import 'package:pis_house_frontend/repositories/firebases/indoor_area_repository.dart';
import 'package:pis_house_frontend/schemas/indoor_area_model.dart';

class EditIndoorAreaPage extends HookConsumerWidget {
  final String indoorAreaId;

  const EditIndoorAreaPage({super.key, required this.indoorAreaId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final indoorAreaRepository = ref.watch(indoorAreaRepositoryProvider);
    final authProvider = ref.watch(authServiceProvider);

    final editDataFuture = indoorAreaRepository.firstByTenantIdAndIndoorAreaId(
      authProvider.user!.tenantId,
      indoorAreaId,
    );

    return FutureBuilder<IndoorAreaModel?>(
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
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('指定されたエリアが存在しません。')));
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
                onPressed: () => context.pop(),
              ),
            ],
            showAction: false,
            title: "エリア編集",
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return IndoorAreaForm(
                initialData: data,
                onSave: (newAreaName) async {
                  await indoorAreaRepository.update(
                    authProvider.user!.tenantId,
                    IndoorAreaModel.update(
                      data.id,
                      newAreaName,
                      data.createdAt,
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

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pis_house_frontend/components/card/aircon_card.dart';
import 'package:pis_house_frontend/components/common/pis_base_header.dart';
import 'package:pis_house_frontend/components/common/pis_button.dart';
import 'package:pis_house_frontend/components/card/light_card.dart';
import 'package:pis_house_frontend/components/common/pis_text_button.dart';
import 'package:pis_house_frontend/infrastructures/auth_service.dart';
import 'package:pis_house_frontend/repositories/firebases/device_repository.dart';
import 'package:pis_house_frontend/repositories/firebases/indoor_area_repository.dart';
import 'package:pis_house_frontend/repositories/firebases/setup_device_repository.dart';
import 'package:pis_house_frontend/schemas/indoor_area_model.dart';
import 'package:pis_house_frontend/schemas/setup_device_model.dart';

class OperationalStatusPage extends HookConsumerWidget {
  const OperationalStatusPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authService = ref.watch(authServiceProvider);
    final indoorAreaRepository = ref.watch(indoorAreaRepositoryProvider);
    final indoorSubscriptionModels = indoorAreaRepository
        .getSubscribeByTenantId(
          authService.user!.integrationId,
          authService.user!.tenantId,
        );
    final setupDeviceRepository = ref.watch(setupDeviceRepositoryProvider);
    final deviceRepository = ref.watch(deviceRepositoryProvider);
    final currentIndoorArea = useState<IndoorAreaModel?>(null);

    return StreamBuilder(
      stream: indoorSubscriptionModels,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: PisBaseHeader(title: "稼働状況"),
            body: Center(child: Text("不明なエラーが発生しました")),
          );
        }

        final indoorAreas = snapshot.data ?? [];

        if (indoorAreas.isEmpty) {
          return Scaffold(
            appBar: PisBaseHeader(
              leadingWidth: 150,
              extraActions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    context.push('/create-indoor-area');
                  },
                ),
              ],
              title: "機器状態",
            ),
            body: Center(
              child: Text(
                "エリアが登録されていません。\n画面右上の「＋」ボタンからエリアを追加してください。",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          );
        }

        if (indoorAreas.isNotEmpty && currentIndoorArea.value == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              currentIndoorArea.value = indoorAreas.first.indoorArea;
            }
          });
        }

        if (indoorAreas.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              currentIndoorArea.value = null;
            }
          });
        }

        return DefaultTabController(
          length: indoorAreas.length,
          child: Scaffold(
            appBar: PisBaseHeader(
              leadingWidth: 150,
              showDarkModeUnderline: false,
              extraActions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    context.push('/create-indoor-area');
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    if (currentIndoorArea.value == null ||
                        currentIndoorArea.value!.id.isEmpty) {
                      return;
                    }

                    context.push(
                      '/edit-indoor-area/${currentIndoorArea.value!.id}',
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    if (currentIndoorArea.value == null ||
                        currentIndoorArea.value!.id.isEmpty) {
                      return;
                    }

                    final bool? didConfirm = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('確認'),
                          content: Text(
                            '${currentIndoorArea.value!.name}を本当に削除しますか？\nこの操作は元に戻せません。',
                          ),
                          actions: <Widget>[
                            PisTextButton(
                              label: 'キャンセル',
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            PisTextButton(
                              color: Colors.red,
                              label: '削除',
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                            ),
                          ],
                        );
                      },
                    );
                    if (didConfirm == true) {
                      await indoorAreaRepository.delete(
                        authService.user!.tenantId,
                        currentIndoorArea.value!.id,
                      );
                    }
                  },
                ),
              ],
              title: "機器状態",
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PreferredSize(
                  preferredSize: const Size.fromHeight(48.0),
                  child: Column(
                    children: [
                      Container(
                        color: theme.brightness == Brightness.light
                            ? theme.colorScheme.primary
                            : null,
                        child: TabBar(
                          isScrollable: true,
                          tabAlignment: TabAlignment.start,
                          labelColor: Colors.white,
                          unselectedLabelColor: Colors.white,
                          indicatorColor: Colors.white,
                          dividerColor: Colors.white,
                          tabs: indoorAreas
                              .map((area) => Tab(text: area.indoorArea.name))
                              .toList(),
                          onTap: (index) {
                            currentIndoorArea.value =
                                indoorAreas[index].indoorArea;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: indoorAreas.map((area) {
                      final devicesInArea = area.deviceSubscriptions;
                      if (devicesInArea.isEmpty) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 100.0,
                              ),
                              child: PisButton(
                                label: 'デバイスを追加する',
                                onPressed: () {
                                  context.push(
                                    '/indoor-area/${area.indoorArea.id}/create-device',
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              '${area.indoorArea.name}にはデバイスが登録されていません',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.only(top: 20.0),
                        itemCount: devicesInArea.length + 1,
                        itemBuilder: (context, deviceIndex) {
                          if (deviceIndex == 0) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: PisButton(
                                  width: 200,
                                  onPressed: () {
                                    context.push(
                                      '/indoor-area/${area.indoorArea.id}/create-device',
                                    );
                                  },
                                  label: 'デバイスを追加する',
                                ),
                              ),
                            );
                          }

                          final device = devicesInArea[deviceIndex - 1];

                          return switch (device.setupDevice.deviceType) {
                            'light' => LightCard(
                              title: device.device.name,
                              isActive: device.setupDevice.isActive,
                              brightness: device
                                  .setupDevice
                                  .lightBrightnessPercent
                                  .toDouble(),
                              onIsActiveChanged: (isActive) async {
                                await setupDeviceRepository.update(
                                  authService.user!.integrationId,
                                  SetupDeviceModel.update(
                                    id: device.setupDevice.id,
                                    name: device.setupDevice.name,
                                    gateway: device.setupDevice.gateway,
                                    ip: device.setupDevice.ip,
                                    selfIp: device.setupDevice.selfIp,
                                    ssid: device.setupDevice.ssid,
                                    subnet: device.setupDevice.subnet,
                                    password: device.setupDevice.password,
                                    deviceType: device.setupDevice.deviceType,
                                    isActive: isActive,
                                    airconTemperature:
                                        device.setupDevice.airconTemperature,
                                    lightBrightnessPercent: device
                                        .setupDevice
                                        .lightBrightnessPercent,
                                  ),
                                );
                              },
                              onSliderValueChanged: (brightness) async {
                                await setupDeviceRepository.update(
                                  authService.user!.integrationId,
                                  SetupDeviceModel.update(
                                    id: device.setupDevice.id,
                                    name: device.setupDevice.name,
                                    gateway: device.setupDevice.gateway,
                                    ip: device.setupDevice.ip,
                                    selfIp: device.setupDevice.selfIp,
                                    ssid: device.setupDevice.ssid,
                                    subnet: device.setupDevice.subnet,
                                    password: device.setupDevice.password,
                                    deviceType: device.setupDevice.deviceType,
                                    isActive: device.setupDevice.isActive,
                                    airconTemperature:
                                        device.setupDevice.airconTemperature,
                                    lightBrightnessPercent: brightness.toInt(),
                                  ),
                                );
                              },
                              onEdit: () => context.push(
                                '/indoor-area/${area.indoorArea.id}/edit-device/${device.device.id}',
                              ),
                              onDelete: () async {
                                final bool? didConfirm = await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('確認'),
                                      content: Text(
                                        '${device.device.name}を本当に削除しますか？\nこの操作は元に戻せません。',
                                      ),
                                      actions: <Widget>[
                                        PisTextButton(
                                          label: 'キャンセル',
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                        ),
                                        PisTextButton(
                                          color: Colors.red,
                                          label: '削除',
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                                if (didConfirm == true) {
                                  await deviceRepository.delete(
                                    authService.user!.tenantId,
                                    currentIndoorArea.value!.id,
                                    device.device.id,
                                  );
                                }
                              },
                            ),
                            'aircon' => AirconCard(
                              title: device.device.name,
                              isActive: device.setupDevice.isActive,
                              temperature: device.setupDevice.airconTemperature,
                              onIsActiveChanged: (isActive) async {
                                await setupDeviceRepository.update(
                                  authService.user!.integrationId,
                                  SetupDeviceModel.update(
                                    id: device.setupDevice.id,
                                    name: device.setupDevice.name,
                                    gateway: device.setupDevice.gateway,
                                    ip: device.setupDevice.ip,
                                    selfIp: device.setupDevice.selfIp,
                                    ssid: device.setupDevice.ssid,
                                    subnet: device.setupDevice.subnet,
                                    password: device.setupDevice.password,
                                    deviceType: device.setupDevice.deviceType,
                                    isActive: isActive,
                                    airconTemperature:
                                        device.setupDevice.airconTemperature,
                                    lightBrightnessPercent: device
                                        .setupDevice
                                        .lightBrightnessPercent,
                                  ),
                                );
                              },
                              onSliderValueChanged: (temperature) async {
                                await setupDeviceRepository.update(
                                  authService.user!.integrationId,
                                  SetupDeviceModel.update(
                                    id: device.setupDevice.id,
                                    name: device.setupDevice.name,
                                    gateway: device.setupDevice.gateway,
                                    ip: device.setupDevice.ip,
                                    selfIp: device.setupDevice.selfIp,
                                    ssid: device.setupDevice.ssid,
                                    subnet: device.setupDevice.subnet,
                                    password: device.setupDevice.password,
                                    deviceType: device.setupDevice.deviceType,
                                    isActive: device.setupDevice.isActive,
                                    airconTemperature: temperature,
                                    lightBrightnessPercent: device
                                        .setupDevice
                                        .lightBrightnessPercent,
                                  ),
                                );
                              },
                              onEdit: () => context.push(
                                '/indoor-area/${area.indoorArea.id}/edit-device/${device.device.id}',
                              ),
                              onDelete: () async {
                                final bool? didConfirm = await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('確認'),
                                      content: Text(
                                        '${device.device.name}を本当に削除しますか？\nこの操作は元に戻せません。',
                                      ),
                                      actions: <Widget>[
                                        PisTextButton(
                                          label: 'キャンセル',
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                        ),
                                        PisTextButton(
                                          color: Colors.red,
                                          label: '削除',
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                                if (didConfirm == true) {
                                  await deviceRepository.delete(
                                    authService.user!.tenantId,
                                    currentIndoorArea.value!.id,
                                    device.device.id,
                                  );
                                }
                              },
                            ),
                            _ => null,
                          };
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

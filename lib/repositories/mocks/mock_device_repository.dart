import 'package:pis_house_frontend/repositories/interfaces/device_repository_interface.dart';
import 'package:pis_house_frontend/schemas/device_model.dart';
import 'package:pis_house_frontend/schemas/device_status_model.dart';
import 'package:pis_house_frontend/repositories/mocks/id.dart';

class MockDeviceRepository implements DeviceRepositoryInterface {
  final Map<String, Map<String, DeviceModel>> _store = {
    mockTenantId: {
      mockDeviceId1: DeviceModel(
        id: mockDeviceId1,
        name: 'Sensor1',
        type: 'temperature',
        status: DeviceStatusModel(
          airconTemperature: 22.5,
          isActive: true,
          lightBrightnessPercent: 0,
        ),
        createdAt: DateTime.parse('2025-09-12T06:00:00.000Z'),
        updatedAt: DateTime.parse('2025-09-12T06:00:00.000Z'),
      ),
      mockDeviceId2: DeviceModel(
        id: mockDeviceId2,
        name: 'Light1',
        type: 'light',
        status: DeviceStatusModel(
          airconTemperature: 0,
          isActive: true,
          lightBrightnessPercent: 70,
        ),
        createdAt: DateTime.parse('2025-09-11T08:00:00.000Z'),
        updatedAt: DateTime.parse('2025-09-11T08:00:00.000Z'),
      ),
    },
  };

  @override
  Future<List<DeviceModel>> getByTenantId(String tenantId) async {
    return _store[tenantId]?.values.toList() ?? [];
  }

  @override
  Stream<List<DeviceModel>> getSubscribeByTenantId(String tenantId) {
    return Stream.value(_store[tenantId]?.values.toList() ?? []);
  }

  @override
  Future<DeviceModel?> firstByTenantIdAndDeviceId(
    String tenantId,
    String deviceId,
  ) async {
    return _store[tenantId]?[deviceId];
  }

  @override
  Future<DeviceModel> create(String tenantId, DeviceModel device) async {
    _store.putIfAbsent(tenantId, () => {})[device.id] = device;
    return device;
  }

  @override
  Future<void> delete(String tenantId, String deviceId) async {
    _store[tenantId]?.remove(deviceId);
  }

  @override
  Future<DeviceModel> update(String tenantId, DeviceModel device) async {
    _store[tenantId]?[device.id] = device;
    return device;
  }
}

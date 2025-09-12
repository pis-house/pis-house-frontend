import 'package:pis_house_frontend/schemas/device_model.dart';

abstract class DeviceRepositoryInterface {
  Future<List<DeviceModel>> getByTenantId(String tenantId);
  Stream<List<DeviceModel>> getSubscribeByTenantId(String tenantId);
  Future<DeviceModel?> firstByTenantIdAndDeviceId(
    String tenantId,
    String deviceId,
  );
  Future<DeviceModel> create(String tenantId, DeviceModel device);
  Future<void> delete(String tenantId, String deviceId);
  Future<DeviceModel> update(String tenantId, DeviceModel device);
}

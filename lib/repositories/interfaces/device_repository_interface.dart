import 'package:pis_house_frontend/schemas/device_model.dart';

abstract class DeviceRepositoryInterface {
  Future<List<DeviceModel>> getByTenantId(String tenantId, String indoorAreaId);
  Future<DeviceModel?> firstByTenantIdAndIndoorAreaIdAndDeviceId(
    String tenantId,
    String indoorAreaId,
    String deviceId,
  );
  Future<DeviceModel> create(
    String tenantId,
    String indoorAreaId,
    DeviceModel device,
  );
  Future<void> delete(String tenantId, String indoorAreaId, String deviceId);
  Future<DeviceModel> update(
    String tenantId,
    String indoorAreaId,
    DeviceModel device,
  );
}

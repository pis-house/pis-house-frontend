import 'package:pis_house_frontend/schemas/setup_device_model.dart';

abstract class SetupDeviceRepositoryInterface {
  Future<List<SetupDeviceModel>> getAll(String integrationId);
  Future<SetupDeviceModel> update(
    String integrationId,
    SetupDeviceModel setupDevice,
  );
}

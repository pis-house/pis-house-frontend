import 'package:pis_house_frontend/schemas/device_model.dart';
import 'package:pis_house_frontend/schemas/indoor_area_model.dart';
import 'package:pis_house_frontend/schemas/setup_device_model.dart';

class DeviceSubscriptionModel {
  final DeviceModel device;
  final SetupDeviceModel setupDevice;

  DeviceSubscriptionModel({required this.device, required this.setupDevice});
}

class IndoorAreaSubscriptionModel {
  final List<DeviceSubscriptionModel> deviceSubscriptions;
  final IndoorAreaModel indoorArea;

  IndoorAreaSubscriptionModel({
    required this.deviceSubscriptions,
    required this.indoorArea,
  });
}

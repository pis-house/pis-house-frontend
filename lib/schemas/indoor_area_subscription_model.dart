import 'package:pis_house_frontend/schemas/device_model.dart';
import 'package:pis_house_frontend/schemas/indoor_area_model.dart';

class IndoorAreaSubscriptionModel {
  final List<DeviceModel> devices;
  final IndoorAreaModel indoorArea;

  IndoorAreaSubscriptionModel({
    required this.devices,
    required this.indoorArea,
  });
}

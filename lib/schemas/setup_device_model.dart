import 'package:json_annotation/json_annotation.dart';

part 'setup_device_model.g.dart';

@JsonSerializable()
class SetupDeviceModel {
  final String id;
  final String name;
  final String gateway;
  final String ip;
  @JsonKey(name: 'self_ip')
  final String selfIp;
  final String ssid;
  final String subnet;
  final String password;
  @JsonKey(name: 'device_type')
  final String deviceType;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'aircon_temperature')
  final double airconTemperature;
  @JsonKey(name: 'light_brightness_percent')
  final int lightBrightnessPercent;

  SetupDeviceModel({
    required this.id,
    required this.name,
    required this.gateway,
    required this.ip,
    required this.selfIp,
    required this.ssid,
    required this.subnet,
    required this.password,
    required this.deviceType,
    required this.isActive,
    required this.airconTemperature,
    required this.lightBrightnessPercent,
  });

  factory SetupDeviceModel.update({
    required String id,
    required String name,
    required String gateway,
    required String ip,
    required String selfIp,
    required String ssid,
    required String subnet,
    required String password,
    required String deviceType,
    required bool isActive,
    required double airconTemperature,
    required int lightBrightnessPercent,
  }) {
    return SetupDeviceModel(
      id: id,
      name: name,
      gateway: gateway,
      ip: ip,
      selfIp: selfIp,
      ssid: ssid,
      subnet: subnet,
      password: password,
      deviceType: deviceType,
      isActive: isActive,
      airconTemperature: airconTemperature,
      lightBrightnessPercent: lightBrightnessPercent,
    );
  }

  factory SetupDeviceModel.fromJson(Map<String, dynamic> json) =>
      _$SetupDeviceModelFromJson(json);

  Map<String, dynamic> toJson() => _$SetupDeviceModelToJson(this);
}

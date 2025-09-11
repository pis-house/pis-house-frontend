import 'package:json_annotation/json_annotation.dart';

part 'device_status_model.g.dart';


@JsonSerializable()
class DeviceStatusModel {
  @JsonKey(name: 'aircon_temperature')
  final double airconTemperature;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'light_brightness_percent')
  final int lightBrightnessPercent;

  DeviceStatusModel({
    required this.airconTemperature,
    required this.isActive,
    required this.lightBrightnessPercent,
  });

  factory DeviceStatusModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceStatusModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceStatusModelToJson(this);
}
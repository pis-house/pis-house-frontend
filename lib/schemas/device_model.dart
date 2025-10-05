import 'package:json_annotation/json_annotation.dart';
import 'package:ulid/ulid.dart';

part 'device_model.g.dart';

@JsonSerializable()
class DeviceModel {
  final String id;
  @JsonKey(name: 'aircon_temperature')
  final double airconTemperature;
  @JsonKey(name: 'is_active')
  final bool isActive;
  @JsonKey(name: 'light_brightness_percent')
  final int lightBrightnessPercent;
  final String name;
  final String type;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  DeviceModel({
    required this.id,
    required this.airconTemperature,
    required this.isActive,
    required this.lightBrightnessPercent,
    required this.name,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeviceModel.create({
    required String name,
    required String type,
    required double airconTemperature,
    required bool isActive,
    required int lightBrightnessPercent,
  }) {
    final now = DateTime.now();
    final id = Ulid().toString();
    return DeviceModel(
      id: id,
      name: name,
      type: type,
      airconTemperature: airconTemperature,
      isActive: isActive,
      lightBrightnessPercent: lightBrightnessPercent,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory DeviceModel.update({
    required String id,
    required String name,
    required String type,
    required DateTime createdAt,
    required double airconTemperature,
    required bool isActive,
    required int lightBrightnessPercent,
  }) {
    final now = DateTime.now();
    return DeviceModel(
      id: id,
      name: name,
      type: type,
      airconTemperature: airconTemperature,
      isActive: isActive,
      lightBrightnessPercent: lightBrightnessPercent,
      createdAt: createdAt,
      updatedAt: now,
    );
  }

  factory DeviceModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceModelToJson(this);
}

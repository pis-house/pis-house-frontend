import 'package:json_annotation/json_annotation.dart';
import 'package:ulid/ulid.dart';

part 'device_model.g.dart';

@JsonSerializable()
class DeviceModel {
  final String id;
  final String name;
  @JsonKey(name: 'setup_device_id')
  final String setupDeviceId;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  DeviceModel({
    required this.id,
    required this.name,
    required this.setupDeviceId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeviceModel.create({
    required String name,
    required String setupDeviceId,
  }) {
    final now = DateTime.now();
    final id = Ulid().toString();
    return DeviceModel(
      id: id,
      name: name,
      setupDeviceId: setupDeviceId,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory DeviceModel.update({
    required String id,
    required String name,
    required String setupDeviceId,
    required DateTime createdAt,
  }) {
    final now = DateTime.now();
    return DeviceModel(
      id: id,
      name: name,
      setupDeviceId: setupDeviceId,
      createdAt: createdAt,
      updatedAt: now,
    );
  }

  factory DeviceModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceModelToJson(this);
}

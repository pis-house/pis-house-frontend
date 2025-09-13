import 'package:json_annotation/json_annotation.dart';
import 'package:pis_house_frontend/schemas/device_status_model.dart';
import 'package:ulid/ulid.dart';

part 'device_model.g.dart';

@JsonSerializable()
class DeviceModel {
  final String id;
  final String name;
  final DeviceStatusModel status;
  final String type;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  DeviceModel({
    required this.id,
    required this.status,
    required this.name,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeviceModel.create({
    required String name,
    required String type,
    required DeviceStatusModel status,
  }) {
    final now = DateTime.now();
    final id = Ulid().toString();
    return DeviceModel(
      id: id,
      name: name,
      type: type,
      status: status,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory DeviceModel.update({
    required String id,
    required String name,
    required String type,
    required DeviceStatusModel status,
    required DateTime createdAt,
  }) {
    final now = DateTime.now();
    return DeviceModel(
      id: id,
      status: status,
      name: name,
      type: type,
      createdAt: createdAt,
      updatedAt: now,
    );
  }

  factory DeviceModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceModelToJson(this);
}

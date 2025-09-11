import 'package:json_annotation/json_annotation.dart';
import 'package:pis_house_frontend/schemas/device_status_model.dart';

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

  factory DeviceModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceModelFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceModelToJson(this);
}
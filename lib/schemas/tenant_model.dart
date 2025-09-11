import 'package:json_annotation/json_annotation.dart';
import 'package:pis_house_frontend/schemas/device_model.dart';
import 'package:pis_house_frontend/schemas/notification_model.dart';
import 'package:pis_house_frontend/schemas/user_model.dart';

part 'tenant_model.g.dart';


@JsonSerializable()
class TenantModel {
  final String id;
  final Map<String, DeviceModel> devices;
  final String name;
  final NotificationModel notification;
  final Map<String, UserModel> users;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  TenantModel({
    required this.id,
    required this.devices,
    required this.name,
    required this.notification,
    required this.users,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TenantModel.fromJson(Map<String, dynamic> json) =>
      _$TenantModelFromJson(json);

  Map<String, dynamic> toJson() => _$TenantModelToJson(this);
}
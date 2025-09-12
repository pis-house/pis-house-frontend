import 'package:json_annotation/json_annotation.dart';
import 'package:pis_house_frontend/schemas/device_model.dart';
import 'package:pis_house_frontend/schemas/notification_model.dart';
import 'package:pis_house_frontend/schemas/user_model.dart';
import 'package:uuid/uuid.dart';

part 'tenant_model.g.dart';

@JsonSerializable()
class TenantModel {
  final String id;
  final String name;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  TenantModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TenantModel.create({required String name}) {
    final now = DateTime.now();
    final uuid = const Uuid().v7();
    return TenantModel(id: uuid, name: name, createdAt: now, updatedAt: now);
  }

  factory TenantModel.fromJson(Map<String, dynamic> json) =>
      _$TenantModelFromJson(json);

  Map<String, dynamic> toJson() => _$TenantModelToJson(this);
}

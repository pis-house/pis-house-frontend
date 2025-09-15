import 'package:json_annotation/json_annotation.dart';
import 'package:ulid/ulid.dart';

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
    final id = Ulid().toString();
    return TenantModel(id: id, name: name, createdAt: now, updatedAt: now);
  }

  factory TenantModel.update({
    required String id,
    required String name,
    required DateTime createdAt,
  }) {
    final now = DateTime.now();
    return TenantModel(
      id: id,
      name: name,
      createdAt: createdAt,
      updatedAt: now,
    );
  }

  factory TenantModel.fromJson(Map<String, dynamic> json) =>
      _$TenantModelFromJson(json);

  Map<String, dynamic> toJson() => _$TenantModelToJson(this);
}

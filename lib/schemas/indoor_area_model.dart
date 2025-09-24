import 'package:json_annotation/json_annotation.dart';
import 'package:pis_house_frontend/schemas/device_model.dart';
import 'package:ulid/ulid.dart';

part 'indoor_area_model.g.dart';

@JsonSerializable()
class IndoorAreaModel {
  final String id;
  final String name;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  IndoorAreaModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory IndoorAreaModel.create(String name) {
    final now = DateTime.now();
    final id = Ulid().toString();

    return IndoorAreaModel(id: id, name: name, createdAt: now, updatedAt: now);
  }

  factory IndoorAreaModel.update(String id, String name, DateTime createdAt) {
    final now = DateTime.now();

    return IndoorAreaModel(
      id: id,
      name: name,
      createdAt: createdAt,
      updatedAt: now,
    );
  }

  factory IndoorAreaModel.fromJson(Map<String, dynamic> json) =>
      _$IndoorAreaModelFromJson(json);

  Map<String, dynamic> toJson() => _$IndoorAreaModelToJson(this);
}

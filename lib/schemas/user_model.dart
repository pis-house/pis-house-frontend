import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';


@JsonSerializable()
class UserModel {
  final String id;
  @JsonKey(name: 'is_admin')
  final bool isAdmin;
  final String name;
  @JsonKey(name: 'preferred_aircon_temperature')
  final double preferredAirconTemperature;
  @JsonKey(name: 'preferred_light_brightness_percent')
  final int preferredLightBrightnessPercent;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.isAdmin,
    required this.name,
    required this.preferredAirconTemperature,
    required this.preferredLightBrightnessPercent,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
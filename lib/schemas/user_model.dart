import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  @JsonKey(name: 'display_name')
  final String displayName;
  @JsonKey(name: 'is_admin')
  final bool isAdmin;
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
    required this.displayName,
    required this.isAdmin,
    required this.preferredAirconTemperature,
    required this.preferredLightBrightnessPercent,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.create({
    required String id,
    required String displayName,
    required bool isAdmin,
    required double preferredAirconTemperature,
    required int preferredLightBrightnessPercent,
  }) {
    final now = DateTime.now();
    return UserModel(
      id: id,
      displayName: displayName,
      isAdmin: isAdmin,
      preferredAirconTemperature: preferredAirconTemperature,
      preferredLightBrightnessPercent: preferredLightBrightnessPercent,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory UserModel.update({
    required String id,
    required String displayName,
    required bool isAdmin,
    required double preferredAirconTemperature,
    required int preferredLightBrightnessPercent,
    required DateTime createdAt,
  }) {
    final now = DateTime.now();
    return UserModel(
      id: id,
      displayName: displayName,
      isAdmin: isAdmin,
      preferredAirconTemperature: preferredAirconTemperature,
      preferredLightBrightnessPercent: preferredLightBrightnessPercent,
      createdAt: createdAt,
      updatedAt: now,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

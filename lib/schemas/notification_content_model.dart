import 'package:json_annotation/json_annotation.dart';

part 'notification_content_model.g.dart';


@JsonSerializable()
class NotificationContentModel {
  final String id;
  final String title;
  final String type;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  NotificationContentModel({
    required this.id,
    required this.title,
    required this.type,
    required this.createdAt,
  });

  factory NotificationContentModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationContentModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationContentModelToJson(this);
}
import 'package:json_annotation/json_annotation.dart';
import 'package:pis_house_frontend/schemas/notification_content_model.dart';

part 'notification_model.g.dart';


@JsonSerializable()
class NotificationModel {
  final List<NotificationContentModel> contents;
  @JsonKey(name: 'last_read_at')
  final DateTime lastReadAt;

  NotificationModel({
    required this.contents,
    required this.lastReadAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
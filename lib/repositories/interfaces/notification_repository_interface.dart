import 'package:pis_house_frontend/schemas/notification_model.dart';

abstract class NotificationRepositoryInterface {
  Future<NotificationModel?> firstByTenantId(String tenantId);
}

import 'package:pis_house_frontend/schemas/notification_model.dart';

abstract class NotificationRepositoryInterface {
  Stream<NotificationModel?> firstSubscribeByTenantId(String tenantId);
}

import 'package:pis_house_frontend/repositories/interfaces/notification_repository_interface.dart';
import 'package:pis_house_frontend/schemas/notification_model.dart';
import 'package:pis_house_frontend/schemas/notification_content_model.dart';
import 'package:pis_house_frontend/repositories/mocks/id.dart';

class MockNotificationRepository implements NotificationRepositoryInterface {
  final Map<String, NotificationModel> _store = {
    mockTenantId: NotificationModel(
      lastReadAt: DateTime.parse('2025-09-12T05:00:00.000Z'),
      contents: [
        NotificationContentModel(
          id: mockNotificationContentId1,
          title: '帰宅',
          type: 'return_home',
          createdAt: DateTime.parse('2025-09-11T08:00:00.000Z'),
        ),
        NotificationContentModel(
          id: mockNotificationContentId2,
          title: '出勤',
          type: 'leave_home',
          createdAt: DateTime.parse('2025-09-11T08:00:00.000Z'),
        ),
      ],
    ),
  };

  @override
  Stream<NotificationModel?> firstSubscribeByTenantId(String tenantId) {
    return Stream.value(_store[tenantId]);
  }

  Future<NotificationModel> create(
    String tenantId,
    NotificationModel notification,
  ) async {
    _store[tenantId] = notification;
    return notification;
  }

  Future<NotificationModel> update(
    String tenantId,
    NotificationModel notification,
  ) async {
    _store[tenantId] = notification;
    return notification;
  }

  Future<void> delete(String tenantId) async {
    _store.remove(tenantId);
  }
}

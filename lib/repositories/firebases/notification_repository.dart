import 'package:firebase_database/firebase_database.dart';
import 'package:pis_house_frontend/repositories/interfaces/notification_repository_interface.dart';
import 'package:pis_house_frontend/schemas/notification_model.dart';

class NotificationRepository implements NotificationRepositoryInterface {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  DatabaseReference _tenantRef(String tenantId) {
    return _db.ref('notifications/$tenantId');
  }

  @override
  Future<NotificationModel?> firstByTenantId(String tenantId) async {
    final snapshot = await _tenantRef(tenantId).child('node').get();
    if (!snapshot.exists) return null;

    final data = Map<String, dynamic>.from(snapshot.value as Map);
    return NotificationModel.fromJson(data);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pis_house_frontend/repositories/interfaces/notification_repository_interface.dart';
import 'package:pis_house_frontend/schemas/notification_model.dart';

class NotificationRepository implements NotificationRepositoryInterface {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DocumentReference _tenantRef(String tenantId) {
    return _db
        .collection("tenants")
        .doc(tenantId)
        .collection("notification")
        .doc("node");
  }

  @override
  Stream<NotificationModel?> firstSubscribeByTenantId(String tenantId) {
    return _tenantRef(tenantId).snapshots().map((doc) {
      if (!doc.exists) {
        return null;
      }
      final data = Map<String, dynamic>.from(doc.data() as Map);
      return NotificationModel.fromJson(data);
    });
  }
}

final notificationRepositoryProvider =
    Provider<NotificationRepositoryInterface>(
      (ref) => NotificationRepository(),
    );

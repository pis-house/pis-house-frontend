import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pis_house_frontend/repositories/interfaces/notification_repository_interface.dart';
import 'package:pis_house_frontend/schemas/notification_model.dart';

class NotificationRepository implements NotificationRepositoryInterface {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference _rootRef(String tenantId) {
    return _db.collection("tenants").doc(tenantId).collection("notifications");
  }

  @override
  Future<List<NotificationModel>> getByTenantId(String tenantId) async {
    final snapshot = await _rootRef(tenantId).get();
    if (snapshot.size == 0) return [];

    return snapshot.docs.map((entry) {
      final deviceData = Map<String, dynamic>.from(entry.data() as Map);
      return NotificationModel.fromJson(deviceData);
    }).toList();
  }
}

final notificationRepositoryProvider =
    Provider<NotificationRepositoryInterface>(
      (ref) => NotificationRepository(),
    );

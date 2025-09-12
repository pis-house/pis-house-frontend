import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pis_house_frontend/repositories/interfaces/device_repository_interface.dart';
import 'package:pis_house_frontend/schemas/device_model.dart';

class DeviceRepository implements DeviceRepositoryInterface {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference _rootRef(String tenantId) {
    return _db.collection('devices').doc(tenantId).collection('nodes');
  }

  @override
  Future<List<DeviceModel>> getByTenantId(String tenantId) async {
    final snapshot = await _rootRef(tenantId).get();
    if (snapshot.size == 0) return [];

    return snapshot.docs.map((entry) {
      final deviceData = Map<String, dynamic>.from(entry.data() as Map);
      return DeviceModel.fromJson(deviceData);
    }).toList();
  }

  @override
  Stream<List<DeviceModel>> getSubscribeByTenantId(String tenantId) {
    return _rootRef(tenantId).snapshots().map((querySnapshot) {
      if (querySnapshot.size == 0) return [];

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return DeviceModel.fromJson(data as Map<String, dynamic>);
      }).toList();
    });
  }

  @override
  Future<DeviceModel?> firstByTenantIdAndDeviceId(
    String tenantId,
    String deviceId,
  ) async {
    final snapshot = await _rootRef(tenantId).doc(deviceId).get();
    if (!snapshot.exists) return null;
    return DeviceModel.fromJson(
      Map<String, dynamic>.from(snapshot.data() as Map),
    );
  }

  @override
  Future<DeviceModel> create(String tenantId, DeviceModel device) async {
    final json = device.toJson();
    final ref = _rootRef(tenantId).doc(device.id);
    await ref.set(json);
    final snapshot = await ref.get();
    if (!snapshot.exists) {
      throw Exception('Failed to read device after create');
    }
    return DeviceModel.fromJson(snapshot.data() as Map<String, dynamic>);
  }

  @override
  Future<void> delete(String tenantId, String deviceId) async {
    final ref = _rootRef(tenantId).doc(deviceId);
    await ref.delete();
    var snapshot = await ref.get();
    if (snapshot.exists) {
      throw Exception('Failed to read device after delete');
    }
  }

  @override
  Future<DeviceModel> update(String tenantId, DeviceModel device) async {
    final ref = _rootRef(tenantId).doc(device.id);
    await ref.update(device.toJson());
    final snapshot = await ref.get();
    if (!snapshot.exists) {
      throw Exception('Failed to read device after update');
    }
    return device;
  }
}

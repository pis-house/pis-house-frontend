import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pis_house_frontend/repositories/interfaces/device_repository_interface.dart';
import 'package:pis_house_frontend/schemas/device_model.dart';

class DeviceRepository implements DeviceRepositoryInterface {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference _rootRef(String tenantId, String indoorAreaId) {
    return _db
        .collection("tenants")
        .doc(tenantId)
        .collection("indoor_areas")
        .doc(indoorAreaId)
        .collection("devices");
  }

  @override
  Future<List<DeviceModel>> getByTenantId(
    String tenantId,
    String indoorAreaId,
  ) async {
    final snapshot = await _rootRef(tenantId, indoorAreaId).get();
    if (snapshot.size == 0) return [];

    return snapshot.docs.map((entry) {
      final deviceData = Map<String, dynamic>.from(entry.data() as Map);
      return DeviceModel.fromJson(deviceData);
    }).toList();
  }

  @override
  Future<DeviceModel?> firstByTenantIdAndDeviceId(
    String tenantId,
    String indoorAreaId,
    String deviceId,
  ) async {
    final snapshot = await _rootRef(tenantId, indoorAreaId).doc(deviceId).get();
    if (!snapshot.exists) return null;
    return DeviceModel.fromJson(
      Map<String, dynamic>.from(snapshot.data() as Map),
    );
  }

  @override
  Future<DeviceModel> create(
    String tenantId,
    String indoorAreaId,
    DeviceModel device,
  ) async {
    final json = device.toJson();
    final ref = _rootRef(tenantId, indoorAreaId).doc(device.id);
    await ref.set(json);
    final snapshot = await ref.get();
    if (!snapshot.exists) {
      throw Exception('Failed to read device after create');
    }
    return DeviceModel.fromJson(snapshot.data() as Map<String, dynamic>);
  }

  @override
  Future<void> delete(
    String tenantId,
    String indoorAreaId,
    String deviceId,
  ) async {
    final ref = _rootRef(tenantId, indoorAreaId).doc(deviceId);
    await ref.delete();
    var snapshot = await ref.get();
    if (snapshot.exists) {
      throw Exception('Failed to read device after delete');
    }
  }

  @override
  Future<DeviceModel> update(
    String tenantId,
    String indoorAreaId,
    DeviceModel device,
  ) async {
    final ref = _rootRef(tenantId, indoorAreaId).doc(device.id);
    await ref.update(device.toJson());
    final snapshot = await ref.get();
    if (!snapshot.exists) {
      throw Exception('Failed to read device after update');
    }
    return DeviceModel.fromJson(snapshot.data() as Map<String, dynamic>);
  }
}

final deviceRepositoryProvider = Provider<DeviceRepositoryInterface>(
  (ref) => DeviceRepository(),
);

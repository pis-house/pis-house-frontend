import 'package:firebase_database/firebase_database.dart';
import 'package:pis_house_frontend/repositories/interfaces/device_repository_interface.dart';
import 'package:pis_house_frontend/schemas/device_model.dart';

class DeviceRepository implements DeviceRepositoryInterface {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  DatabaseReference _tenantRef(String tenantId) {
    return _db.ref('devices/$tenantId');
  }

  @override
  Future<List<DeviceModel>> getByTenantId(String tenantId) async {
    final snapshot = await _tenantRef(tenantId).get();
    if (!snapshot.exists) return [];

    final map = Map<String, dynamic>.from(snapshot.value as Map);
    return map.entries.map((entry) {
      final deviceData = Map<String, dynamic>.from(entry.value['node'] as Map);
      return DeviceModel.fromJson(deviceData);
    }).toList();
  }

  @override
  Stream<List<DeviceModel>> getSubscribeByTenantId(String tenantId) {
    return _tenantRef(tenantId).onValue.map((event) {
      if (event.snapshot.value == null) return [];

      final map = Map<String, dynamic>.from(event.snapshot.value as Map);
      return map.entries.map((entry) {
        final deviceData = Map<String, dynamic>.from(
          entry.value['node'] as Map,
        );
        return DeviceModel.fromJson(deviceData);
      }).toList();
    });
  }

  @override
  Future<DeviceModel?> firstByTenantIdAndDeviceId(
    String tenantId,
    String deviceId,
  ) async {
    final snapshot = await _tenantRef(
      tenantId,
    ).child(deviceId).child('node').get();
    if (!snapshot.exists) return null;
    return DeviceModel.fromJson(
      Map<String, dynamic>.from(snapshot.value as Map),
    );
  }

  @override
  Future<DeviceModel> create(String tenantId, DeviceModel device) async {
    final json = device.toJson();
    final ref = _tenantRef(tenantId).child(device.id).child('node');
    await ref.set(json);
    final snapshot = await ref.get();
    if (!snapshot.exists) {
      throw Exception('Failed to read device after create');
    }
    return DeviceModel.fromJson(snapshot.value as Map<String, dynamic>);
  }

  @override
  Future<void> delete(String tenantId, String deviceId) async {
    final ref = _tenantRef(tenantId).child(deviceId);
    await ref.remove();
    var snapshot = await ref.get();
    if (snapshot.exists) {
      throw Exception('Failed to read device after delete');
    }
  }

  @override
  Future<DeviceModel> update(String tenantId, DeviceModel device) async {
    final ref = _tenantRef(tenantId).child(device.id).child('node');
    await ref.set(device.toJson());
    final snapshot = await ref.get();
    if (!snapshot.exists) {
      throw Exception('Failed to read device after update');
    }
    return device;
  }
}

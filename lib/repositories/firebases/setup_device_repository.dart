import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pis_house_frontend/repositories/interfaces/setup_device_repository_interface.dart';
import 'package:pis_house_frontend/schemas/setup_device_model.dart';

class SetupDeviceRepository implements SetupDeviceRepositoryInterface {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference _setupRef(String integrationId) {
    return _db.collection("setup").doc(integrationId).collection("devices");
  }

  @override
  Future<List<SetupDeviceModel>> getAll(String integrationId) async {
    final snapshot = await _setupRef(integrationId).get();
    if (snapshot.size == 0) return [];

    return snapshot.docs.map((entry) {
      final setupDeviceData = Map<String, dynamic>.from(entry.data() as Map);
      return SetupDeviceModel.fromJson(setupDeviceData);
    }).toList();
  }

  @override
  Future<SetupDeviceModel> update(
    String integrationId,
    SetupDeviceModel setupDevice,
  ) async {
    final json = setupDevice.toJson();
    final ref = _setupRef(integrationId).doc(setupDevice.id);
    await ref.set(json);
    final snapshot = await ref.get();
    if (!snapshot.exists) {
      throw Exception('Failed to read setup device after update');
    }
    return SetupDeviceModel.fromJson(snapshot.data() as Map<String, dynamic>);
  }
}

final setupDeviceRepositoryProvider = Provider<SetupDeviceRepositoryInterface>(
  (ref) => SetupDeviceRepository(),
);

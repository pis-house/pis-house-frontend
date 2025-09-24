import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pis_house_frontend/repositories/interfaces/indoor_area_repository_interface.dart';
import 'package:pis_house_frontend/schemas/indoor_area_model.dart';

class IndoorAreaRepository implements IndoorAreaRepositoryInterface {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference _rootRef(String tenantId) {
    return _db.collection("tenants").doc(tenantId).collection("indoor_areas");
  }

  @override
  Future<IndoorAreaModel?> firstByTenantIdAndIndoorAreaId(
    String tenantId,
    String indoorAreaId,
  ) async {
    final snapshot = await _rootRef(tenantId).doc(indoorAreaId).get();
    if (!snapshot.exists) return null;
    return IndoorAreaModel.fromJson(snapshot.data() as Map<String, dynamic>);
  }

  @override
  Stream<List<IndoorAreaModel>> getSubscribeByTenantIdAndIndoorAreaId(
    String tenantId,
  ) {
    return _rootRef(tenantId).snapshots().map((querySnapshot) {
      if (querySnapshot.size == 0) return [];

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return IndoorAreaModel.fromJson(data as Map<String, dynamic>);
      }).toList();
    });
  }

  @override
  Future<IndoorAreaModel> create(
    String tenantId,
    IndoorAreaModel indoorArea,
  ) async {
    final json = indoorArea.toJson();
    final ref = _rootRef(tenantId).doc(indoorArea.id);
    await ref.set(json);
    final snapshot = await ref.get();
    if (!snapshot.exists) {
      throw Exception('Failed to read indoorArea after create');
    }
    return IndoorAreaModel.fromJson(snapshot.data() as Map<String, dynamic>);
  }

  @override
  Future<void> delete(String tenantId, String indoorAreaId) async {
    final ref = _rootRef(tenantId).doc(indoorAreaId);
    await ref.delete();
    var snapshot = await ref.get();
    if (snapshot.exists) {
      throw Exception('Failed to read indoorArea after delete');
    }
  }

  @override
  Future<IndoorAreaModel> update(
    String tenantId,
    IndoorAreaModel indoorArea,
  ) async {
    final ref = _rootRef(tenantId).doc(indoorArea.id);
    await ref.update(indoorArea.toJson());
    final snapshot = await ref.get();
    if (!snapshot.exists) {
      throw Exception('Failed to read indoorArea after update');
    }
    return IndoorAreaModel.fromJson(snapshot.data() as Map<String, dynamic>);
  }
}

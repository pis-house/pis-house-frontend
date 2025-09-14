import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pis_house_frontend/repositories/interfaces/tenant_repository_interface.dart';
import 'package:pis_house_frontend/schemas/tenant_model.dart';

class TenantRepository implements TenantRepositoryInterface {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference _rootRef() {
    return _db.collection('tenants');
  }

  @override
  Future<TenantModel?> firstByTenantId(String tenantId) async {
    final snapshot = await _rootRef().doc(tenantId).get();
    if (!snapshot.exists) return null;

    final data = Map<String, dynamic>.from(snapshot.data() as Map);
    return TenantModel.fromJson(data);
  }

  @override
  Future<TenantModel?> firstByTenantName(String tenantName) async {
    final querySnapshot = await _rootRef()
        .where('name', isEqualTo: tenantName)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) return null;

    final data = Map<String, dynamic>.from(
      querySnapshot.docs.first.data() as Map,
    );
    return TenantModel.fromJson(data);
  }

  @override
  Future<TenantModel> create(TenantModel tenant) async {
    final json = tenant.toJson();
    final ref = _rootRef().doc(tenant.id);
    await ref.set(json);
    final snapshot = await ref.get();
    if (!snapshot.exists) {
      throw Exception('Failed to read tenant after create');
    }
    return TenantModel.fromJson(snapshot.data() as Map<String, dynamic>);
  }

  @override
  Future<void> delete(String tenantId) async {
    final ref = _rootRef().doc(tenantId);
    await ref.delete();
    final snapshot = await ref.get();
    if (snapshot.exists) {
      throw Exception('Failed to read tenant after delete');
    }
  }

  @override
  Future<TenantModel> update(TenantModel tenant) async {
    final ref = _rootRef().doc(tenant.id);
    await ref.update(tenant.toJson());
    final snapshot = await ref.get();
    if (!snapshot.exists) {
      throw Exception('Failed to read tenant after update');
    }
    return TenantModel.fromJson(snapshot.data() as Map<String, dynamic>);
  }
}

final tenantRepositoryProvider = Provider<TenantRepositoryInterface>(
  (ref) => TenantRepository(),
);

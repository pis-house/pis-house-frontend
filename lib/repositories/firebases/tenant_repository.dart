import 'package:firebase_database/firebase_database.dart';
import 'package:pis_house_frontend/repositories/interfaces/tenant_repository_interface.dart';
import 'package:pis_house_frontend/schemas/tenant_model.dart';

class TenantRepository implements TenantRepositoryInterface {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  DatabaseReference _tenantRef(String tenantId) {
    return _db.ref('tenants/$tenantId');
  }

  @override
  Future<TenantModel?> firstByTenantId(String tenantId) async {
    final snapshot = await _tenantRef(tenantId).get();
    if (!snapshot.exists) return null;

    final data = Map<String, dynamic>.from(snapshot.value as Map);
    return TenantModel.fromJson(data);
  }

  @override
  Future<TenantModel> create(TenantModel tenant) async {
    final json = tenant.toJson();
    final ref = _tenantRef(tenant.id).child('node');
    await ref.set(json);
    final snapshot = await ref.get();
    if (!snapshot.exists) {
      throw Exception('Failed to read tenant after create');
    }
    return TenantModel.fromJson(snapshot.value as Map<String, dynamic>);
  }

  @override
  Future<void> delete(String tenantId) async {
    final ref = _tenantRef(tenantId);
    await ref.remove();
    final snapshot = await ref.get();
    if (snapshot.exists) {
      throw Exception('Failed to read tenant after delete');
    }
  }

  @override
  Future<TenantModel> update(TenantModel tenant) async {
    final ref = _tenantRef(tenant.id).child('node');
    await ref.set(tenant.toJson());
    final snapshot = await ref.get();
    if (!snapshot.exists) {
      throw Exception('Failed to read tenant after update');
    }
    return TenantModel.fromJson(snapshot.value as Map<String, dynamic>);
  }
}

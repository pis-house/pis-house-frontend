import 'package:firebase_database/firebase_database.dart';
import 'package:pis_house_frontend/repositories/interfaces/user_repository_interface.dart';
import 'package:pis_house_frontend/schemas/user_model.dart';

class UserRepository implements UserRepositoryInterface {
  final FirebaseDatabase _db = FirebaseDatabase.instance;

  DatabaseReference _tenantRef(String tenantId) {
    return _db.ref('users/$tenantId');
  }

  @override
  Future<List<UserModel>> getByTenantId(String tenantId) async {
    final snapshot = await _tenantRef(tenantId).get();
    if (!snapshot.exists) return [];

    final map = Map<String, dynamic>.from(snapshot.value as Map);
    return map.entries.map((entry) {
      return UserModel.fromJson(
        Map<String, dynamic>.from(entry.value['node'] as Map),
      );
    }).toList();
  }

  @override
  Future<UserModel?> firstByTenantIdAndUserId(
    String tenantId,
    String userId,
  ) async {
    final snapshot = await _tenantRef(
      tenantId,
    ).child(userId).child('node').get();
    if (!snapshot.exists) return null;
    return UserModel.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
  }

  @override
  Future<UserModel> create(String tenantId, UserModel user) async {
    final json = user.toJson();
    final ref = _tenantRef(tenantId).child(user.id).child('node');
    await ref.set(json);
    final snapshot = await ref.get();
    if (!snapshot.exists) {
      throw Exception('Failed to read user after create');
    }
    return UserModel.fromJson(snapshot.value as Map<String, dynamic>);
  }

  @override
  Future<void> delete(String tenantId, String userId) async {
    final ref = _tenantRef(tenantId).child(userId);
    await ref.remove();
    final snapshot = await ref.get();
    if (snapshot.exists) {
      throw Exception('Failed to read user after delete');
    }
  }

  @override
  Future<UserModel> update(String tenantId, UserModel user) async {
    final ref = _tenantRef(tenantId).child(user.id).child('node');
    await ref.set(user.toJson());
    final snapshot = await ref.get();
    if (!snapshot.exists) {
      throw Exception('Failed to read user after update');
    }
    return UserModel.fromJson(snapshot.value as Map<String, dynamic>);
    ;
  }
}

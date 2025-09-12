import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pis_house_frontend/repositories/interfaces/user_repository_interface.dart';
import 'package:pis_house_frontend/schemas/user_model.dart';

class UserRepository implements UserRepositoryInterface {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference _rootRef(String tenantId) {
    return _db.collection('users').doc(tenantId).collection('nodes');
  }

  @override
  Future<List<UserModel>> getByTenantId(String tenantId) async {
    final snapshot = await _rootRef(tenantId).get();
    if (snapshot.size == 0) return [];

    return snapshot.docs.map((entry) {
      return UserModel.fromJson(Map<String, dynamic>.from(entry.data() as Map));
    }).toList();
  }

  @override
  Future<UserModel?> firstByTenantIdAndUserId(
    String tenantId,
    String userId,
  ) async {
    final snapshot = await _rootRef(tenantId).doc(userId).get();
    if (!snapshot.exists) return null;
    return UserModel.fromJson(
      Map<String, dynamic>.from(snapshot.data() as Map),
    );
  }

  @override
  Future<UserModel> create(String tenantId, UserModel user) async {
    final json = user.toJson();
    final ref = _rootRef(tenantId).doc(user.id);
    await ref.set(json);
    final snapshot = await ref.get();
    if (!snapshot.exists) {
      throw Exception('Failed to read user after create');
    }
    return UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
  }

  @override
  Future<void> delete(String tenantId, String userId) async {
    final ref = _rootRef(tenantId).doc(userId);
    await ref.delete();
    final snapshot = await ref.get();
    if (snapshot.exists) {
      throw Exception('Failed to read user after delete');
    }
  }

  @override
  Future<UserModel> update(String tenantId, UserModel user) async {
    final ref = _rootRef(tenantId).doc(user.id);
    await ref.set(user.toJson());
    final snapshot = await ref.get();
    if (!snapshot.exists) {
      throw Exception('Failed to read user after update');
    }
    return UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
  }
}

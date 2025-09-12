import 'package:pis_house_frontend/schemas/user_model.dart';

abstract class UserRepositoryInterface {
  Future<List<UserModel>> getByTenantId(String tenantId);
  Future<UserModel?> firstByTenantIdAndUserId(String tenantId, String userId);
  Future<UserModel> create(String tenantId, UserModel user);
  Future<void> delete(String tenantId, String userId);
  Future<UserModel> update(String tenantId, UserModel user);
}

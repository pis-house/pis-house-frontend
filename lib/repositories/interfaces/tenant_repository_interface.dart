import 'package:pis_house_frontend/schemas/tenant_model.dart';

abstract class TenantRepositoryInterface {
  Future<TenantModel?> firstByTenantId(String tenantId);
  Future<TenantModel> create(TenantModel tenant);
  Future<void> delete(String tenantId);
  Future<TenantModel> update(TenantModel tenant);
}

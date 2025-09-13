import 'package:pis_house_frontend/repositories/interfaces/tenant_repository_interface.dart';
import 'package:pis_house_frontend/schemas/tenant_model.dart';
import 'package:pis_house_frontend/repositories/mocks/id.dart';

class MockTenantRepository implements TenantRepositoryInterface {
  final Map<String, TenantModel> _store = {
    mockTenantId: TenantModel(
      id: mockTenantId,
      name: 'Tenant ABC',
      createdAt: DateTime.parse('2025-09-12T06:00:00.000Z'),
      updatedAt: DateTime.parse('2025-09-12T06:00:00.000Z'),
    ),
  };

  @override
  Future<TenantModel?> firstByTenantId(String tenantId) async {
    return _store[tenantId];
  }

  @override
  Future<TenantModel?> firstByTenantName(String tenantName) async {
    try {
      final found = _store.values.where((tenant) => tenant.name == tenantName);
      return found.isNotEmpty ? found.first : null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<TenantModel> create(TenantModel tenant) async {
    _store[tenant.id] = tenant;
    return tenant;
  }

  @override
  Future<void> delete(String tenantId) async {
    _store.remove(tenantId);
  }

  @override
  Future<TenantModel> update(TenantModel tenant) async {
    _store[tenant.id] = tenant;
    return tenant;
  }
}

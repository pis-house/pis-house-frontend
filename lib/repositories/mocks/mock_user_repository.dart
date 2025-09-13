import 'package:pis_house_frontend/repositories/interfaces/user_repository_interface.dart';
import 'package:pis_house_frontend/schemas/user_model.dart';
import 'package:pis_house_frontend/repositories/mocks/id.dart';

class MockUserRepository implements UserRepositoryInterface {
  final Map<String, Map<String, UserModel>> _store = {
    mockTenantId: {
      mockUserId1: UserModel(
        id: mockUserId1,
        displayName: 'Tanaka',
        isAdmin: true,
        preferredAirconTemperature: 25.0,
        preferredLightBrightnessPercent: 80,
        createdAt: DateTime.parse('2025-09-12T06:00:00.000Z'),
        updatedAt: DateTime.parse('2025-09-12T06:00:00.000Z'),
      ),
      mockUserId2: UserModel(
        id: mockUserId2,
        displayName: 'Suzuki',
        isAdmin: false,
        preferredAirconTemperature: 22.0,
        preferredLightBrightnessPercent: 60,
        createdAt: DateTime.parse('2025-09-11T08:00:00.000Z'),
        updatedAt: DateTime.parse('2025-09-11T08:00:00.000Z'),
      ),
    },
  };

  @override
  Future<List<UserModel>> getByTenantId(String tenantId) async {
    return _store[tenantId]?.values.toList() ?? [];
  }

  @override
  Future<UserModel?> firstByTenantIdAndUserId(
    String tenantId,
    String userId,
  ) async {
    return _store[tenantId]?[userId];
  }

  @override
  Future<UserModel> create(String tenantId, UserModel user) async {
    _store.putIfAbsent(tenantId, () => {})[user.id] = user;
    return user;
  }

  @override
  Future<void> delete(String tenantId, String userId) async {
    _store[tenantId]?.remove(userId);
  }

  @override
  Future<UserModel> update(String tenantId, UserModel user) async {
    _store[tenantId]?[user.id] = user;
    return user;
  }
}

import 'package:pis_house_frontend/schemas/indoor_area_model.dart';
import 'package:pis_house_frontend/schemas/indoor_area_subscription_model.dart';

abstract class IndoorAreaRepositoryInterface {
  Future<IndoorAreaModel?> firstByTenantIdAndIndoorAreaId(
    String tenantId,
    String indoorAreaId,
  );
  Stream<List<IndoorAreaSubscriptionModel>> getSubscribeByTenantId(
    String integrationId,
    String tenantId,
  );
  Future<IndoorAreaModel> create(String tenantId, IndoorAreaModel indoorArea);
  Future<void> delete(String tenantId, String indoorAreaId);
  Future<IndoorAreaModel> update(String tenantId, IndoorAreaModel indoorArea);
}

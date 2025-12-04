import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pis_house_frontend/repositories/interfaces/indoor_area_repository_interface.dart';
import 'package:pis_house_frontend/schemas/device_model.dart';
import 'package:pis_house_frontend/schemas/indoor_area_model.dart';
import 'package:pis_house_frontend/schemas/indoor_area_subscription_model.dart';
import 'package:pis_house_frontend/schemas/setup_device_model.dart';
import 'package:rxdart/rxdart.dart';

class IndoorAreaRepository implements IndoorAreaRepositoryInterface {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference _rootRef(String tenantId) {
    return _db.collection("tenants").doc(tenantId).collection("indoor_areas");
  }

  CollectionReference<Map<String, dynamic>> _setupDeviceRef(
    String integrationId,
  ) {
    return _db.collection('setup').doc(integrationId).collection('devices');
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
  Stream<List<IndoorAreaSubscriptionModel>> getSubscribeByTenantId(
    String integrationId,
    String tenantId,
  ) {
    return _rootRef(tenantId).snapshots().switchMap((indoorAreasSnapshot) {
      if (indoorAreasSnapshot.docs.isEmpty) {
        return Stream.value([]);
      }
      final areaSubscriptionStreams = indoorAreasSnapshot.docs.map((areaDoc) {
        final indoorArea = IndoorAreaModel.fromJson(
          areaDoc.data() as Map<String, dynamic>,
        );
        return _rootRef(tenantId)
            .doc(indoorArea.id)
            .collection("devices")
            .snapshots()
            .switchMap((devicesSnapshot) {
              if (devicesSnapshot.docs.isEmpty) {
                return Stream.value(
                  IndoorAreaSubscriptionModel(
                    deviceSubscriptions: [],
                    indoorArea: indoorArea,
                  ),
                );
              }

              final deviceSubscriptionStreams = devicesSnapshot.docs.map((
                deviceDoc,
              ) {
                final device = DeviceModel.fromJson(deviceDoc.data());

                final setupDeviceStream = _setupDeviceRef(integrationId)
                    .doc(device.setupDeviceId)
                    .snapshots()
                    .map((setupDoc) {
                      return SetupDeviceModel.fromJson(setupDoc.data()!);
                    });

                return Rx.combineLatest2(
                  Stream.value(device),
                  setupDeviceStream,
                  (DeviceModel d, SetupDeviceModel sd) {
                    return DeviceSubscriptionModel(device: d, setupDevice: sd);
                  },
                );
              }).toList();
              return Rx.combineLatest(deviceSubscriptionStreams, (
                List<DeviceSubscriptionModel> deviceSubs,
              ) {
                return IndoorAreaSubscriptionModel(
                  deviceSubscriptions: deviceSubs,
                  indoorArea: indoorArea,
                );
              });
            });
      }).toList();

      return Rx.combineLatest(
        areaSubscriptionStreams,
        (List<IndoorAreaSubscriptionModel> subscriptions) => subscriptions,
      );
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

final indoorAreaRepositoryProvider = Provider<IndoorAreaRepositoryInterface>(
  (ref) => IndoorAreaRepository(),
);

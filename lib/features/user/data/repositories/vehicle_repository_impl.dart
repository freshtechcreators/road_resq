import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/vehicle_entity.dart';
import '../../domain/repositories/vehicle_repository.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final FirebaseFirestore _firestore;

  VehicleRepositoryImpl(this._firestore);

  @override
  Future<void> addVehicle(VehicleEntity vehicle) async {
    await _firestore.collection('vehicles').doc(vehicle.id).set(vehicle.toMap());
  }

  @override
  Future<void> updateVehicle(VehicleEntity vehicle) async {
    await _firestore.collection('vehicles').doc(vehicle.id).update(vehicle.toMap());
  }

  @override
  Future<void> deleteVehicle(String vehicleId) async {
    await _firestore.collection('vehicles').doc(vehicleId).delete();
  }

  @override
  Stream<List<VehicleEntity>> getVehicles(String userId) {
    return _firestore
        .collection('vehicles')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => VehicleEntity.fromMap(doc.data()))
        .toList());
  }
}
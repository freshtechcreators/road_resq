import '../entities/vehicle_entity.dart';

abstract class VehicleRepository {
  Future<void> addVehicle(VehicleEntity vehicle);
  Future<void> updateVehicle(VehicleEntity vehicle);
  Future<void> deleteVehicle(String vehicleId);
  Stream<List<VehicleEntity>> getVehicles(String userId);
}
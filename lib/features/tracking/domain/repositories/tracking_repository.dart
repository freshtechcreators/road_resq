import '../entities/live_location_entity.dart';

abstract class TrackingRepository {
  Future<void> updateLocation(String mechanicId, double lat, double lng);
  Stream<LiveLocationEntity> getMechanicLocation(String mechanicId);
  Future<List<double>> getRoutePoints(double startLat, double startLng, double endLat, double endLng);
}

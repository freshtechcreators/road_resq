import '../repositories/tracking_repository.dart';

class GetRoutePointsUseCase {
  final TrackingRepository _repository;

  GetRoutePointsUseCase(this._repository);

  Future<List<double>> call(double startLat, double startLng, double endLat, double endLng) {
    return _repository.getRoutePoints(startLat, startLng, endLat, endLng);
  }
}

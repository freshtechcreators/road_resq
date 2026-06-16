import '../repositories/tracking_repository.dart';

class UpdateLocationUseCase {
  final TrackingRepository _repository;

  UpdateLocationUseCase(this._repository);

  Future<void> call(String mechanicId, double lat, double lng) {
    return _repository.updateLocation(mechanicId, lat, lng);
  }
}

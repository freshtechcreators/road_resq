import '../entities/live_location_entity.dart';
import '../repositories/tracking_repository.dart';

class GetMechanicLocationUseCase {
  final TrackingRepository _repository;

  GetMechanicLocationUseCase(this._repository);

  Stream<LiveLocationEntity> call(String mechanicId) {
    return _repository.getMechanicLocation(mechanicId);
  }
}

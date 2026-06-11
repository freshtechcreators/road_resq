import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class UpdateBookingStatusUseCase {
  final BookingRepository _repository;

  UpdateBookingStatusUseCase(this._repository);

  Future<void> call(String bookingId, BookingStatus status) {
    return _repository.updateBookingStatus(bookingId, status);
  }
}

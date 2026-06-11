import '../entities/booking_entity.dart';
import '../repositories/booking_repository.dart';

class GetBookingStreamUseCase {
  final BookingRepository _repository;

  GetBookingStreamUseCase(this._repository);

  Stream<BookingEntity?> call(String bookingId) {
    return _repository.getBookingStream(bookingId);
  }
}

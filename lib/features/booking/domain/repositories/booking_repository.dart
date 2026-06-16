import '../entities/booking_entity.dart';

abstract class BookingRepository {
  Future<void> createBooking(BookingEntity booking);
  Stream<BookingEntity?> getBookingStream(String bookingId);
  Future<void> updateBookingStatus(String bookingId, BookingStatus status);
  Stream<List<BookingEntity>> getUserBookings(String userId);
}

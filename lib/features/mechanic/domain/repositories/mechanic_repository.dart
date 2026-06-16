import '../../../auth/domain/entities/mechanic_entity.dart';
import '../../../booking/domain/entities/booking_entity.dart';

abstract class MechanicRepository {
  Stream<MechanicEntity?> getMechanicProfile(String uid);
  Future<void> updateMechanicProfile(MechanicEntity mechanic);
  Future<void> updateAvailability(String uid, bool isOnline);
  Stream<List<BookingEntity>> getPendingBookings();
  Stream<List<BookingEntity>> getMechanicBookings(String mechanicId);
  Future<void> acceptBooking(String bookingId, String mechanicId);
  Future<void> updateBookingStatus(String bookingId, BookingStatus status);
  Future<double> getEarnings(String mechanicId);
}

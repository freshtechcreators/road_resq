import '../../../auth/domain/entities/mechanic_entity.dart';
import '../../../booking/domain/entities/booking_entity.dart';
import '../repositories/mechanic_repository.dart';

class GetMechanicProfileUseCase {
  final MechanicRepository repository;
  GetMechanicProfileUseCase(this.repository);
  Stream<MechanicEntity?> call(String uid) => repository.getMechanicProfile(uid);
}

class UpdateMechanicProfileUseCase {
  final MechanicRepository repository;
  UpdateMechanicProfileUseCase(this.repository);
  Future<void> call(MechanicEntity mechanic) => repository.updateMechanicProfile(mechanic);
}

class UpdateAvailabilityUseCase {
  final MechanicRepository repository;
  UpdateAvailabilityUseCase(this.repository);
  Future<void> call(String uid, bool isOnline) => repository.updateAvailability(uid, isOnline);
}

class GetPendingBookingsUseCase {
  final MechanicRepository repository;
  GetPendingBookingsUseCase(this.repository);
  Stream<List<BookingEntity>> call() => repository.getPendingBookings();
}

class GetMechanicBookingsUseCase {
  final MechanicRepository repository;
  GetMechanicBookingsUseCase(this.repository);
  Stream<List<BookingEntity>> call(String mechanicId) => repository.getMechanicBookings(mechanicId);
}

class AcceptBookingUseCase {
  final MechanicRepository repository;
  AcceptBookingUseCase(this.repository);
  Future<void> call(String bookingId, String mechanicId) => repository.acceptBooking(bookingId, mechanicId);
}

class UpdateBookingStatusUseCase {
  final MechanicRepository repository;
  UpdateBookingStatusUseCase(this.repository);
  Future<void> call(String bookingId, BookingStatus status) => repository.updateBookingStatus(bookingId, status);
}

class GetEarningsUseCase {
  final MechanicRepository repository;
  GetEarningsUseCase(this.repository);
  Future<double> call(String mechanicId) => repository.getEarnings(mechanicId);
}

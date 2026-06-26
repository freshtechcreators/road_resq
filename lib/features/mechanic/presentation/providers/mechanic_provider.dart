import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/mechanic_repository.dart';
import '../../data/repositories/mechanic_repository_impl.dart';
import '../../domain/usecases/mechanic_usecases.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/domain/entities/mechanic_entity.dart';
import '../../../booking/domain/entities/booking_entity.dart';

final mechanicRepositoryProvider = Provider<MechanicRepository>((ref) {
  return MechanicRepositoryImpl(FirebaseFirestore.instance);
});

final getMechanicProfileUseCaseProvider = Provider((ref) => GetMechanicProfileUseCase(ref.watch(mechanicRepositoryProvider)));
final updateMechanicProfileUseCaseProvider = Provider((ref) => UpdateMechanicProfileUseCase(ref.watch(mechanicRepositoryProvider)));
final updateAvailabilityUseCaseProvider = Provider((ref) => UpdateAvailabilityUseCase(ref.watch(mechanicRepositoryProvider)));
final getPendingBookingsUseCaseProvider = Provider((ref) => GetPendingBookingsUseCase(ref.watch(mechanicRepositoryProvider)));
final getMechanicBookingsUseCaseProvider = Provider((ref) => GetMechanicBookingsUseCase(ref.watch(mechanicRepositoryProvider)));
final acceptBookingUseCaseProvider = Provider((ref) => AcceptBookingUseCase(ref.watch(mechanicRepositoryProvider)));
final updateBookingStatusUseCaseProvider = Provider((ref) => UpdateBookingStatusUseCase(ref.watch(mechanicRepositoryProvider)));
final getEarningsUseCaseProvider = Provider((ref) => GetEarningsUseCase(ref.watch(mechanicRepositoryProvider)));

final mechanicProfileProvider = StreamProvider<MechanicEntity?>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value(null);
  return ref.watch(getMechanicProfileUseCaseProvider).call(user.uid);
});

final pendingBookingsProvider = StreamProvider<List<BookingEntity>>((ref) {
  return ref.watch(getPendingBookingsUseCaseProvider).call();
});

final mechanicBookingsProvider = StreamProvider<List<BookingEntity>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);
  return ref.watch(getMechanicBookingsUseCaseProvider).call(user.uid);
});

final earningsProvider = StreamProvider<double>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value(0.0);
  return ref.watch(getEarningsUseCaseProvider).call(user.uid);
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../data/repositories/booking_repository_impl.dart';
import '../../domain/usecases/create_booking_usecase.dart';
import '../../domain/usecases/get_booking_stream_usecase.dart';
import '../../domain/usecases/update_booking_status_usecase.dart';
import '../../domain/entities/booking_entity.dart';

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return BookingRepositoryImpl(FirebaseFirestore.instance);
});

final createBookingUseCaseProvider = Provider<CreateBookingUseCase>((ref) {
  return CreateBookingUseCase(ref.watch(bookingRepositoryProvider));
});

final getBookingStreamUseCaseProvider = Provider<GetBookingStreamUseCase>((ref) {
  return GetBookingStreamUseCase(ref.watch(bookingRepositoryProvider));
});

final updateBookingStatusUseCaseProvider = Provider<UpdateBookingStatusUseCase>((ref) {
  return UpdateBookingStatusUseCase(ref.watch(bookingRepositoryProvider));
});

final currentBookingStreamProvider = StreamProvider.family<BookingEntity?, String>((ref, bookingId) {
  return ref.watch(getBookingStreamUseCaseProvider).call(bookingId);
});

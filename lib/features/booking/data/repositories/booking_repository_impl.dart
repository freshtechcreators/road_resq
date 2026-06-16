import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/booking_repository.dart';
import '../models/booking_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final FirebaseFirestore _firestore;

  BookingRepositoryImpl(this._firestore);

  @override
  Future<void> createBooking(BookingEntity booking) async {
    final model = BookingModel.fromEntity(booking);
    await _firestore.collection('bookings').doc(model.bookingId).set(model.toJson());
  }

  @override
  Stream<BookingEntity?> getBookingStream(String bookingId) {
    return _firestore
        .collection('bookings')
        .doc(bookingId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return BookingModel.fromJson(snapshot.data()!);
      }
      return null;
    });
  }

  @override
  Future<void> updateBookingStatus(String bookingId, BookingStatus status) async {
    await _firestore.collection('bookings').doc(bookingId).update({
      'status': status.name,
    });
  }

  @override
  Stream<List<BookingEntity>> getUserBookings(String userId) {
    // Removed .orderBy() to avoid requiring a composite index in Firestore.
    // Sorting can be done in the UI or Provider.
    return _firestore
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final bookings = snapshot.docs
          .map((doc) => BookingModel.fromJson(doc.data()))
          .toList();
      // Sort in memory: newest first
      bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return bookings;
    });
  }
}

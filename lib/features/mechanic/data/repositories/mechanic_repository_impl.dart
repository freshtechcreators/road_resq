import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../auth/data/models/mechanic_model.dart';
import '../../../auth/domain/entities/mechanic_entity.dart';
import '../../../booking/data/models/booking_model.dart';
import '../../../booking/domain/entities/booking_entity.dart';
import '../../domain/repositories/mechanic_repository.dart';

class MechanicRepositoryImpl implements MechanicRepository {
  final FirebaseFirestore _firestore;

  MechanicRepositoryImpl(this._firestore);

  @override
  Stream<MechanicEntity?> getMechanicProfile(String uid) {
    return _firestore
        .collection('mechanics')
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists ? MechanicModel.fromMap(doc.data()!) : null);
  }

  @override
  Future<void> updateMechanicProfile(MechanicEntity mechanic) {
    return _firestore
        .collection('mechanics')
        .doc(mechanic.uid)
        .set(MechanicModel.fromEntity(mechanic).toMap(), SetOptions(merge: true));
  }

  @override
  Future<void> updateAvailability(String uid, bool isOnline) {
    return _firestore.collection('mechanics').doc(uid).update({'isOnline': isOnline});
  }

  @override
  Stream<List<BookingEntity>> getPendingBookings() {
    return _firestore
        .collection('bookings')
        .where('status', isEqualTo: BookingStatus.REQUESTED.name)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map<BookingEntity>((doc) => BookingModel.fromJson(doc.data()))
            .toList());
  }

  @override
  Stream<List<BookingEntity>> getMechanicBookings(String mechanicId) {
    return _firestore
        .collection('bookings')
        .where('mechanicId', isEqualTo: mechanicId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map<BookingEntity>((doc) => BookingModel.fromJson(doc.data()))
            .toList());
  }

  @override
  Future<void> acceptBooking(String bookingId, String mechanicId) {
    return _firestore.collection('bookings').doc(bookingId).update({
      'mechanicId': mechanicId,
      'status': BookingStatus.ACCEPTED.name,
    });
  }

  @override
  Future<void> updateBookingStatus(String bookingId, BookingStatus status) {
    return _firestore.collection('bookings').doc(bookingId).update({'status': status.name});
  }

  @override
  Stream<double> getEarnings(String mechanicId) {
    return _firestore
        .collection('bookings')
        .where('mechanicId', isEqualTo: mechanicId)
        .where('status', isEqualTo: BookingStatus.COMPLETED.name)
        .snapshots()
        .map((snapshot) => snapshot.docs.length * 500.0);
  }
}

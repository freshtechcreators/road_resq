import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/booking_entity.dart';

class BookingModel extends BookingEntity {
  BookingModel({
    required super.bookingId,
    required super.userId,
    required super.vehicleId,
    required super.issueType,
    required super.latitude,
    required super.longitude,
    required super.status,
    required super.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      bookingId: json['bookingId'],
      userId: json['userId'],
      vehicleId: json['vehicleId'],
      issueType: IssueType.values.byName(json['issueType']),
      latitude: json['latitude'],
      longitude: json['longitude'],
      status: BookingStatus.values.byName(json['status']),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'userId': userId,
      'vehicleId': vehicleId,
      'issueType': issueType.name,
      'latitude': latitude,
      'longitude': longitude,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory BookingModel.fromEntity(BookingEntity entity) {
    return BookingModel(
      bookingId: entity.bookingId,
      userId: entity.userId,
      vehicleId: entity.vehicleId,
      issueType: entity.issueType,
      latitude: entity.latitude,
      longitude: entity.longitude,
      status: entity.status,
      createdAt: entity.createdAt,
    );
  }
}

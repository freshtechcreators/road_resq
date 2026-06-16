import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/booking_entity.dart';

class BookingModel extends BookingEntity {
  BookingModel({
    required super.bookingId,
    required super.userId,
    super.mechanicId,
    required super.vehicleId,
    required super.issueType,
    required super.latitude,
    required super.longitude,
    required super.status,
    required super.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      bookingId: json['bookingId'] ?? '',
      userId: json['userId'] ?? '',
      mechanicId: json['mechanicId'],
      vehicleId: json['vehicleId'] ?? '',
      issueType: IssueType.values.byName(json['issueType'] ?? IssueType.FLAT_TIRE.name),
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      status: BookingStatus.values.byName(json['status'] ?? BookingStatus.REQUESTED.name),
      createdAt: json['createdAt'] != null 
          ? (json['createdAt'] as Timestamp).toDate() 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'userId': userId,
      'mechanicId': mechanicId,
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
      mechanicId: entity.mechanicId,
      vehicleId: entity.vehicleId,
      issueType: entity.issueType,
      latitude: entity.latitude,
      longitude: entity.longitude,
      status: entity.status,
      createdAt: entity.createdAt,
    );
  }
}

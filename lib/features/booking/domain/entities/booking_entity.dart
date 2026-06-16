enum BookingStatus {
  REQUESTED,
  ACCEPTED,
  ARRIVING,
  COMPLETED,
  CANCELLED
}

enum IssueType {
  FLAT_TIRE,
  BATTERY_PROBLEM,
  FUEL_DELIVERY,
  ENGINE_FAILURE,
  TOWING,
  ACCIDENT_ASSISTANCE
}

class BookingEntity {
  final String bookingId;
  final String userId;
  final String? mechanicId;
  final String vehicleId;
  final IssueType issueType;
  final double latitude;
  final double longitude;
  final BookingStatus status;
  final DateTime createdAt;

  BookingEntity({
    required this.bookingId,
    required this.userId,
    this.mechanicId,
    required this.vehicleId,
    required this.issueType,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.createdAt,
  });

  BookingEntity copyWith({
    String? bookingId,
    String? userId,
    String? mechanicId,
    String? vehicleId,
    IssueType? issueType,
    double? latitude,
    double? longitude,
    BookingStatus? status,
    DateTime? createdAt,
  }) {
    return BookingEntity(
      bookingId: bookingId ?? this.bookingId,
      userId: userId ?? this.userId,
      mechanicId: mechanicId ?? this.mechanicId,
      vehicleId: vehicleId ?? this.vehicleId,
      issueType: issueType ?? this.issueType,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

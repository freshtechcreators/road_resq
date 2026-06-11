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
  final String vehicleId;
  final IssueType issueType;
  final double latitude;
  final double longitude;
  final BookingStatus status;
  final DateTime createdAt;

  BookingEntity({
    required this.bookingId,
    required this.userId,
    required this.vehicleId,
    required this.issueType,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.createdAt,
  });
}

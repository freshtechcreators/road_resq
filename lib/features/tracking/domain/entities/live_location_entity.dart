class LiveLocationEntity {
  final String mechanicId;
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  LiveLocationEntity({
    required this.mechanicId,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });
}

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/live_location_entity.dart';

class LiveLocationModel extends LiveLocationEntity {
  LiveLocationModel({
    required super.mechanicId,
    required super.latitude,
    required super.longitude,
    required super.timestamp,
  });

  factory LiveLocationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      return LiveLocationModel(
        mechanicId: doc.id,
        latitude: 0.0,
        longitude: 0.0,
        timestamp: DateTime.now(),
      );
    }
    return LiveLocationModel(
      mechanicId: data['mechanicId'] ?? doc.id,
      latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'mechanicId': mechanicId,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}

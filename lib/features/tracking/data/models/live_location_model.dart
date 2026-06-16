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
    final data = doc.data() as Map<String, dynamic>;
    return LiveLocationModel(
      mechanicId: data['mechanicId'] ?? '',
      latitude: (data['latitude'] as num).toDouble(),
      longitude: (data['longitude'] as num).toDouble(),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
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

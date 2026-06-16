import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/live_location_entity.dart';
import '../../domain/repositories/tracking_repository.dart';
import '../models/live_location_model.dart';

class TrackingRepositoryImpl implements TrackingRepository {
  final FirebaseFirestore _firestore;

  TrackingRepositoryImpl(this._firestore);

  @override
  Future<void> updateLocation(String mechanicId, double lat, double lng) async {
    final model = LiveLocationModel(
      mechanicId: mechanicId,
      latitude: lat,
      longitude: lng,
      timestamp: DateTime.now(),
    );
    await _firestore.collection('live_locations').doc(mechanicId).set(model.toFirestore());
  }

  @override
  Stream<LiveLocationEntity> getMechanicLocation(String mechanicId) {
    return _firestore
        .collection('live_locations')
        .doc(mechanicId)
        .snapshots()
        .map((doc) => LiveLocationModel.fromFirestore(doc));
  }

  @override
  Future<List<double>> getRoutePoints(double startLat, double startLng, double endLat, double endLng) async {
    // In a real app, you'd use Google Directions API here.
    // For this task, I'll provide a helper to fetch polyline points if an API key is provided,
    // otherwise it returns a direct line.
    
    if (AppConstants.googleMapsApiKey == 'AIzaSyAv8HSm8p8ct5ZPr799sBk3H2aTaREDbik') {
       return [startLat, startLng, endLat, endLng];
    }

    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$startLat,$startLng&destination=$endLat,$endLng&key=${AppConstants.googleMapsApiKey}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['routes'].isNotEmpty) {
          final polyline = data['routes'][0]['overview_polyline']['points'];
          return _decodePolyline(polyline);
        }
      }
    } catch (e) {
      print('Error fetching route: $e');
    }
    return [startLat, startLng, endLat, endLng];
  }

  List<double> _decodePolyline(String encoded) {
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> result = polylinePoints.decodePolyline(encoded);
    return result.expand((p) => [p.latitude, p.longitude]).toList();
  }
}

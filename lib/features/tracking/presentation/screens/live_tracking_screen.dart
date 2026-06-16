import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../../booking/presentation/providers/booking_provider.dart';
import '../providers/tracking_provider.dart';

class LiveTrackingScreen extends ConsumerStatefulWidget {
  final String bookingId;
  const LiveTrackingScreen({super.key, required this.bookingId});

  @override
  ConsumerState<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends ConsumerState<LiveTrackingScreen> {
  GoogleMapController? _controller;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  String _eta = 'Calculating...';
  String _distance = '';
  bool _isInitialCameraSet = false;

  @override
  Widget build(BuildContext context) {
    final bookingAsync = ref.watch(currentBookingStreamProvider(widget.bookingId));
    final booking = bookingAsync.value;

    // Listen to mechanic location updates to update the map
    if (booking != null && booking.mechanicId != null) {
      ref.listen(mechanicLocationStreamProvider(booking.mechanicId!), (previous, next) {
        final mechanicLoc = next.value;
        if (mechanicLoc != null) {
          _updateMapData(booking.latitude, booking.longitude, mechanicLoc.latitude, mechanicLoc.longitude);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Track Mechanic')),
      body: bookingAsync.when(
        data: (booking) {
          if (booking == null) {
            return const Center(child: Text('Booking not found.'));
          }
          
          if (booking.mechanicId == null) {
             return const Center(child: Text('Waiting for mechanic to be assigned...'));
          }

          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(booking.latitude, booking.longitude),
                  zoom: 14,
                ),
                onMapCreated: (controller) {
                  _controller = controller;
                  // Trigger initial data load if mechanic location is already available
                  final mechLoc = ref.read(mechanicLocationStreamProvider(booking.mechanicId!)).value;
                  if (mechLoc != null) {
                    _updateMapData(booking.latitude, booking.longitude, mechLoc.latitude, mechLoc.longitude);
                  }
                },
                markers: _markers,
                polylines: _polylines,
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Estimated Arrival', style: TextStyle(color: Colors.grey)),
                            Text(_eta, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
                          ],
                        ),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Distance', style: TextStyle(color: Colors.grey)),
                            Text(_distance, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Future<void> _updateMapData(double userLat, double userLng, double mechLat, double mechLng) async {
    final userLatLng = LatLng(userLat, userLng);
    final mechLatLng = LatLng(mechLat, mechLng);

    // 1. Update Markers
    setState(() {
      _markers.clear();
      _markers.add(Marker(
        markerId: const MarkerId('user'),
        position: userLatLng,
        infoWindow: const InfoWindow(title: 'User Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ));
      _markers.add(Marker(
        markerId: const MarkerId('mechanic'),
        position: mechLatLng,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: const InfoWindow(title: 'Mechanic Location'),
      ));
    });

    // 2. Calculate Distance & ETA
    final double distanceInMeters = Geolocator.distanceBetween(mechLat, mechLng, userLat, userLng);
    final distStr = '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
    // Assume 40 km/h average speed (approx 666 meters per minute)
    final minutes = (distanceInMeters / 666).ceil();
    final etaStr = minutes <= 1 ? 'Arriving soon' : '$minutes mins';

    if (mounted) {
      setState(() {
        _distance = distStr;
        _eta = etaStr;
      });
    }

    // 3. Update Camera to show both markers
    if (_controller != null) {
      final bounds = LatLngBounds(
        southwest: LatLng(
          mechLat < userLat ? mechLat : userLat,
          mechLng < userLng ? mechLng : userLng,
        ),
        northeast: LatLng(
          mechLat > userLat ? mechLat : userLat,
          mechLng > userLng ? mechLng : userLng,
        ),
      );

      if (!_isInitialCameraSet) {
        _controller!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
        _isInitialCameraSet = true;
      } else {
        // Just move slightly if needed, or keep zoom if preferred
        // For now, keep it dynamic but with padding
        _controller!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
      }
    }

    // 4. Fetch Route Polyline
    try {
      final points = await ref.read(getRoutePointsUseCaseProvider).call(mechLat, mechLng, userLat, userLng);
      if (points.isNotEmpty && mounted) {
        final List<LatLng> latLngPoints = [];
        for (int i = 0; i < points.length; i += 2) {
          latLngPoints.add(LatLng(points[i], points[i + 1]));
        }
        setState(() {
          _polylines.clear();
          _polylines.add(Polyline(
            polylineId: const PolylineId('route'),
            points: latLngPoints,
            color: Colors.blue,
            width: 5,
            jointType: JointType.round,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
          ));
        });
      }
    } catch (e) {
      debugPrint('Error updating route: $e');
    }
  }
}

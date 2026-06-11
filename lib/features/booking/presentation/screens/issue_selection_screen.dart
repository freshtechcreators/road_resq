import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/booking_entity.dart';
import '../providers/booking_provider.dart';
import '../../../user/presentation/providers/vehicle_provider.dart';
import '../../../user/domain/entities/vehicle_entity.dart';

class IssueSelectionScreen extends ConsumerStatefulWidget {
  final double latitude;
  final double longitude;

  const IssueSelectionScreen({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  ConsumerState<IssueSelectionScreen> createState() => _IssueSelectionScreenState();
}

class _IssueSelectionScreenState extends ConsumerState<IssueSelectionScreen> {
  IssueType? _selectedIssue;
  VehicleEntity? _selectedVehicle;

  final List<Map<String, dynamic>> _issues = [
    {'type': IssueType.FLAT_TIRE, 'icon': Icons.tire_repair, 'label': 'Flat Tire'},
    {'type': IssueType.BATTERY_PROBLEM, 'icon': Icons.battery_alert, 'label': 'Battery Problem'},
    {'type': IssueType.FUEL_DELIVERY, 'icon': Icons.local_gas_station, 'label': 'Fuel Delivery'},
    {'type': IssueType.ENGINE_FAILURE, 'icon': Icons.engineering, 'label': 'Engine Failure'},
    {'type': IssueType.TOWING, 'icon': Icons.car_repair, 'label': 'Towing'},
    {'type': IssueType.ACCIDENT_ASSISTANCE, 'icon': Icons.emergency, 'label': 'Accident Assistance'},
  ];

  Future<void> _createBooking() async {
    if (_selectedIssue == null || _selectedVehicle == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an issue and a vehicle')),
      );
      return;
    }

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final bookingId = const Uuid().v4();
    final booking = BookingEntity(
      bookingId: bookingId,
      userId: userId,
      vehicleId: _selectedVehicle!.id,
      issueType: _selectedIssue!,
      latitude: widget.latitude,
      longitude: widget.longitude,
      status: BookingStatus.REQUESTED,
      createdAt: DateTime.now(),
    );

    try {
      await ref.read(createBookingUseCaseProvider).call(booking);
      if (mounted) {
        context.pushReplacement('/booking-status/$bookingId');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating booking: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehiclesAsyncValue = ref.watch(vehiclesStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Select Issue')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What happened?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.5,
              ),
              itemCount: _issues.length,
              itemBuilder: (context, index) {
                final issue = _issues[index];
                final isSelected = _selectedIssue == issue['type'];
                return InkWell(
                  onTap: () => setState(() => _selectedIssue = issue['type']),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.red.withOpacity(0.1) : Colors.grey[200],
                      border: Border.all(
                        color: isSelected ? Colors.red : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(issue['icon'], color: isSelected ? Colors.red : Colors.black),
                        const SizedBox(height: 8),
                        Text(
                          issue['label'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Select Vehicle',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            vehiclesAsyncValue.when(
              data: (vehicles) {
                if (vehicles.isEmpty) {
                  return Column(
                    children: [
                      const Text('No vehicles found.'),
                      TextButton(
                        onPressed: () => context.push('/add-vehicle'),
                        child: const Text('Add a Vehicle'),
                      ),
                    ],
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: vehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = vehicles[index];
                    return RadioListTile<VehicleEntity>(
                      title: Text(vehicle.name),
                      subtitle: Text(vehicle.registrationNumber),
                      value: vehicle,
                      groupValue: _selectedVehicle,
                      onChanged: (value) => setState(() => _selectedVehicle = value),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('Error: $err'),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _createBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Confirm Emergency Request'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

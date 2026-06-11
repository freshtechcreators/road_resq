import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/vehicle_entity.dart';
import '../providers/vehicle_provider.dart';

class VehicleListScreen extends ConsumerWidget {
  const VehicleListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehiclesAsync = ref.watch(vehiclesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Vehicles'),
        actions: [
          // Added SOS button to access the Booking Module
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton.icon(
              onPressed: () => context.push('/sos'),
              icon: const Icon(Icons.warning_amber_rounded, color: Colors.red),
              label: const Text(
                'SOS',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: vehiclesAsync.when(
        data: (vehicles) => vehicles.isEmpty
            ? const Center(child: Text('No vehicles added yet.'))
            : ListView.builder(
          itemCount: vehicles.length,
          itemBuilder: (context, index) {
            final vehicle = vehicles[index];
            return ListTile(
              leading: Icon(vehicle.type == VehicleType.car ? Icons.directions_car : Icons.motorcycle),
              title: Text(vehicle.name),
              subtitle: Text(vehicle.registrationNumber),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => ref.read(vehicleRepositoryProvider).deleteVehicle(vehicle.id),
              ),
              onTap: () => context.push('/edit-vehicle', extra: vehicle),
            );
          },
        ),
        error: (e, st) => Center(child: Text('Error: $e')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-vehicle'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/vehicle_entity.dart';
import '../providers/vehicle_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../booking/presentation/providers/booking_provider.dart';
import '../../../booking/domain/entities/booking_entity.dart';

class VehicleListScreen extends ConsumerWidget {
  const VehicleListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehiclesAsync = ref.watch(vehiclesStreamProvider);
    final activeBookingsAsync = ref.watch(userBookingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Vehicles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'My Bookings',
            onPressed: () => context.push('/user-bookings'),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profile',
            onPressed: () {
              ref.read(userRoleProvider.notifier).state = 'user';
              context.push('/create-profile');
            },
          ),
          TextButton.icon(
            onPressed: () => context.push('/sos'),
            icon: const Icon(Icons.warning_amber_rounded, color: Colors.red),
            label: const Text(
              'SOS',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Logout', style: TextStyle(color: Colors.red))),
                  ],
                ),
              );

              if (confirmed == true) {
                await ref.read(authRepositoryProvider).signOut();
                if (context.mounted) context.go('/login');
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          activeBookingsAsync.when(
            data: (bookings) {
              final active = bookings.where((b) => b.status != BookingStatus.COMPLETED && b.status != BookingStatus.CANCELLED).toList();
              if (active.isEmpty) return const SizedBox.shrink();

              final booking = active.first;
              return Card(
                color: Colors.red.shade50,
                margin: const EdgeInsets.all(16),
                child: ListTile(
                  leading: const Icon(Icons.warning, color: Colors.red),
                  title: const Text('Ongoing Emergency Request', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Status: ${booking.status.name}'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => context.push('/booking-status/${booking.bookingId}'),
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          Expanded(
            child: vehiclesAsync.when(
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-vehicle'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

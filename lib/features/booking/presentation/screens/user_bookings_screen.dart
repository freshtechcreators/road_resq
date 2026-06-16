import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/booking_provider.dart';
import '../../domain/entities/booking_entity.dart';

class UserBookingsScreen extends ConsumerWidget {
  const UserBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(userBookingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('My Emergency Requests')),
      body: bookingsAsync.when(
        data: (bookings) {
          if (bookings.isEmpty) {
            return const Center(child: Text('No requests found.'));
          }
          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final isActive = booking.status != BookingStatus.COMPLETED &&
                  booking.status != BookingStatus.CANCELLED;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: Icon(
                    isActive ? Icons.pending_actions : Icons.check_circle,
                    color: isActive ? Colors.orange : Colors.green,
                  ),
                  title: Text(booking.issueType.name.replaceAll('_', ' ')),
                  subtitle: Text('Status: ${booking.status.name}\n${booking.createdAt.toString().split('.')[0]}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => context.push('/booking-status/${booking.bookingId}'),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading bookings: $e')),
      ),
    );
  }
}
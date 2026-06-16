import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/mechanic_provider.dart';
import '../../../booking/domain/entities/booking_entity.dart';

class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myBookingsAsync = ref.watch(mechanicBookingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
      ),
      body: myBookingsAsync.when(
        data: (bookings) => bookings.isEmpty
            ? const Center(child: Text('You have no active or past bookings.'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Icon(
                        booking.status == BookingStatus.COMPLETED ? Icons.check_circle : Icons.pending_actions,
                        color: booking.status == BookingStatus.COMPLETED ? Colors.green : Colors.orange,
                      ),
                      title: Text(
                        booking.issueType.name.replaceAll('_', ' '),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Status: ${booking.status.name}'),
                          Text(
                            'Date: ${booking.createdAt.day}/${booking.createdAt.month}/${booking.createdAt.year}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => context.push('/booking-details/${booking.bookingId}'),
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

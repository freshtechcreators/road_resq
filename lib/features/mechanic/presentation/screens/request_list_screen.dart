import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/mechanic_provider.dart' hide mechanicProfileProvider;
import '../../../booking/domain/entities/booking_entity.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class RequestListScreen extends ConsumerWidget {
  const RequestListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingBookingsAsync = ref.watch(pendingBookingsProvider);
    final profileAsync = ref.watch(mechanicProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Requests'),
      ),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) return const Center(child: Text('Profile not found'));
          
          if (!profile.isOnline) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_off, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'You are currently OFFLINE',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Please go online from the dashboard to accept new requests.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }

          return pendingBookingsAsync.when(
            data: (bookings) => bookings.isEmpty
                ? const Center(child: Text('No pending requests nearby.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      return _RequestCard(booking: booking);
                    },
                  ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _RequestCard extends ConsumerWidget {
  final BookingEntity booking;
  const _RequestCard({required this.booking});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    booking.issueType.name.replaceAll('_', ' '),
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                Text(
                  '${booking.createdAt.hour}:${booking.createdAt.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Icon(Icons.location_on, color: Colors.grey, size: 16),
                SizedBox(width: 4),
                Text('Location Captured', style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.push('/booking-details/${booking.bookingId}');
                    },
                    child: const Text('Details'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () async {
                      final profile = ref.read(mechanicProfileProvider).value;
                      if (profile != null && profile.isOnline) {
                        await ref.read(acceptBookingUseCaseProvider).call(
                              booking.bookingId,
                              profile.uid,
                            );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Request Accepted!')),
                          );
                          context.pushReplacement('/booking-details/${booking.bookingId}');
                        }
                      } else {
                         ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('You must be online to accept requests.')),
                          );
                      }
                    },
                    child: const Text('Accept', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

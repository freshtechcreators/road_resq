import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/booking_entity.dart';
import '../providers/booking_provider.dart';

class BookingStatusScreen extends ConsumerWidget {
  final String bookingId;

  const BookingStatusScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingAsync = ref.watch(currentBookingStreamProvider(bookingId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Status'),
        actions: [
          IconButton(
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      body: bookingAsync.when(
        data: (booking) {
          if (booking == null) {
            return const Center(child: Text('Booking not found'));
          }

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatusIcon(booking.status),
                const SizedBox(height: 24),
                Text(
                  _getStatusText(booking.status),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDetailsCard(booking),
                const SizedBox(height: 32),
                if (booking.status == BookingStatus.REQUESTED)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _cancelBooking(ref, context),
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                      child: const Text('Cancel Request'),
                    ),
                  ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildStatusIcon(BookingStatus status) {
    IconData iconData;
    Color color;

    switch (status) {
      case BookingStatus.REQUESTED:
        iconData = Icons.hourglass_empty;
        color = Colors.orange;
        break;
      case BookingStatus.ACCEPTED:
        iconData = Icons.check_circle_outline;
        color = Colors.blue;
        break;
      case BookingStatus.ARRIVING:
        iconData = Icons.directions_car;
        color = Colors.green;
        break;
      case BookingStatus.COMPLETED:
        iconData = Icons.verified;
        color = Colors.green;
        break;
      case BookingStatus.CANCELLED:
        iconData = Icons.cancel;
        color = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, size: 80, color: color),
    );
  }

  String _getStatusText(BookingStatus status) {
    switch (status) {
      case BookingStatus.REQUESTED:
        return 'Searching for Mechanics...';
      case BookingStatus.ACCEPTED:
        return 'Mechanic Assigned';
      case BookingStatus.ARRIVING:
        return 'Mechanic is on the way';
      case BookingStatus.COMPLETED:
        return 'Service Completed';
      case BookingStatus.CANCELLED:
        return 'Booking Cancelled';
    }
  }

  Widget _buildDetailsCard(BookingEntity booking) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDetailRow('Issue', booking.issueType.name.replaceAll('_', ' ')),
            const Divider(),
            _buildDetailRow('Booking ID', booking.bookingId.substring(0, 8)),
            const Divider(),
            _buildDetailRow('Time', booking.createdAt.toString().substring(11, 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Future<void> _cancelBooking(WidgetRef ref, BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking?'),
        content: const Text('Are you sure you want to cancel this emergency request?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Yes, Cancel')),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(updateBookingStatusUseCaseProvider).call(bookingId, BookingStatus.CANCELLED);
    }
  }
}

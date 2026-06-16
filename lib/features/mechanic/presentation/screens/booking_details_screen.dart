import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../booking/domain/entities/booking_entity.dart';
import '../../../tracking/presentation/providers/mechanic_location_update_provider.dart';
import '../providers/mechanic_provider.dart';

class BookingDetailsScreen extends ConsumerWidget {
  final String bookingId;
  const BookingDetailsScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(pendingBookingsProvider);
    final myBookingsAsync = ref.watch(mechanicBookingsProvider);

    // Combine both lists into a single list of BookingEntity
    final List<BookingEntity> allBookings = [
      ...?bookingsAsync.value,
      ...?myBookingsAsync.value,
    ];

    final booking = allBookings.where((b) => b.bookingId == bookingId).firstOrNull;

    if (booking == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Booking Details')),
        body: Center(
          child: (bookingsAsync.isLoading || myBookingsAsync.isLoading)
              ? const CircularProgressIndicator()
              : const Text('Booking not found or loading...'),
        ),
      );
    }

    // If status is ARRIVING, trigger location updates
    if (booking.status == BookingStatus.ARRIVING) {
      ref.watch(mechanicLocationUpdateProvider(booking.bookingId));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Booking #${booking.bookingId.substring(0, 8)}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusHeader(booking.status),
            const SizedBox(height: 20),
            _buildSectionTitle('Issue Details'),
            _buildInfoTile(Icons.report_problem, 'Type', booking.issueType.name.replaceAll('_', ' ')),
            _buildInfoTile(Icons.calendar_today, 'Requested At', booking.createdAt.toString()),
            const SizedBox(height: 20),
            _buildSectionTitle('Location'),
            _buildInfoTile(Icons.location_on, 'Coordinates', '${booking.latitude}, ${booking.longitude}'),
            const SizedBox(height: 30),
            _buildActionButtons(context, ref, booking),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeader(BookingStatus status) {
    Color color;
    switch (status) {
      case BookingStatus.REQUESTED: color = Colors.orange; break;
      case BookingStatus.ACCEPTED: color = Colors.blue; break;
      case BookingStatus.ARRIVING: color = Colors.purple; break;
      case BookingStatus.COMPLETED: color = Colors.green; break;
      case BookingStatus.CANCELLED: color = Colors.red; break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        'Status: ${status.name}',
        textAlign: TextAlign.center,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref, BookingEntity booking) {
    if (booking.status == BookingStatus.REQUESTED) {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async {
                final profile = ref.read(mechanicProfileProvider).value;
                if (profile != null) {
                  await ref.read(acceptBookingUseCaseProvider).call(booking.bookingId, profile.uid);
                  if (context.mounted) Navigator.pop(context);
                }
              },
              child: const Text('Accept Request', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      );
    }

    if (booking.status == BookingStatus.ACCEPTED) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
              onPressed: () async {
                await ref.read(updateBookingStatusUseCaseProvider).call(booking.bookingId, BookingStatus.ARRIVING);
              },
              child: const Text('Start Journey', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      );
    }

    if (booking.status == BookingStatus.ARRIVING) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.map),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () => context.push('/tracking/${booking.bookingId}'),
              label: const Text('Open Tracking Map', style: TextStyle(color: Colors.white)),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async {
                await ref.read(updateBookingStatusUseCaseProvider).call(booking.bookingId, BookingStatus.COMPLETED);
              },
              child: const Text('Mark as Completed', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }
}

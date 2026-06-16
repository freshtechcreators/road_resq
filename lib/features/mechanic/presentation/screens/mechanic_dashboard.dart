import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../booking/domain/entities/booking_entity.dart';
import '../providers/mechanic_provider.dart' hide mechanicProfileProvider;
import '../../../auth/presentation/providers/auth_provider.dart';

class MechanicDashboardScreen extends ConsumerWidget {
  const MechanicDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(mechanicProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mechanic Dashboard'),
        actions: [
          profileAsync.when(
            data: (profile) => profile == null
                ? const SizedBox()
                : Switch(
                    value: profile.isOnline,
                    onChanged: (value) {
                      ref.read(updateAvailabilityUseCaseProvider).call(profile.uid, value);
                    },
                    activeColor: Colors.green,
                  ),
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
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
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Logout', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                await ref.read(authRepositoryProvider).signOut();
                if (context.mounted) {
                  context.go('/login');
                }
              }
            },
          ),
        ],
      ),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) return const Center(child: Text('Profile not found'));
          return RefreshIndicator(
            onRefresh: () => ref.refresh(mechanicProfileProvider.future),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHeader(profile),
                  const SizedBox(height: 24),
                  _buildStatCards(ref),
                  const SizedBox(height: 24),
                  const Text(
                    'Quick Actions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildActionButtons(context, ref),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildProfileHeader(profile) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: profile.profileImage != null && profile.profileImage!.isNotEmpty
              ? MemoryImage(const Base64Decoder().convert(profile.profileImage!))
              : null,
          child: (profile.profileImage == null || profile.profileImage!.isEmpty) ? const Icon(Icons.person, size: 30) : null,
        ),
        title: Text(profile.name ?? 'No Name', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(profile.shopName ?? 'Independent Mechanic'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: profile.isOnline ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            profile.isOnline ? 'ONLINE' : 'OFFLINE',
            style: TextStyle(
              color: profile.isOnline ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCards(WidgetRef ref) {
    final earningsAsync = ref.watch(earningsProvider);
    final bookingsAsync = ref.watch(mechanicBookingsProvider);

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: 'Earnings',
            value: earningsAsync.when(
              data: (e) => '₹$e',
              loading: () => '...',
              error: (_, __) => 'Error',
            ),
            icon: Icons.account_balance_wallet,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            title: 'Active Jobs',
            value: bookingsAsync.when(
              data: (list) => list.where((b) => b.status != BookingStatus.COMPLETED && b.status != BookingStatus.CANCELLED).length.toString(),
              loading: () => '...',
              error: (_, __) => '0',
            ),
            icon: Icons.assignment_turned_in,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _ActionButton(
          title: 'New Requests',
          icon: Icons.notifications_active,
          color: Colors.red,
          onTap: () => context.push('/request-list'),
        ),
        _ActionButton(
          title: 'My Bookings',
          icon: Icons.history,
          color: Colors.green,
          onTap: () => context.push('/my-bookings'),
        ),
        _ActionButton(
          title: 'Earnings',
          icon: Icons.payments,
          color: Colors.purple,
          onTap: () => context.push('/earnings'),
        ),
        _ActionButton(
          title: 'Profile Settings',
          icon: Icons.settings,
          color: Colors.grey,
          onTap: () {
            ref.read(userRoleProvider.notifier).state = 'mechanic';
            context.push('/create-profile');
          },
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({required this.title, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: color.withOpacity(0.1),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

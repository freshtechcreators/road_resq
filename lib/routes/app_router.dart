import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:road_resq/features/auth/presentation/screens/splash_screen.dart';
import 'package:road_resq/features/auth/presentation/screens/login_screen.dart';
import 'package:road_resq/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:road_resq/features/auth/presentation/screens/create_profile_screen.dart';
import 'package:road_resq/features/booking/presentation/screens/sos_screen.dart';
import 'package:road_resq/features/booking/presentation/screens/issue_selection_screen.dart';
import 'package:road_resq/features/booking/presentation/screens/booking_status_screen.dart';
import 'package:road_resq/features/mechanic/presentation/screens/mechanic_dashboard.dart';
import 'package:road_resq/features/mechanic/presentation/screens/request_list_screen.dart';
import 'package:road_resq/features/mechanic/presentation/screens/my_bookings_screen.dart';
import 'package:road_resq/features/mechanic/presentation/screens/booking_details_screen.dart';
import 'package:road_resq/features/mechanic/presentation/screens/earnings_screen.dart';
import 'package:road_resq/features/tracking/presentation/screens/live_tracking_screen.dart';

import '../features/booking/presentation/screens/user_bookings_screen.dart';
import '../features/user/presentation/screens/add_vehicle_screen.dart';
import '../features/user/presentation/screens/vehicle_list_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) => const OTPVerificationScreen(),
      ),
      GoRoute(
        path: '/create-profile',
        builder: (context, state) => const CreateProfileScreen(),
      ),
      GoRoute(
        path: '/vehicles',
        builder: (context, state) => const VehicleListScreen(),
      ),
      GoRoute(
        path: '/add-vehicle',
        builder: (context, state) => const AddVehicleScreen(),
      ),
      GoRoute(
        path: '/sos',
        builder: (context, state) => const SOSScreen(),
      ),
      GoRoute(
        path: '/issue-selection',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return IssueSelectionScreen(
            latitude: extra['latitude'],
            longitude: extra['longitude'],
          );
        },
      ),
      GoRoute(
        path: '/booking-status/:bookingId',
        builder: (context, state) => BookingStatusScreen(
          bookingId: state.pathParameters['bookingId']!,
        ),
      ),
      GoRoute(
        path: '/mechanic-dashboard',
        builder: (context, state) => const MechanicDashboardScreen(),
      ),
      GoRoute(
        path: '/request-list',
        builder: (context, state) => const RequestListScreen(),
      ),
      GoRoute(
        path: '/my-bookings',
        builder: (context, state) => const MyBookingsScreen(),
      ),
      GoRoute(
        path: '/booking-details/:bookingId',
        builder: (context, state) => BookingDetailsScreen(
          bookingId: state.pathParameters['bookingId']!,
        ),
      ),
      GoRoute(
        path: '/earnings',
        builder: (context, state) => const EarningsScreen(),
      ),
      GoRoute(
        path: '/tracking/:bookingId',
        builder: (context, state) => LiveTrackingScreen(
          bookingId: state.pathParameters['bookingId']!,
        ),
      ),
      GoRoute(
        path: '/user-bookings',
        builder: (context, state) => UserBookingsScreen(),
      ),
    ],
  );
});

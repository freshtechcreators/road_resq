import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:road_resq/features/auth/presentation/screens/splash_screen.dart';
import 'package:road_resq/features/auth/presentation/screens/login_screen.dart';
import 'package:road_resq/features/auth/presentation/screens/otp_verification_screen.dart';
import 'package:road_resq/features/auth/presentation/screens/create_profile_screen.dart';

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
    ],
  );
});

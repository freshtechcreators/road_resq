import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:road_resq/features/auth/presentation/providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    
    // We can use the stream provider to check the state, 
    // but for splash logic, usually we check once.
    final authState = ref.read(authStateProvider);
    
    authState.when(
      data: (user) {
        if (user != null) {
          // If user exists, we might need to check if profile is created
          // For now, redirect to login or home (if it existed)
          // Since we only have auth, let's go to Login for now if not authenticated
          context.go('/login');
        } else {
          context.go('/login');
        }
      },
      loading: () {},
      error: (_, __) => context.go('/login'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(seconds: 2),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.scale(
                scale: 0.8 + (value * 0.2),
                child: child,
              ),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/app_logo1.png',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 30),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

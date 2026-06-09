import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:road_resq/features/auth/presentation/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendOTP() async {
    if (_phoneController.text.isEmpty) return;

    setState(() => _isLoading = true);

    final sendOTP = ref.read(sendOTPUseCaseProvider);
    
    try {
      await sendOTP(
        _phoneController.text.trim(),
        onCodeSent: (verificationId) {
          ref.read(verificationIdProvider.notifier).state = verificationId;
          setState(() => _isLoading = false);
          context.push('/otp');
        },
        onError: (e) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        },
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(userRoleProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to RoadResQ',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'user', label: Text('User')),
                ButtonSegment(value: 'mechanic', label: Text('Mechanic')),
              ],
              selected: {role},
              onSelectionChanged: (newSelection) {
                ref.read(userRoleProvider.notifier).state = newSelection.first;
              },
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Mobile Number',
                hintText: '+1234567890',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _sendOTP,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Send OTP'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

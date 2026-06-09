import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:road_resq/features/auth/presentation/providers/auth_provider.dart';

class OTPVerificationScreen extends ConsumerStatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  ConsumerState<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends ConsumerState<OTPVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  Future<void> _verifyOTP() async {
    final verificationId = ref.read(verificationIdProvider);
    if (verificationId == null || _otpController.text.length < 6) return;

    setState(() => _isLoading = true);

    final verifyOTP = ref.read(verifyOTPUseCaseProvider);

    try {
      await verifyOTP(
        verificationId: verificationId,
        smsCode: _otpController.text.trim(),
      );
      
      if (!mounted) return;
      setState(() => _isLoading = false);
      
      // Navigate to profile creation after successful OTP verification
      context.go('/create-profile');
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification Failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter the 6-digit code sent to your phone',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _otpController,
              decoration: const InputDecoration(
                labelText: 'OTP Code',
                border: OutlineInputBorder(),
                counterText: '',
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, letterSpacing: 8),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _verifyOTP,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Verify'),
              ),
            ),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Change Phone Number'),
            ),
          ],
        ),
      ),
    );
  }
}

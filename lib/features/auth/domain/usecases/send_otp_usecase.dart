import 'package:road_resq/features/auth/domain/repositories/auth_repository.dart';

class SendOTPUseCase {
  final AuthRepository repository;

  SendOTPUseCase(this.repository);

  Future<void> call(String phoneNumber, {
    required Function(String verificationId) onCodeSent,
    required Function(Exception e) onError,
  }) {
    return repository.sendOTP(phoneNumber, onCodeSent: onCodeSent, onError: onError);
  }
}

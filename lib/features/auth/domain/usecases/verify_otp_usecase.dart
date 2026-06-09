import 'package:road_resq/features/auth/domain/repositories/auth_repository.dart';

class VerifyOTPUseCase {
  final AuthRepository repository;

  VerifyOTPUseCase(this.repository);

  Future<void> call({
    required String verificationId,
    required String smsCode,
  }) {
    return repository.verifyOTP(verificationId: verificationId, smsCode: smsCode);
  }
}

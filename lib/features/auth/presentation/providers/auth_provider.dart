import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:road_resq/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:road_resq/features/auth/domain/repositories/auth_repository.dart';
import 'package:road_resq/features/auth/domain/usecases/save_profile_usecase.dart';
import 'package:road_resq/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:road_resq/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:road_resq/features/auth/domain/entities/user_entity.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
    FirebaseStorage.instance,
  );
});

final sendOTPUseCaseProvider = Provider<SendOTPUseCase>((ref) {
  return SendOTPUseCase(ref.watch(authRepositoryProvider));
});

final verifyOTPUseCaseProvider = Provider<VerifyOTPUseCase>((ref) {
  return VerifyOTPUseCase(ref.watch(authRepositoryProvider));
});

final saveProfileUseCaseProvider = Provider<SaveProfileUseCase>((ref) {
  return SaveProfileUseCase(ref.watch(authRepositoryProvider));
});

final authStateProvider = StreamProvider<UserEntity?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

final verificationIdProvider = StateProvider<String?>((ref) => null);
final userRoleProvider = StateProvider<String>((ref) => 'user'); // 'user' or 'mechanic'

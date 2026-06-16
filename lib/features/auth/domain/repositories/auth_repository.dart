import 'dart:io';
import 'package:road_resq/features/auth/domain/entities/user_entity.dart';
import 'package:road_resq/features/auth/domain/entities/mechanic_entity.dart';

abstract class AuthRepository {
  Future<void> sendOTP(String phoneNumber, {
    required Function(String verificationId) onCodeSent,
    required Function(Exception e) onError,
  });

  Future<void> verifyOTP({
    required String verificationId,
    required String smsCode,
  });

  Future<void> saveUserProfile(UserEntity user);
  Future<void> saveMechanicProfile(MechanicEntity mechanic);

  Future<String> uploadProfileImage(File imageFile, String uid);

  Future<String?> getUserRole(String uid);
  Future<UserEntity?> getUserProfile(String uid);
  Future<MechanicEntity?> getMechanicProfile(String uid);

  Stream<UserEntity?> get authStateChanges;
  Future<void> signOut();
}

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
import 'package:road_resq/features/auth/domain/entities/mechanic_entity.dart';
import 'package:road_resq/features/auth/data/models/user_model.dart';
import 'package:road_resq/features/auth/data/models/mechanic_model.dart';

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

final userRoleProvider = StateProvider<String>((ref) => 'user'); // 'user' or 'mechanic'

final userProfileProvider = StreamProvider<UserEntity?>((ref) {
  final authState = ref.watch(authStateProvider);
  final role = ref.watch(userRoleProvider);
  
  return authState.when(
    data: (user) {
      if (user == null || role != 'user') return Stream.value(null);
      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .map((doc) => doc.exists ? UserModel.fromMap(doc.data()!) : null)
          .handleError((error) {
            // Suppress permission-denied errors during logout or role transitions
          });
    },
    loading: () => const Stream.empty(),
    error: (e, s) => Stream.error(e, s),
  );
});

final mechanicProfileProvider = StreamProvider<MechanicEntity?>((ref) {
  final authState = ref.watch(authStateProvider);
  final role = ref.watch(userRoleProvider);
  
  return authState.when(
    data: (user) {
      if (user == null || role != 'mechanic') return Stream.value(null);
      return FirebaseFirestore.instance
          .collection('mechanics')
          .doc(user.uid)
          .snapshots()
          .map((doc) => doc.exists ? MechanicModel.fromMap(doc.data()!) : null)
          .handleError((error) {
            // Suppress permission-denied errors during logout or role transitions
          });
    },
    loading: () => const Stream.empty(),
    error: (e, s) => Stream.error(e, s),
  );
});

final verificationIdProvider = StateProvider<String?>((ref) => null);

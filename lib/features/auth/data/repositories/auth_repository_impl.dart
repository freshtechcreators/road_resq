import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:road_resq/features/auth/data/models/mechanic_model.dart';
import 'package:road_resq/features/auth/data/models/user_model.dart';
import 'package:road_resq/features/auth/domain/entities/mechanic_entity.dart';
import 'package:road_resq/features/auth/domain/entities/user_entity.dart';
import 'package:road_resq/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl(this._auth, this._firestore);

  @override
  Future<void> sendOTP(String phoneNumber, {
    required Function(String verificationId) onCodeSent,
    required Function(Exception e) onError,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        onError(e);
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Future<void> verifyOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    await _auth.signInWithCredential(credential);
  }

  @override
  Future<void> saveUserProfile(UserEntity user) async {
    final userModel = UserModel.fromEntity(user);
    await _firestore.collection('users').doc(user.uid).set(userModel.toMap());
  }

  @override
  Future<void> saveMechanicProfile(MechanicEntity mechanic) async {
    final mechanicModel = MechanicModel.fromEntity(mechanic);
    await _firestore.collection('mechanics').doc(mechanic.uid).set(mechanicModel.toMap());
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _auth.authStateChanges().map((user) {
      if (user == null) return null;
      return UserEntity(uid: user.uid, phoneNumber: user.phoneNumber ?? '');
    });
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }
}

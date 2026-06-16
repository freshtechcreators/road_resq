import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:road_resq/features/auth/data/models/mechanic_model.dart';
import 'package:road_resq/features/auth/data/models/user_model.dart';
import 'package:road_resq/features/auth/domain/entities/mechanic_entity.dart';
import 'package:road_resq/features/auth/domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  AuthRepositoryImpl(this._auth, this._firestore, this._storage);

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
  Future<String> uploadProfileImage(File imageFile, String uid) async {
    try {
      final ref = _storage.ref().child('profile_images').child('$uid.jpg');
      final snapshot = await ref.putFile(imageFile);
      final url = await snapshot.ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      rethrow;
    }
  }

  @override
  Future<String?> getUserRole(String uid) async {
    final userDoc = await _firestore.collection('users').doc(uid).get();
    if (userDoc.exists) return 'user';

    final mechanicDoc = await _firestore.collection('mechanics').doc(uid).get();
    if (mechanicDoc.exists) return 'mechanic';

    return null;
  }

  @override
  Future<UserEntity?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  }

  @override
  Future<MechanicEntity?> getMechanicProfile(String uid) async {
    final doc = await _firestore.collection('mechanics').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return MechanicModel.fromMap(doc.data()!);
    }
    return null;
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
